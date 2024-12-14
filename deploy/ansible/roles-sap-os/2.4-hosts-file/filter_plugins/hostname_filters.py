#!/usr/bin/python
# -*- coding: utf-8 -*-

from __future__ import absolute_import, division, print_function
__metaclass__ = type

DOCUMENTATION = r'''
    name: hostname_filters
    author: hemanth-damecharla
    version_added: "1.0"
    short_description: Filters for SAP hostname generation
    description:
        - Custom filters for generating SAP hostnames based on different tiers and configurations
        - Handles IP address assignment based on Azure IMDS-provided order
'''

from ansible.errors import AnsibleFilterError
from ansible.utils.display import Display

display = Display()

class FilterModule(object):
    ''' Custom filters for hostname generation '''

    def filters(self):
        return {
            'generate_hostname': self.generate_hostname,
            'get_tier_hostname': self.get_tier_hostname,
            'format_host_entry': self.format_host_entry,
            'get_tier_ip': self.get_tier_ip
        }

    def generate_hostname(self, base_name, tier_type, instance_number=None, custom_prefix=None, ha_enabled=False):
        """Generate hostname based on tier type and configuration"""
        if not base_name:
            raise AnsibleFilterError('base_name is required')
            
        if custom_prefix:
            return f"{custom_prefix}"
            
        base = base_name.lower()
        inst = str(instance_number) if instance_number else ''
        
        # Standard hostname patterns
        patterns = {
            'scs': f"{base}scs{inst}{'cl1' if ha_enabled else ''}",
            'ers': f"{base}ers{inst}{'cl2' if ha_enabled else ''}",
            'db': f"{base}db{inst}{'cl' if ha_enabled else ''}",
            'db_so': f"{base}db{inst}so",  # Scale-out specific
            'pas': f"{base}pas{inst}",
            'app': f"{base}app{inst}",
            'web': f"{base}web{inst}"
        }
        
        if tier_type not in patterns:
            raise AnsibleFilterError(f'Unknown tier type: {tier_type}')
            
        return patterns[tier_type]

    def get_tier_hostname(self, hostvars, host, tier):
        """Extract hostname for a specific tier from hostvars"""
        if not hostvars or not host:
            raise AnsibleFilterError('hostvars and host are required')
            
        custom_hostname = hostvars.get(host, {}).get(f'custom_{tier}_virtual_hostname')
        if custom_hostname:
            return custom_hostname
            
        virtual_host = hostvars.get(host, {}).get('virtual_host')
        if virtual_host:
            return virtual_host
            
        return None

    def get_tier_ip(self, ipadd, tier_index, subnet_cidr=None):
        """Get IP address for a specific tier based on IMDS-provided order"""
        if not ipadd:
            raise AnsibleFilterError('ipadd list is required')
            
        if tier_index >= len(ipadd):
            raise AnsibleFilterError(f'Requested IP index {tier_index} exceeds available IPs')
            
        # If subnet_cidr is provided, validate IP belongs to subnet
        if subnet_cidr:
            # Note: Actual subnet validation would need to be implemented
            # or use ansible.utils.ipaddr filter
            return ipadd[tier_index]
            
        return ipadd[tier_index]

    def format_host_entry(self, ip, hostname, fqdn, aliases=None):
        """Format a hosts file entry with proper spacing"""
        if not ip or not hostname or not fqdn:
            raise AnsibleFilterError('IP, hostname, and FQDN are required')
            
        entry = f"{ip:<19}{hostname}.{fqdn:<80}{hostname:<21}"
        if aliases:
            entry += ' '.join(aliases)
        return entry