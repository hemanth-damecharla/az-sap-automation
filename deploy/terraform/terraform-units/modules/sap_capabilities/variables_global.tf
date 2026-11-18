# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

variable "deployer_outputs"                      {
                                                   description = "Outputs of the deployer Terraform state, or an empty object when no deployer state is used"
                                                   type        = any
                                                   default     = {}
                                                 }

variable "landscape_outputs"                     {
                                                   description = "Outputs of the workload zone Terraform state, or an empty object when no workload zone state is used"
                                                   type        = any
                                                   default     = {}
                                                 }
