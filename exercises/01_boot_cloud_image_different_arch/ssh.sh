#!/bin/bash -e
ssh -v -i ./id_vm -o StrictHostKeyChecking=no -p 2222 ubuntu@localhost
