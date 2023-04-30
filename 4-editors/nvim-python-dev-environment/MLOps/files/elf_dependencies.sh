#!/bin/bash

# Check if the ELF file is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <path_to_elf_file>"
  exit 1
fi

ELF_FILE=$1

# Use ldd to list the dependencies
ldd $ELF_FILE | awk '{ if (match($3, "/")) { print $3 } }'
