#!/usr/bin/env bash

scriptDir=$(dirname "$0")

numProt=250
SPOT_SEQ_RESULT=$scriptDir/../data/runtime_stdout/SPOT_SEQ_RUNTIME.stdout
RBP_PRED_RESULT=$scriptDir/../data/runtime_stdout/RBP_PRED_RUNTIME.stdout
TRIPEPSVM_PLUS_RESULT=$scriptDir/../data/runtime_stdout/TriPepSVM_+_TRAINING_PRED_RUNTIME.stdout
TRIPEPSVM_MINUS_RESULT=$scriptDir/../data/runtime_stdout/TriPepSVM_-_TRAINING_PRED_RUNTIME.stdout

outDir=$scriptDir/Result
temp=$scriptDir/temp
fastaFiles=$scriptDir/fastaFiles

mkdir -p $outDir
mkdir -p $temp/TriPepSVM.+.Training
mkdir -p $temp/TriPepSVM.-.Training
mkdir -p $fastaFiles

## 1. Get Sequence Files for TriPepSVM, RBPpred predition 
## COMMENT: We cannot use all test data sets for runtime comparison as SPOT-Seq-RNA is too slow!! 
grep "^[0-9][0-9]*$" $SPOT_SEQ_RESULT -A 1 | grep -v "^[0-9][0-9]*$" | sed "/^--$/d" > $temp/predictedProteins.txt

cat $scriptDir/../data/test/RBP_9606.fasta $scriptDir/../data/test/NRBP_9606.fasta > $temp/test_data.fasta
samtools faidx $temp/test_data.fasta

for i in `cat <(echo "1") <(seq 50 50 $numProt)`;do
	outFile=$fastaFiles/runtime_${i}.fasta	
	if [ ! -f $outFile ];then
		for id in `cut -f1 $temp/predictedProteins.txt | head -n $i`;do
			fasta_id=`grep "$id" $temp/test_data.fasta | cut -f2 -d'>'| cut -f1 -d' '`	
			samtools faidx $temp/test_data.fasta $fasta_id >> $outFile
		done
	fi

done


## 2. Track runtime for TriPepSVM with and without training
## COMMENT: runtime tracked on holidayincambodia
for i in `cat <(echo "1") <(seq 50 50 $numProt)`;do
	inFile=$fastaFiles/runtime_${i}.fasta
	echo $inFile
	if [ ! -f $temp/TriPepSVM.+.Training/runtime_${i}.TriPepSVM.pred.txt ];then
		echo "TriPepSVM + training"
		bash $scriptDir/source/runTriPepSVM.sh $scriptDir/../../trainData/RBP_9606.fasta $scriptDir/../../trainData/NRBP_9606.fasta $inFile 3 1 $temp/TriPepSVM.+.Training 1.8 0.2 0.68 training $i \
		>> $TRIPEPSVM_PLUS_RESULT 2>&1 
	fi
	if [ ! -f $temp/TriPepSVM.-.Training/runtime_${i}.TriPepSVM.pred.txt ];then
		echo "TriPepSVM - training"
		bash $scriptDir/source/runTriPepSVM.sh $scriptDir/../../trainData/RBP_9606.fasta $scriptDir/../../trainData/NRBP_9606.fasta $inFile 3 1 $temp/TriPepSVM.-.Training 1.8 0.2 0.68 prediction $i \
		>> $TRIPEPSVM_MINUS_RESULT 2>&1 
	fi

done

## 3. Extract runtime table
paste <(seq 1 1 $numProt) <(grep "real" $SPOT_SEQ_RESULT | cut -f2 | sed "s/m/\t/g" | sed "s/s//g" | sed "s/\.*$//g" | head -n $numProt ) > $temp/SPOT_SEQ_RUNTIME.txt
paste <(grep "^[0-9][0-9]*$" $TRIPEPSVM_MINUS_RESULT ) <(grep "real" $TRIPEPSVM_MINUS_RESULT | cut -f2 | sed "s/m/\t/g" | sed "s/s//g" | sed "s/\.*$//g") > $temp/TriPepSVM_-_TRAINING_PRED_RUNTIME.txt
paste <(grep "^[0-9][0-9]*$" $TRIPEPSVM_PLUS_RESULT ) <(grep "real" $TRIPEPSVM_PLUS_RESULT | cut -f2 | sed "s/m/\t/g" | sed "s/s//g" | sed "s/\.*$//g") > $temp/TriPepSVM_+_TRAINING_PRED_RUNTIME.txt

## 4. Plot runtimes

Rscript $scriptDir/source/plotRuntime.r $scriptDir/runtime_1.pdf $temp/SPOT_SEQ_RUNTIME.txt $temp/TriPepSVM_-_TRAINING_PRED_RUNTIME.txt $temp/TriPepSVM_+_TRAINING_PRED_RUNTIME.txt

