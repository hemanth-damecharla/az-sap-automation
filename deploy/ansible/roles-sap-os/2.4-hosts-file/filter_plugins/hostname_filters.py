#!/usr/bin/python
# -*- coding: utf-8 -*-

from __future__ import absolute_import, division, print_function
__metaclass__ = type

DOCUMENTATION = r'''
    name: hostname_filters
    author: hemanth-damecharla
    version_added: "1.0"
    short_description: Filters for SAP hostname generation and IP assignment
    description:
        - Custom filters for generating SAP hostnames and handling IP assignments
        - Uses Azure IMDS-provided IP order for consistent IP assignment
'''

from ansible.errors import AnsibleFilterError
from ansible.utils.display import Display
import ipaddress

display = Display()

class FilterModule(object):
    ''' Custom filters for hostname generation and IP assignment '''

    def filters(self):
        return {
            'generate_hostname': self.generate_hostname,
            'get_tier_hostname': self.get_tier_hostname,
            'format_host_entry': self.format_host_entry,
            'get_tier_ip': self.get_tier_ip,
            'get_subnet_ip': self.get_subnet_ip,
            'is_ip_in_subnet': self.is_ip_in_subnet
        }

    def generate_hostname(self, base_name, tier_type, instance_number=None, custom_prefix=None, ha_enabled=False):
        """Generate hostname based on tier type and configuration"""
        if not base_name:
            raise AnsibleFilterError('base_name is required')
            
        if custom_prefix:
            return f"{custom_prefix}"
            
        base = base_name.lower()
        inst = str(instance_number) if instance_number else ''
        
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

    def is_ip_in_subnet(self, ip, subnet_cidr):
        """Check if an IP address belongs to a subnet"""
        try:
            if not ip or not subnet_cidr:
                return False
            network = ipaddress.ip_network(subnet_cidr, strict=False)
            address = ipaddress.ip_address(ip)
            return address in network
        except ValueError:
            return False

    def get_subnet_ip(self, ipadd, subnet_cidr):
        """Get the first IP address that belongs to the specified subnet"""
        if not ipadd or not subnet_cidr:
            return None
            
        for ip in ipadd:
            if self.is_ip_in_subnet(ip, subnet_cidr):
                return ip
        return None

    def get_tier_ip(self, ipadd, tier_index=0, subnet_cidr=None):
        """
        Get IP address for a specific tier based on IMDS-provided order
        Args:
            ipadd: List of IP addresses in IMDS order
            tier_index: Index of the IP to return if subnet_cidr is not specified
            subnet_cidr: Optional subnet to match IP against
        """
        if not ipadd:
            display.warning("No IP addresses provided")
            return None
            
        try:
            if subnet_cidr:
                # If subnet specified, find first IP in that subnet
                return self.get_subnet_ip(ipadd, subnet_cidr)
            else:
                # Otherwise return IP at specified index
                return ipadd[tier_index] if tier_index < len(ipadd) else None
                
        except Exception as e:
            display.warning(f"Error getting tier IP: {str(e)}")
            return None

    def format_host_entry(self, ip, hostname, fqdn, aliases=None):
        """Format a hosts file entry with proper spacing"""
        try:
            # Handle cases where inputs might be None or empty
            ip = str(ip).strip() if ip else ""
            hostname = str(hostname).strip() if hostname else ""
            fqdn = str(fqdn).strip() if fqdn else ""
            
            # If we don't have the minimum required components, return empty string
            if not ip or not hostname or not fqdn:
                return ""
                
            # Format the basic entry
            entry = f"{ip:<19}{hostname}.{fqdn:<80}{hostname:<21}"
            
            # Add aliases if provided
            if aliases:
                if isinstance(aliases, (list, tuple)):
                    entry += ' '.join(str(alias).strip() for alias in aliases)
                else:
                    entry += str(aliases).strip()
                    
            return entry.rstrip()
            
        except Exception as e:
            display.warning(f"Error formatting host entry: {str(e)}")
            return ""  # Return empty string on error instead of raising exception