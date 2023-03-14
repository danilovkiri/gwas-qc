#!/bin/bash

# Script for converting tables (with space-aligned columns) into TSV format.

INFILE=$1
NCOL=$(head -1 $INFILE | wc -w) # 5
COLS=$(echo '$'$(seq 1 $NCOL) | sed 's/ /,$/g') # $1,$2,$3,$4,$5

awk 'BEGIN {OFS="\t"} {print '"$COLS"'}' $INFILE
