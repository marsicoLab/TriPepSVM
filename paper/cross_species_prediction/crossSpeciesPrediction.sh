#!/usr/bin/env bash

scriptDir=$(dirname "$0")

testData=$scriptDir/test
mkdir -p $testData


# 1. get test data sets
#590
bash $scriptDir/source/removeSequenceSimilarities.sh $scriptDir/../data/test/RBP_590.fasta 590 0.9 $testData/RBP_590.fasta
bash $scriptDir/source/removeSequenceSimilarities.sh $scriptDir/../data/test/NRBP_590.fasta 590 0.9 $testData/NRBP_590.fasta

#561
bash $scriptDir/source/removeSequenceSimilarities.sh $scriptDir/../data/test/RBP_561.fasta 561 0.9 $testData/RBP_561.fasta
bash $scriptDir/source/removeSequenceSimilarities.sh $scriptDir/../data/test/NRBP_561.fasta 561 0.9 $testData/NRBP_561.fasta

#9606
bash $scriptDir/source/removeSequenceSimilarities.sh $scriptDir/../data/test/RBP_9606.fasta 9606 0.9 $testData/RBP_9606.fasta
bash $scriptDir/source/removeSequenceSimilarities.sh $scriptDir/../data/test/NRBP_9606.fasta 9606 0.9 $testData/NRBP_9606.fasta


# 2. do predictions

prediction=$scriptDir/prediction
mkdir -p $prediction

#####  get performance: salmonella trained
if [ ! -f $prediction/590/RBP_590.TriPepSVM.pred.txt ];then
	mxqsub -t 2h -m 10G \
	bash $scriptDir/../../TriPepSVM.sh -i $testData/RBP_590.fasta -o $prediction/590 -id 590 -pos 1.8 -neg 0.2 -thr 0.28 -r TRUE -m trainData
fi

if [ ! -f $prediction/590/NRBP_590.TriPepSVM.pred.txt ];then
	mxqsub -t 2h -m 10G \
	bash $scriptDir/../../TriPepSVM.sh -i $testData/NRBP_590.fasta -o $prediction/590 -id 590 -pos 1.8 -neg 0.2 -thr 0.28 -r TRUE -m trainData
fi

if [ ! -f $prediction/590/RBP_561.TriPepSVM.pred.txt ];then
	mxqsub -t 2h -m 10G \
	bash $scriptDir/../../TriPepSVM.sh -i $testData/RBP_561.fasta -o $prediction/590 -id 590 -pos 1.8 -neg 0.2 -thr 0.28 -r TRUE -m trainData
fi

if [ ! -f $prediction/590/NRBP_561.TriPepSVM.pred.txt ];then
	mxqsub -t 2h -m 10G \
	bash $scriptDir/../../TriPepSVM.sh -i $testData/NRBP_561.fasta -o $prediction/590 -id 590 -pos 1.8 -neg 0.2 -thr 0.28 -r TRUE -m trainData
fi

if [ ! -f $prediction/590/RBP_9606.TriPepSVM.pred.txt ];then
	mxqsub -t 2h -m 10G \
	bash $scriptDir/../../TriPepSVM.sh -i $testData/RBP_9606.fasta -o $prediction/590 -id 590 -pos 1.8 -neg 0.2 -thr 0.28 -r TRUE -m trainData
fi

if [ ! -f $prediction/590/NRBP_9606.TriPepSVM.pred.txt ];then
	mxqsub -t 2h -m 10G \
	bash $scriptDir/../../TriPepSVM.sh -i $testData/NRBP_9606.fasta -o $prediction/590 -id 590 -pos 1.8 -neg 0.2 -thr 0.28 -r TRUE -m trainData
fi


#####  get performance: human
if [ ! -f $prediction/9606/RBP_590.TriPepSVM.pred.txt ];then
	mxqsub -t 2h -m 10G \
	bash $scriptDir/../../TriPepSVM.sh -i $testData/RBP_590.fasta -o $prediction/9606 -id 9606 -pos 1.8 -neg 0.2 -thr 0.68 -r TRUE -m trainData
fi

if [ ! -f $prediction/9606/NRBP_590.TriPepSVM.pred.txt ];then
	mxqsub -t 2h -m 10G \
	bash $scriptDir/../../TriPepSVM.sh -i $testData/NRBP_590.fasta -o $prediction/9606 -id 9606 -pos 1.8 -neg 0.2 -thr 0.68 -r TRUE -m trainData
fi

if [ ! -f $prediction/9606/RBP_561.TriPepSVM.pred.txt ];then
	mxqsub -t 2h -m 10G \
	bash $scriptDir/../../TriPepSVM.sh -i $testData/RBP_561.fasta -o $prediction/9606 -id 9606 -pos 1.8 -neg 0.2 -thr 0.68 -r TRUE -m trainData
fi

if [ ! -f $prediction/9606/NRBP_561.TriPepSVM.pred.txt ];then
	mxqsub -t 2h -m 10G \
	bash $scriptDir/../../TriPepSVM.sh -i $testData/NRBP_561.fasta -o $prediction/9606 -id 9606 -pos 1.8 -neg 0.2 -thr 0.68 -r TRUE -m trainData
fi

if [ ! -f $prediction/9606/RBP_9606.TriPepSVM.pred.txt ];then
	mxqsub -t 2h -m 10G \
	bash $scriptDir/../../TriPepSVM.sh -i $testData/RBP_9606.fasta -o $prediction/9606 -id 9606 -pos 1.8 -neg 0.2 -thr 0.68 -r TRUE -m trainData
fi

if [ ! -f $prediction/9606/NRBP_9606.TriPepSVM.pred.txt ];then
	mxqsub -t 2h -m 10G \
	bash $scriptDir/../../TriPepSVM.sh -i $testData/NRBP_9606.fasta -o $prediction/9606 -id 9606 -pos 1.8 -neg 0.2 -thr 0.68 -r TRUE -m trainData
fi


#####  get performance: e.coli
if [ ! -f $prediction/561/RBP_590.TriPepSVM.pred.txt ];then
	mxqsub -t 2h -m 10G \
	bash $scriptDir/../../TriPepSVM.sh -i $testData/RBP_590.fasta -o $prediction/561 -id 561 -pos 1 -neg 0.1 -thr 0.3 -r TRUE -m trainData
fi

if [ ! -f $prediction/561/NRBP_590.TriPepSVM.pred.txt ];then
	mxqsub -t 2h -m 10G \
	bash $scriptDir/../../TriPepSVM.sh -i $testData/NRBP_590.fasta -o $prediction/561 -id 561 -pos 1 -neg 0.1 -thr 0.3 -r TRUE -m trainData
fi

if [ ! -f $prediction/561/RBP_561.TriPepSVM.pred.txt ];then
	mxqsub -t 2h -m 10G \
	bash $scriptDir/../../TriPepSVM.sh -i $testData/RBP_561.fasta -o $prediction/561 -id 561 -pos 1 -neg 0.1 -thr 0.3 -r TRUE -m trainData
fi

if [ ! -f $prediction/561/NRBP_561.TriPepSVM.pred.txt ];then
	mxqsub -t 2h -m 10G \
	bash $scriptDir/../../TriPepSVM.sh -i $testData/NRBP_561.fasta -o $prediction/561 -id 561 -pos 1 -neg 0.1 -thr 0.3 -r TRUE -m trainData
fi

if [ ! -f $prediction/561/RBP_9606.TriPepSVM.pred.txt ];then
	mxqsub -t 2h -m 10G \
	bash $scriptDir/../../TriPepSVM.sh -i $testData/RBP_9606.fasta -o $prediction/561 -id 561 -pos 1 -neg 0.1 -thr 0.3 -r TRUE -m trainData
fi

if [ ! -f $prediction/561/NRBP_9606.TriPepSVM.pred.txt ];then
	mxqsub -t 2h -m 10G \
	bash $scriptDir/../../TriPepSVM.sh -i $testData/NRBP_9606.fasta -o $prediction/561 -id 561 -pos 1 -neg 0.1 -thr 0.3 -r TRUE -m trainData
fi

Rscript $scriptDir/source/plotCrossSpecies.r $prediction $scriptDir/crossSpeciesPrediction.pdf $scriptDir/colorScale.png
