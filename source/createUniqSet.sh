#!/bin/bash

RESULT=$1
INPUT=$2
OUTPUT=$3

cd-hit -i $INPUT -o $OUTPUT -c 0.9 -n 5 -g 1 -G 0 -aS 0.8  -d 0 -p 1 -T 0 -M 0 > $RESULT/log.temp

rm $RESULT/log.temp
rm $OUTPUT.clstr

