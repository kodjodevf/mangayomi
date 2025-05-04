#!/bin/bash

# Fast fail the script on failures.
set -e

# Analyze the code.
dartanalyzer --strong --fatal-warnings .

# Test the entire test directory
pub run test test/