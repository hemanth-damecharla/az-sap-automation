# SDAF Architectural Refactoring Blueprint (Phase 1)

Status: **Draft for decision** — no production code has been changed.
Scope: `deploy/terraform`, `deploy/ansible`, `boilerplate/`, and the lint/CI
configuration that governs them.

---

## 0. Executive summary

The request asks for three things that are in tension and must be ordered
explicitly before any code is written:

1. A clean, plugin-extensible architecture (Terraform add-ons, Ansible
   collection with provider roles).
2. **100% feature parity** with SDAF as it exists today.
3. A rewrite carried out module-by-module "without stubs".

The audit numbers below (507 Terraform resources across 5 child modules with
zero `moved` blocks, ~64k lines of Ansible YAML in 73 roles, 1,282
`shell`/`command` tasks, ~700 `pcs`/`crm` invocations) mean a full rewrite with
parity is a multi-quarter programme, not a single change set. The blueprint
therefore recommends a **strangler-fig migration**: build the new framework
alongside the existing one, behind the same entry points, migrate one
capability at a time with state-preserving `moved` blocks and parity tests,
and retire legacy code only when a capability's parity test passes.

Five assumptions in the brief do not hold as written and need a decision
(Section 6). The most consequential:

- **`terraform fmt -check` contradicts the repository's hard rule** (CLAUDE.md:
  "never run `terraform fmt`", wide column-aligned `=`). Both cannot be
  enforced on the same files.
- **Terraform has no runtime plugin mechanism.** Module `source` must be a
  static literal; "dynamic composition without editing core code" is only
  achievable through separate root modules (state boundaries) consuming a
  published contract, not through in-module dynamic loading.
- **A large part of the proposed Ansible role catalogue already exists** in
  `community.sap_install` / `community.sap_infrastructure` (sap-linuxlab).
  Re-implementing `sap_hana_install`, `sap_swpm`, `sap_ha_pacemaker_cluster`
  duplicates maintained upstream code; the build-vs-adopt decision should
  precede Phase 3.

---

## 1. Audit: current pain points and coupling

All figures were measured on commit `9386267` with grep/awk; they are
indicative, not exact (see false-positive notes).

### 1.1 Terraform

| Finding | Evidence | Impact |
|---|---|---|
| Monolithic child modules | `sap_system/app_tier` ≈3.9k lines, `hdb_node` ≈3.0k, `common_infrastructure` ≈2.5k; `sap_landscape` and `sap_deployer` are single modules mixing network, KV, storage, DNS, VMs, NSP, App Config, RBAC | No independent versioning or reuse; any change re-plans an entire tier; test surface is coarse |
| "God object" inputs | `run/*/tfvar_variables.tf` = 4,769 lines of flat variables, re-packed in `transform.tf` (1,462 lines) into nested `infrastructure`/`databases`/`application_tier` maps passed as `any`-shaped objects | Two parallel input schemas (flat tfvars + nested objects); defaults resolved with `try()` **1,139 times**, which silently masks typos and type errors |
| Weak input contracts | 1,321 variables, 156 `validation` blocks (~12%), ~64 variables without `type` | Errors surface at apply time in Azure rather than at plan |
| `count` over `for_each` | 616 `count` vs 94 `for_each` | Index-based addresses; removing a VM from the middle of a list recreates its successors |
| No refactor-safe state history | 0 `moved` blocks, 0 `import` blocks in modules | Any restructuring breaks every existing customer state unless `moved` blocks are added — this is the single largest migration risk |
| State coupling via `terraform_remote_state` | `run/sap_system/module.tf` passes the whole `landscape_tfstate.outputs` object into four modules | Consumers depend on the entire output surface of the landscape state; no versioned contract; requires read access to the full state blob (which contains secrets in plain text) |
| bootstrap/run duplication | `bootstrap/sap_deployer` vs `run/sap_deployer`: same file set, 115 diff lines in `tfvar_variables.tf` alone | Every input change must be made twice; drift is already present |
| Terraform → Ansible contract is implicit | `sap_system/output_files` renders `sap-parameters.yaml` and the inventory with `local_file` + `.tmpl` | The single most important interface in SDAF has no schema; Ansible discovers missing keys at runtime |
| Credential paths | `providers.tf` supports `use_spn` with `client_secret` from Key Vault (42 references); MSI is the alternative | SPN secrets remain a first-class path; OIDC (workload identity federation) is not the default |
| Public exposure | `azurerm_public_ip` for deployer VM, Bastion, Firewall, NAT GW; `bootstrap/*` hard-code `public_network_access_enabled = true` (commented as a private-DNS chicken-and-egg constraint) | Deployer PIP should be off by default; NAT/Bastion/Firewall PIPs are legitimate. The bootstrap constraint is real and needs a two-pass design, not a flag flip |

False positive noted: the grep for `source_address_prefix = "*"` hits
`deny-inbound-traffic` rules (`sap_landscape/subnets.tf:300`,
`common_infrastructure/nsgs.tf:146`) — those are correct deny rules, not
permissive allows. A real NSG audit needs rule-by-rule review, not grep.

Strengths to preserve: mock-provider `terraform test` suites exist for every
root module; tflint/checkov/terraform-docs/trivy already run in CI; ephemeral
Key Vault secret reads; AAD auth on the state backend; provider aliases for
cross-subscription DNS.

### 1.2 Ansible

| Finding | Evidence | Impact |
|---|---|---|
| Not a collection | No `galaxy.yml`; roles live in `roles-*` directories with numeric names (`5.5-hanadb-pacemaker`) | Cannot be versioned, installed, or consumed independently; FQCN references to own roles impossible |
| Playbooks as orchestration logic | `playbook_04_00_00_db_install.yaml` = 1,317 lines, 54 `include_role`s, branching on `platform == 'ORACLE'/'DB2'/'SYBASE'/'SQLSERVER'` | Playbook mixes Type and Landscape concerns; adding an engine means editing the playbook |
| Imperative everything | 1,282 `shell`/`command` tasks; ~700 `pcs`/`crm` invocations; 143 `lineinfile`/`blockinfile` | Idempotency and check mode depend on hand-written `changed_when`; `.ansible-lint` skips `no-changed-when`, which hides exactly this |
| OS branching by file name | `5.5.4.1-cluster-RedHat.yml` / `-Suse.yml`, `5.6.4.2-sap-resources-{RedHat,Suse}[-SimpleMount].yml` | Fencing, resource agents and OS are combined in one file; 2×2×N explosion |
| Fencing embedded in base cluster role | `1.17-generic-pacemaker/tasks/main.yml` switches on `scs_cluster_type in ['ASD','ISCSI']` | Adding a fencing type touches the core role |
| Legacy fact access | 662 `ansible_os_family`/`ansible_distribution` references, 0 `ansible_facts[...]` | Breaks when `INJECT_FACTS_AS_VARS` is disabled (planned default change in ansible-core) |
| Inventory coupling | `groups[(sap_sid | upper) ~ '_DB']` etc. inside roles | Roles cannot run against a differently shaped inventory |
| No input validation | 0 `meta/argument_specs.yml`; 26 roles have `defaults/`, 19 have `vars/` | Failures occur mid-play; no documented role interface |
| Lint suppressed | `.ansible-lint` skips `var-naming`, `role-name`, `no-changed-when`, `key-order`, most `yaml[*]` | The current profile is far below `production`; enabling it will produce thousands of findings |
| Dead code | `roles-db/obsolete 4.1.3-ora-dg` (directory name contains a space) | Breaks naive tooling (it broke this audit's `find | xargs`) |
| No Molecule | none | Parity of a rewrite cannot be demonstrated without new test harnesses |

### 1.3 Cross-cutting coupling (the parity surface)

Any refactor must keep these stable, or provide shims:

- **Entry points**: `deploy/scripts/installer.sh` resolves
  `deploy/terraform/run/${deployment_system}` and `bootstrap/...` by path;
  six files across pipelines/scripts/Webapp reference `playbook_0x_*.yaml`
  by name.
- **Input format**: `boilerplate/WORKSPACES/*/*.tfvars` and Webapp-generated
  tfvars (flat variable names). Renaming a variable is a breaking change for
  every customer workspace and for the Webapp.
- **Output format**: `sap-parameters.yaml` keys consumed by Ansible and by
  downstream customer tooling (`platform`, `scs_cluster_type`,
  `database_cluster_type`, `use_msi_for_clusters`, `NFS_provider`,
  `bom_base_name`, ...).
- **State addresses**: 507 resources in customer state files.

---

## 2. Target architecture: Terraform

### 2.1 What "plugin" can and cannot mean in Terraform

Module sources are static; providers cannot be selected dynamically; a module
cannot "discover" add-ons. Three mechanisms remain, and the blueprint uses all
three for different purposes:

| Mechanism | Use for | Trade-off |
|---|---|---|
| **Separate root module per add-on** (own state) consuming a published contract | Monitoring, backup, ACSS, AMS, custom private endpoints — anything with an independent lifecycle | Cleanest isolation; requires a contract-distribution mechanism (2.3) |
| **Feature-toggled child modules inside a stack** (`count = var.x.enabled ? 1 : 0` on a statically declared module) | Capabilities tightly coupled to the core lifecycle (ANF vs NFS-on-Files, iSCSI SBD VMs) | Core stack must declare every option it supports; no third-party extension |
| **Extension hooks via input maps** (`additional_nsg_rules`, `additional_role_assignments`, `extra_private_endpoints`, `tags`) typed with `map(object({...}))` | Customer-specific additions to core resources | Bounded, validated, no forking |

"Custom HA fencing" is not a Terraform add-on: Terraform's part is only the
identity (MSI + role assignment) or the SBD target VMs/shared disks. It is
expressed as a typed `fencing` input that selects one of the statically
declared fencing infrastructure modules, plus an Ansible fencing role
(Section 3).

### 2.2 Layering

```
Stack (root module, own state)        Composition of child modules; no resources of its own
  └─ Capability modules (child)        One Azure concern each; versioned; AVM-backed where an AVM exists
       └─ AVM / raw azurerm resources
```

Stacks map 1:1 to the existing deployment stages so entry points and state
keys are unchanged: `control_plane/deployer`, `control_plane/library`,
`workload_zone`, `sap_system`, plus `addons/*`.

### 2.3 Contracts between stacks

Replace whole-state `terraform_remote_state` coupling with a **versioned
capability map**:

- Every stack emits one output, `capabilities`, of a declared
  `object({ schema_version = string, network = object(...), key_vault = ..., storage = ..., dns = ... })`
  type. Nothing else is part of the public surface.
- The capability map is additionally published to **Azure App Configuration**
  (already deployed by SDAF — `app-configuration.tf` in deployer/landscape/library)
  under a key per stack. Consumers read it with a data source and need only
  App Configuration Data Reader, not Storage Blob Data Reader on the state
  container (which exposes every secret in every state).
- `terraform_remote_state` remains as a compatibility fallback during
  migration, then is removed.
- The Terraform → Ansible contract is formalised the same way: a
  JSON Schema (`contracts/sap_parameters.schema.json`) that `output_files`
  renders against (validated in `terraform test`), and that the Ansible
  collection's `argument_specs.yml` mirrors.

### 2.4 Input design

- Keep the flat tfvars interface (customer compatibility) **as the only public
  input**; the stack's `variables.tf` is the contract and carries `type`,
  `description`, `validation` for every variable.
- Replace `transform.tf` + `try()` with typed `optional(type, default)`
  attributes on object variables inside child modules. `try()` is allowed only
  around genuinely dynamic lookups, never as a default mechanism.
- Convert index-addressed collections (`count`) to keyed `for_each` with
  `moved` blocks (`from = module.x.azurerm_linux_virtual_machine.vm[0]` →
  `to = module.x.azurerm_linux_virtual_machine.vm["app00"]`).

### 2.5 Security defaults

| Control | Default | Notes |
|---|---|---|
| Pipeline/auth | OIDC (workload identity federation) → MSI → SPN (deprecated, behind `allow_spn_secret = true`) | Keeps parity while inverting the default |
| Key Vault / Storage / App Config | `public_network_access_enabled = false`, private endpoint, RBAC authorisation, purge protection, TLS1.2 minimum | Bootstrap needs a **two-pass** apply (public during first pass from deployer, private after DNS exists); model this explicitly as `bootstrap_phase` rather than hard-coding `true` |
| Deployer VM | No public IP; access via Bastion | `deployer_public_ip_enabled` opt-in |
| CMK | `customer_managed_key = optional(object({ key_vault_key_id, identity_id }))` on storage, disks (Disk Encryption Set), ANF | Readiness, not mandatory |
| NSG | Default deny inbound per subnet; explicit allow rules from typed map; no `*` allows | Validation rejects `source_address_prefix = "*"` with `access = "Allow"` |
| RBAC | Role assignments scoped to resource, not RG/subscription; custom role for fencing agent (as per Microsoft's Pacemaker fencing guidance) | |

### 2.6 Lint and formatting gate

- `terraform validate`, `tflint --recursive`, `terraform test`, `checkov`,
  `trivy config`, `terraform-docs` drift check: already in CI; extended to new
  paths.
- `terraform fmt -check`: **decision required** (6.1).

---

## 3. Target architecture: Ansible

### 3.1 Collection layout

One collection, `azure.sap_automation`, is the default proposal. Splitting
into domain collections (`azure.sap_os`, `azure.sap_db`, `azure.sap_ha`) is
only justified if release cadences differ; today they do not, and splitting
multiplies dependency pinning. The provider-role pattern gives the same
isolation inside one collection.

### 3.2 Hierarchy mapping

| GPA level | SDAF artefact |
|---|---|
| Landscape | `playbooks/landscape_sap_system.yml` — imports Type playbooks in phase order (replaces the numbered playbook chain) |
| Type | `playbooks/types/{hana_node,anydb_node,scs_node,ers_node,pas_node,app_node,web_node,observer_node}.yml` — `roles:` only |
| Function | Roles (below) |
| Component | `roles/<role>/tasks/<component>.yml` |

The existing `playbook_0x_*.yaml` files become thin compatibility wrappers
(`ansible.builtin.import_playbook`) so pipelines, scripts, and the Webapp keep
working unchanged.

Note: the GPA source could not be fetched from this session
(`redhat-cop.github.io` is not in the network allowlist). Rules attributed to
GPA in this document are taken from the brief and must be re-verified against
the published text before Phase 3, per the repository's documentation rule.

### 3.3 Provider pattern — as independent roles

```
dispatcher role (sap_db)                     provider roles (independent, own argument_specs)
  sap_db_provider: hana  ───────────────▶   azure.sap_automation.sap_db_hana
                   db2   ───────────────▶   azure.sap_automation.sap_db_db2
                   oracle ──────────────▶   azure.sap_automation.sap_db_oracle
                   oracle_asm ──────────▶   azure.sap_automation.sap_db_oracle_asm
                   ase   ───────────────▶   azure.sap_automation.sap_db_ase
                   mssql ───────────────▶   azure.sap_automation.sap_db_mssql  (Windows)
```

Design constraint the brief omits: a free-form "FQCN variable" passed to
`include_role` lets any inventory author execute an arbitrary role with
`become`. The dispatcher therefore resolves the provider through a **registry
map** in `vars/main.yml`:

```yaml
__sap_db_provider_registry:
  hana: azure.sap_automation.sap_db_hana
  db2:  azure.sap_automation.sap_db_db2
```

and accepts an override only via an explicit
`sap_db_provider_registry_extra` (documented extension point for third-party
providers). `argument_specs.yml` constrains `sap_db_provider` to
`choices:` from the built-in registry plus that extension.

Dynamic `include_role` also defeats ansible-lint's static role resolution;
each provider role is therefore linted and Molecule-tested on its own.

### 3.4 Pacemaker — three orthogonal layers

```
ha_pacemaker_core              packages, corosync.conf (template), totem/quorum, cluster bootstrap, maintenance-mode helpers
ha_pacemaker_fence_azure_msi   fence_azure_arm with managed identity
ha_pacemaker_fence_azure_spn   fence_azure_arm with SPN (deprecated path; parity)
ha_pacemaker_fence_sbd_iscsi   iSCSI target login + SBD (current 'ISCSI')
ha_pacemaker_fence_sbd_disk    Azure shared disk SBD (current 'ASD')
ha_pacemaker_ra_hana_sr        SAPHanaSR / SAPHanaSR-angi, scale-up
ha_pacemaker_ra_hana_sr_scaleout
ha_pacemaker_ra_ascs_ers       ENSA1/ENSA2, incl. SimpleMount variant
ha_pacemaker_ra_db2_hadr
ha_pacemaker_ra_nfs_fs         Filesystem resources (non-SimpleMount)
```

OS differences (pcs vs crmsh, package names, resource-agent names) live in
each role's `vars/<os_family>.yml` deltas, not in separate task files. Where
the command language itself differs, a component file per CLI
(`tasks/cli_pcs.yml` / `tasks/cli_crmsh.yml`) is selected from a var — that
is a tool difference, not a provider, so it stays inside the role.

**On "declarative CIB XML"**: replacing the whole CIB (`cibadmin --replace`)
is unsafe — the CIB carries node IDs, epochs and status sections, and a stale
template will delete live state. The workable declarative pattern is
**per-resource CIB fragments** rendered from templates, compared against
`cibadmin --query --xpath`, and applied with `cibadmin --create/--modify` only
when they differ (`changed_when` derived from the comparison, `check_mode`
supported because the query is read-only). An alternative is to adopt
`fedora.linux_system_roles.ha_cluster` (declarative, idempotent, RHEL only)
plus crmsh-based fragments for SLES. Either way some `command` tasks remain;
"zero shell" is not achievable for Pacemaker on SLES today.

### 3.5 Variable hygiene

- Inputs: `<role>_*` in `defaults/main.yml`, declared in
  `meta/argument_specs.yml`.
- Internals: `__<role>_*` for registered vars and facts.
- Constants and platform maps: `vars/main.yml` plus sparse
  `vars/{os_family,distribution,distribution_major_version,distribution_version}.yml`
  loaded with `ansible.builtin.include_vars` over a `first_found`-free
  cascade (each file optional, later wins), via `ansible_facts['...']`.
  Identical deltas are symlinked (works in collection tarballs; verify with
  `ansible-galaxy collection build`).
- Clarification of the brief: "90%+ of common variables in `vars/main.yml`"
  applies to **constants** only. `vars/` has higher precedence than inventory
  and `group_vars`, so anything a user may need to change must stay in
  `defaults/`.
- Group names: roles receive host lists (`sap_db_hosts`, `ha_pacemaker_core_nodes`)
  from the Type playbook, which computes them from the inventory naming
  convention. The `<SID>_DB` convention survives only in the Type layer.

### 3.6 Build vs adopt

`community.sap_install` (sap-linuxlab) already provides `sap_general_preconfigure`,
`sap_hana_preconfigure`, `sap_netweaver_preconfigure`, `sap_hana_install`,
`sap_ha_install_hana_hsr`, `sap_ha_pacemaker_cluster`, `sap_swpm`,
`sap_storage_setup`, `sap_hostagent`, `sap_anydb_install_oracle`,
`sap_install_media_detect`, `sap_maintain_etc_hosts`, and states support for
RHEL for SAP 8/9/10 and SLES for SAP 15 SP5–SP7/16. Its Azure fencing support
was not confirmed from the README and must be checked in the role source.

Options:

- **A. Adopt** upstream roles as provider implementations where they match
  SDAF behaviour; SDAF keeps Azure-specific roles (BOM, Key Vault, ANF/AFS
  mounts, ACSS, AMS, fencing identity). Smallest code base; parity work is
  gap analysis + contributions upstream.
- **B. Build** SDAF-native roles as specified in the brief. Full control;
  roughly duplicates an actively maintained project.
- **C. Hybrid**: SDAF-native interface (dispatcher + argument_specs) with a
  provider registry that can point to either SDAF or upstream roles.

Recommendation: **C**, defaulting to SDAF-native providers initially for
parity, with upstream providers selectable per capability. It preserves the
interface whatever the later decision.

### 3.7 Testing reality check

- Molecule with Podman/Docker is viable for OS-level roles (sudoers, chrony,
  sysctl, hosts, users, mounts templating, MOTD, swap config, BOM parsing).
- HANA/SWPM/Pacemaker cannot be meaningfully tested in containers (no
  systemd-in-container fidelity for corosync, no media, no Azure fencing
  API). These need a Molecule `azure` driver scenario or the existing
  pipeline-based nightly (`boilerplate/WORKSPACES/*NIGHT*`), which is the de
  facto integration test. Parity claims for these roles rest on that
  pipeline.
- `ansible-lint --profile production` is the target per role; the repository
  `.ansible-lint` stays as-is for legacy paths and the new collection gets
  its own config.

---

## 4. Proposed directory tree

```
deploy/
├── terraform/
│   ├── stacks/                                  # new root modules (replace run/ + bootstrap/)
│   │   ├── control_plane_deployer/
│   │   │   ├── main.tf  variables.tf  outputs.tf  providers.tf  backend.tf  moved.tf  versions.tf
│   │   │   ├── README.md
│   │   │   └── tests/{plan_shape,validation,contract}.tftest.hcl
│   │   ├── control_plane_library/               # bootstrap behaviour via var.bootstrap_phase, not a copy
│   │   ├── workload_zone/
│   │   └── sap_system/
│   ├── addons/                                  # independent roots, own state, consume capabilities
│   │   ├── monitoring_ams/
│   │   ├── backup_vault/
│   │   ├── acss_registration/
│   │   └── private_endpoints_extra/
│   ├── modules/                                 # single-purpose child modules
│   │   ├── naming/                              # from sap_namegenerator
│   │   ├── network_vnet/  network_subnet/  network_nsg/  network_nat_gateway/  network_peering/
│   │   ├── dns_private_zones/
│   │   ├── identity_msi/  identity_rbac/
│   │   ├── key_vault/
│   │   ├── storage_account/  storage_afs_nfs/  storage_anf/  storage_managed_disks/
│   │   ├── compute_linux_vm/  compute_windows_vm/  compute_ppg_avset/
│   │   ├── load_balancer_sap/                   # HANA/SCS/ERS frontends + probes
│   │   ├── fencing_azure_identity/  fencing_sbd_iscsi/  fencing_sbd_shared_disk/
│   │   ├── app_configuration_contract/          # publishes/reads capability maps
│   │   ├── deployer_vm/  bastion/  firewall/  app_service_webapp/
│   │   └── sap_parameters_render/               # Terraform→Ansible contract output
│   ├── contracts/
│   │   ├── capabilities.workload_zone.v1.schema.json
│   │   └── sap_parameters.v1.schema.json
│   ├── run/          # LEGACY: becomes thin wrapper → stacks/* (+ moved blocks) until retired
│   ├── bootstrap/    # LEGACY: same
│   └── terraform-units/  # LEGACY: emptied capability by capability
└── ansible/
    ├── collections/ansible_collections/azure/sap_automation/
    │   ├── galaxy.yml  README.md  CHANGELOG.md  meta/runtime.yml
    │   ├── playbooks/
    │   │   ├── landscape_sap_system.yml
    │   │   ├── landscape_os_only.yml
    │   │   └── types/{hana_node,hana_scaleout_node,anydb_node,scs_node,ers_node,pas_node,app_node,web_node,observer_node,iscsi_target}.yml
    │   ├── plugins/{filter,lookup,modules}/     # custom_filters.py, azure_keyvault_secret.py, azure_app_config.py
    │   ├── roles/
    │   │   ├── run/                             # entry-point router: validates sap_parameters contract, selects Type flow
    │   │   ├── os_baseline/  os_disks/  os_network/  os_accounts/  os_repositories/  os_packages/  os_kernel/  os_time/
    │   │   ├── sap_os_prereqs/  sap_notes/  sap_users/  sap_mounts/  sap_hosts/  sap_exports/
    │   │   ├── sap_bom/                         # validator + processing + utility
    │   │   ├── sap_db/                          # dispatcher
    │   │   ├── sap_db_hana/  sap_db_hana_scaleout/  sap_db_hana_hsr/  sap_db_hana_hcmt/
    │   │   ├── sap_db_db2/  sap_db_db2_hadr/  sap_db_oracle/  sap_db_oracle_asm/  sap_db_oracle_dataguard/  sap_db_ase/  sap_db_mssql/
    │   │   ├── sap_nw/                          # dispatcher over SWPM tasks
    │   │   ├── sap_nw_scs/  sap_nw_ers/  sap_nw_dbload/  sap_nw_pas/  sap_nw_aas/  sap_nw_webdisp/  sap_nw_post/
    │   │   ├── ha_pacemaker_core/
    │   │   ├── ha_pacemaker_fence_azure_msi/  ha_pacemaker_fence_azure_spn/  ha_pacemaker_fence_sbd_iscsi/  ha_pacemaker_fence_sbd_disk/
    │   │   ├── ha_pacemaker_ra_hana_sr/  ha_pacemaker_ra_hana_sr_scaleout/  ha_pacemaker_ra_ascs_ers/  ha_pacemaker_ra_db2_hadr/  ha_pacemaker_ra_nfs_fs/
    │   │   ├── azure_keyvault_secrets/  azure_acss/  azure_ams_providers/  azure_vm_agent/  azure_quality_checks/
    │   │   └── <each role>/
    │   │       ├── defaults/main.yml  vars/main.yml  vars/<os cascade>.yml
    │   │       ├── meta/{main.yml,argument_specs.yml}
    │   │       ├── tasks/{main.yml,<component>.yml}  handlers/main.yml  templates/*.j2
    │   │       ├── molecule/default/                # where container-testable
    │   │       └── README.md
    │   └── tests/{integration,unit}/
    ├── playbook_0x_*.yaml                       # LEGACY names kept as import_playbook shims
    └── roles-*/                                 # LEGACY: removed per role after parity
tests/deploy/ansible/collections/...             # pytest for plugins (repo rule: mirrored tree)
.ansible-lint-collection                          # profile: production, scoped to the collection
.yamllint  .pre-commit-config.yaml
```

---

## 5. Migration plan (strangler fig)

| Wave | Content | Exit criterion |
|---|---|---|
| 0 | Contracts: `sap_parameters` JSON Schema, capability output types, parity harness (plan-diff of legacy vs new on boilerplate tfvars; Ansible check-mode diff) | Schema validates current output on all boilerplate workspaces |
| 1 | Ansible collection skeleton, plugins moved, `run` router, OS-level roles (Molecule-testable) | `ansible-lint --profile production` clean; Molecule idempotence green |
| 2 | Terraform `modules/naming`, `network_*`, `key_vault`, `identity_*` extracted from `sap_landscape` with `moved` blocks | `terraform plan` on migrated state shows **zero changes** |
| 3 | Pacemaker three-layer split (highest operational risk; done before DB/NW because both depend on it) | Nightly HA pipeline green for RHEL and SLES, both fencing types |
| 4 | DB providers, NW providers | Nightly install pipelines green per engine |
| 5 | `sap_system` stack decomposition (`app_tier`, `hdb_node`, `anydb_node`, `count`→`for_each`) | Zero-change plan on migrated state for every boilerplate system |
| 6 | Add-on stacks, control-plane two-pass bootstrap, SPN deprecation | Deployer bootstrap succeeds with private-only data plane on second pass |
| 7 | Remove legacy paths | All references from scripts/pipelines/Webapp point to new paths |

The parity criterion for Terraform is objective (zero-change plan on existing
state). For Ansible it is weaker (check-mode diff plus nightly pipeline);
that asymmetry should be accepted explicitly.

---

## 6. Decisions required before Phase 2

1. **Formatting rule.** `terraform fmt -check` (brief) vs "never run
   `terraform fmt`" (CLAUDE.md). Options: (a) new `stacks/`/`modules/`/`addons/`
   use canonical `fmt`, legacy paths keep alignment and are excluded from the
   check; (b) keep the repository style everywhere and drop `fmt -check`.
   Recommended: (a) — the alignment style is incompatible with any standard
   tooling, and new code has no diff-noise argument.
2. **Rewrite vs strangler.** Recommended: strangler (Section 5). A big-bang
   rewrite cannot meet the parity requirement or be reviewed.
3. **Build vs adopt** for Ansible roles overlapping `community.sap_install`.
   Recommended: hybrid (3.6, option C).
4. **Collection name and count.** `azure.sap_automation` as a single
   collection is assumed; the `azure` namespace on Galaxy belongs to
   Microsoft — confirm the namespace is appropriate for this fork.
5. **Parity scope.** Windows (`roles-*/windows`, SQL Server, Windows cluster
   witness) and Oracle multi-SID/ASM are large and lightly exercised by the
   nightly boilerplate. Confirm whether they are in the first-pass parity
   scope or follow later.
6. **Scope of the first increment.** Recommended first change set: Wave 0
   (contracts + parity harness) plus the collection skeleton. It changes no
   runtime behaviour and makes every later wave measurable.
