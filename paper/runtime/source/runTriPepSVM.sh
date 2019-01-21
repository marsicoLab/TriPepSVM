#!/usr/bin/env bash

scriptDir=$(dirname "$0")

POS=$1
NEG=$2
INPUT_FILE=$3
k=$4
cost=$5
outDir=$6
posW=$7
negW=$8
thr=$9
mode=${10}
name=${11}

base=${INPUT_FILE##*/}
filename=${base%.*}

echo $name

if [ "$mode" == "prediction" ] && [ ! -f $outDir/TriPepSVM_pretrained.rds ];then
	Rscript $scriptDir/kmerPrediction_runtime.r $POS $NEG $INPUT_FILE $k $cost $outDir ${filename}.TriPepSVM.pred.txt $posW $negW $thr training $outDir/TriPepSVM_pretrained.rds
fi


time Rscript $scriptDir/kmerPrediction_runtime.r $POS $NEG $INPUT_FILE $k $cost $outDir ${filename}.TriPepSVM.pred.txt $posW $negW $thr $mode $outDir/TriPepSVM_pretrained.rds

