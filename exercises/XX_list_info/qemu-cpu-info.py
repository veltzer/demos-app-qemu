#!/usr/bin/env python
import subprocess
import json
import sys
from collections import defaultdict
import textwrap

def run_qemu_command(arch, machine=None):
    """Run QEMU command to get CPU information for a specific architecture."""
    base_cmd = ['qemu-system-' + arch, '-cpu', '?']
    if machine:
        base_cmd.extend(['-M', machine])
    
    try:
        # Redirect stderr to stdout as QEMU prints CPU info to stderr
        result = subprocess.run(base_cmd, capture_output=True, text=True)
        # Combine stdout and stderr as some QEMU versions use different outputs
        return result.stdout + result.stderr
    except FileNotFoundError:
        return None

def get_cpu_features(arch, cpu_type):
    """Get detailed CPU features for a specific CPU type."""
    cmd = ['qemu-system-' + arch, '-cpu', cpu_type + ',?']
    try:
        result = subprocess.run(cmd, capture_output=True, text=True)
        return result.stdout + result.stderr
    except FileNotFoundError:
        return None

def get_machines(arch):
    """Get list of supported machines for an architecture."""
    try:
        result = subprocess.run(['qemu-system-' + arch, '-machine', '?'],
                              capture_output=True, text=True)
        return result.stdout + result.stderr
    except FileNotFoundError:
        return None

def parse_cpu_list(output):
    """Parse QEMU CPU list output into structured data."""
    cpus = []
    if not output:
        return cpus
    
    lines = output.split('\n')
    for line in lines:
        if line.startswith('x86'):  # x86 CPUs
            parts = line.split()
            if len(parts) >= 2:
                name = parts[1].rstrip(',')
                cpus.append({
                    'name': name,
                    'flags': parts[2:] if len(parts) > 2 else []
                })
        elif line.strip().startswith('arm'):  # ARM CPUs
            parts = line.split()
            if parts:
                name = parts[0]
                cpus.append({
                    'name': name,
                    'description': ' '.join(parts[1:]) if len(parts) > 1 else ''
                })
    return cpus

def analyze_architecture(arch):
    """Analyze and collect information about a specific architecture."""
    print(f"\n{'='*80}")
    print(f"Architecture: {arch}")
    print(f"{'='*80}")
    
    # Get CPU information
    cpu_output = run_qemu_command(arch)
    if not cpu_output:
        print(f"QEMU system emulator for {arch} not found!")
        return
    
    cpus = parse_cpu_list(cpu_output)
    print(f"\nSupported CPU types ({len(cpus)}):")
    print("-" * 40)
    
    # Print CPU information with features for selected CPUs
    for cpu in cpus:
        print(f"\nCPU: {cpu['name']}")
        if 'flags' in cpu and cpu['flags']:
            print(f"Flags: {' '.join(cpu['flags'])}")
        if 'description' in cpu and cpu['description']:
            print(f"Description: {cpu['description']}")
            
        # Get detailed features for some interesting CPUs
        interesting_cpus = ['max', 'host', 'base']
        if cpu['name'] in interesting_cpus:
            features = get_cpu_features(arch, cpu['name'])
            if features:
                print("\nDetailed features:")
                # Wrap and indent the features text for better readability
                wrapped_features = textwrap.fill(features, 
                                               width=76, 
                                               initial_indent='  ',
                                               subsequent_indent='  ')
                print(wrapped_features)
    
    # Get machine types
    print(f"\nSupported machine types:")
    print("-" * 40)
    machines_output = get_machines(arch)
    if machines_output:
        # Process and print machine types
        for line in machines_output.split('\n'):
            if line.strip() and not line.startswith('Supported machines'):
                print(line)

def main():
    """Main function to analyze multiple architectures."""
    architectures = ['x86_64', 'aarch64']
    
    print("QEMU CPU Capabilities Analysis")
    print("=============================")
    
    for arch in architectures:
        analyze_architecture(arch)
    
    print("\nNote: Some features might require additional QEMU packages or system support.")
    print("For more detailed information, consult the QEMU documentation.")

if __name__ == '__main__':
    main()
