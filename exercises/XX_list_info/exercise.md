# QEMU CPU Capabilities Analysis Exercise

## Overview
Create a tool to analyze and display QEMU's CPU emulation capabilities across different architectures. This exercise will help you understand QEMU's CPU models and machine types while practicing system command execution and output parsing in Python.

## Requirements

### Core Requirements
1. Create a Python script that:
   - Analyzes CPU capabilities for both x86_64 and aarch64 architectures
   - Lists all available CPU types for each architecture
   - Shows detailed features for special CPU types (max, host, base)
   - Displays supported machine types
   - Handles cases where QEMU packages aren't installed

### Technical Specifications
1. CPU Information Collection:
   - Use `qemu-system-[arch] -cpu ?` to get CPU types
   - Use `qemu-system-[arch] -cpu [type],?` to get detailed features
   - Use `qemu-system-[arch] -machine ?` to get machine types

1. Output Requirements:
   - Display results in a clear, hierarchical format
   - Group information by architecture
   - Include proper error handling and user feedback
   - Format long output for readability

### Implementation Details
1. Create functions to:
   - Execute QEMU commands safely
   - Parse command output into structured data
   - Display information in a readable format
   - Handle different output formats for different architectures

1. The program should:
   - Be executable from command line
   - Provide clear section separators
   - Include helpful notes about system requirements
   - Handle stderr/stdout appropriately (QEMU uses both)

## Bonus Challenges
1. Add support for additional architectures
1. Implement JSON export functionality
1. Add capability to compare CPU features between different types
1. Create visual representation of CPU feature relationships

## Evaluation Criteria
- Code organization and modularity
- Error handling completeness
- Output clarity and usefulness
- Documentation quality
- Performance with large output

## Learning Objectives
After completing this exercise, you should understand:
- How to interact with system commands from Python
- QEMU's CPU emulation capabilities
- Text parsing and formatting techniques
- Error handling best practices
- Command-line tool development

## Prerequisites
- Python 3.x
- QEMU installation
- Basic understanding of CPU architectures
- Familiarity with subprocess management in Python

## Example Usage
The completed script should be usable as follows:

```bash
./qemu_cpu_info.py
```

And should produce clear, organized output showing CPU capabilities and machine types for each architecture.

## Additional Notes
- Consider the readability of the output for both technical and non-technical users
- Remember that QEMU commands might output to either stdout or stderr
- Different QEMU versions might have slightly different output formats
- Some CPU types might have extensive feature lists that need careful formatting
