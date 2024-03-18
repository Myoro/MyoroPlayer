#!/bin/bash

echo "Running 'dart fix'..."
{
  dart fix --apply .
  echo "Files fixed successfully"
} || {
  echo "Error fixing files"
  exit 1
}

echo -e "Running 'dart format'..." 
{
  dart format --line-length 160 . 
  echo "Files formatted successfully"
} || {
  echo "Error formatting files"
  exit 1
}