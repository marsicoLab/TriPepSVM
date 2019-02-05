#!/usr/bin/env bash

scriptDir=$(dirname "$0")


#####  get proteome-wide prediction: salmonella
if [ ! -f $scriptDir/../data/proteome_prediction_salmonella/proteome_99287.TriPepSVM.pred.txt ];then
	TriPepSVM.sh -i $scriptDir/../data/proteome_99287.fasta -o $scriptDir/../data/proteome_prediction_salmonella -id 590 -pos 1.8 -neg 0.2 -thr 0.28 -r TRUE
fi

#####  get proteome-wide prediction: human
if [ ! -f $scriptDir/../data/proteome_prediction_human/proteome_9606.TriPepSVM.pred.txt ];then
	TriPepSVM.sh -i $scriptDir/../data/proteome_9606.fasta -o $scriptDir/../data/proteome_prediction_human -id 9606 -pos 1.8 -neg 0.2 -thr 0.68
fi 

#####  get proteome-wide prediction: ecoli
if [ ! -f $scriptDir/../data/proteome_prediction_ecoli/proteome_83333.TriPepSVM.pred.txt ];then
	TriPepSVM.sh -i $scriptDir/../data/proteome_83333.fasta -o $scriptDir/../data/proteome_prediction_ecoli -id 561 -pos 1 -neg 0.1 -thr 0.3 -r TRUE
fi 

temp=$scriptDir/TEMP

mkdir -p $temp

##### get structural folded fraction: salmonella
if [ ! -f $scriptDir/../data/proteome_prediction_salmonella/proteome_99287.fractionPredictedDomain.txt ];then
	awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < $scriptDir/../data/proteome_99287.fasta \
	> $temp/proteome_99287.oneLine.fasta

	bash $scriptDir/source/getIUPred.sh $temp/proteome_99287.oneLine.fasta \
	$scriptDir/../data/proteome_prediction_salmonella/proteome_99287.fractionPredictedDomain.txt $temp
fi

##### get structural folded fraction: human
if [ ! -f $scriptDir/../data/proteome_prediction_human/proteome_9606.fractionPredictedDomain.txt ];then
	awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < $scriptDir/../data/proteome_9606.fasta \
	> $temp/proteome_9606.oneLine.fasta

	bash $scriptDir/source/getIUPred.sh $temp/proteome_9606.oneLine.fasta \
	$scriptDir/../data/proteome_prediction_human/proteome_9606.fractionPredictedDomain.txt $temp
fi

##### get structural folded fraction: e-coli
if [ ! -f $scriptDir/../data/proteome_prediction_ecoli/proteome_83333.fractionPredictedDomain.txt ];then
	awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < $scriptDir/../data/proteome_83333.fasta \
	> $temp/proteome_83333.oneLine.fasta

	bash $scriptDir/source/getIUPred.sh $temp/proteome_83333.oneLine.fasta \
	$scriptDir/../data/proteome_prediction_ecoli/proteome_83333.fractionPredictedDomain.txt $temp
fi


#### get final table salmonella

cat <(echo "UniprotKB_ID	Name	TriPepSVM_Score	TriPepSVM_class	RNA-binding_annotation(21.10.2018)	Fraction_predicted_tertiary_structure") \
<(join -t $'\t' -1 1 -2 1 \
<(join -t $'\t' -1 1 -2 1 -a 1 -e "no" -o "1.1,1.2,1.3,1.4,2.2" \
<(join -t $'\t' -1 1 -2 1 <(cut -f 1,5 $scriptDir/../data/proteome_99287.tab | cut -f1 -d' ' | tail -n +1 | sort -k1,1 ) \
<(paste <(cut -f1 $scriptDir/../data/proteome_prediction_salmonella/proteome_99287.TriPepSVM.pred.txt | cut -f2 -d'|') <(cut -f2,3 $scriptDir/../data/proteome_prediction_salmonella/proteome_99287.TriPepSVM.pred.txt) | sort -k1,1) | sort -k1,1 ) \
<(tail -n +2 $scriptDir/../data/proteome_90371.QuickGO.tsv | cut -f2 | sort| uniq | awk -v OFS="\t" -F"\t" '{ print $1,"yes"}') | sort -k1,1 ) \
<( paste <(cut -f2 -d'|' $scriptDir/../data/proteome_prediction_salmonella/proteome_99287.fractionPredictedDomain.txt ) \
<(cut -f2 $scriptDir/../data/proteome_prediction_salmonella/proteome_99287.fractionPredictedDomain.txt) | sort -k1,1 ) | sort -k3,3 -rn ) \
> $scriptDir/proteome_99287_summary.txt

cat <(echo "UniprotKB_ID	Name	TriPepSVM_Score	TriPepSVM_class	RNA-binding_annotation(21.10.2018)	Fraction_predicted_tertiary_structure") \
<(grep -P "\tRNA-binding protein\tno" $scriptDir/proteome_99287_summary.txt) \
> $scriptDir/proteome_99287.newIdentified.txt

#### get final table human

cat <(echo "UniprotKB_ID	Name	TriPepSVM_Score	TriPepSVM_class	RNA-binding_annotation(21.10.2018)	Fraction_predicted_tertiary_structure") \
<(join -t $'\t' -1 1 -2 1 \
<(join -t $'\t' -1 1 -2 1 -a 1 -e "no" -o "1.1,1.2,1.3,1.4,2.2" \
<(join -t $'\t' -1 1 -2 1 <(cut -f 1,5 $scriptDir/../data/proteome_9606.tab | cut -f1 -d' ' | tail -n +1 | sort -k1,1 ) \
<(paste <(cut -f1 $scriptDir/../data/proteome_prediction_human/proteome_9606.TriPepSVM.pred.txt | cut -f2 -d'|') <(cut -f2,3 $scriptDir/../data/proteome_prediction_human/proteome_9606.TriPepSVM.pred.txt) | sort -k1,1) | sort -k1,1 ) \
<(tail -n +2 $scriptDir/../data/proteome_9606.QuickGO.tsv | cut -f2 | sort| uniq | awk -v OFS="\t" -F"\t" '{ print $1,"yes"}') | sort -k1,1 ) \
<( paste <(cut -f2 -d'|' $scriptDir/../data/proteome_prediction_human/proteome_9606.fractionPredictedDomain.txt ) \
<(cut -f2 $scriptDir/../data/proteome_prediction_human/proteome_9606.fractionPredictedDomain.txt) | sort -k1,1 ) | sort -k3,3 -rn ) \
> $scriptDir/proteome_9606_summary.txt

cat <(echo "UniprotKB_ID	Name	TriPepSVM_Score	TriPepSVM_class	RNA-binding_annotation(21.10.2018)	Fraction_predicted_tertiary_structure") \
<(grep -P "\tRNA-binding protein\tno" $scriptDir/proteome_9606_summary.txt) \
> $scriptDir/proteome_9606.newIdentified.txt

#### get final table ecoli

cat <(echo "UniprotKB_ID	Name	TriPepSVM_Score	TriPepSVM_class	RNA-binding_annotation(27.01.2019)	Fraction_predicted_tertiary_structure") \
<(join -t $'\t' -1 1 -2 1 \
<(join -t $'\t' -1 1 -2 1 -a 1 -e "no" -o "1.1,1.2,1.3,1.4,2.2" \
<(join -t $'\t' -1 1 -2 1 <(cut -f 1,5 $scriptDir/../data/proteome_83333.tab | cut -f1 -d' ' | tail -n +1 | sort -k1,1 ) \
<(paste <(cut -f1 $scriptDir/../data/proteome_prediction_ecoli/proteome_83333.TriPepSVM.pred.txt | cut -f2 -d'|') <(cut -f2,3 $scriptDir/../data/proteome_prediction_ecoli/proteome_83333.TriPepSVM.pred.txt) | sort -k1,1) | sort -k1,1 ) \
<(tail -n +2 $scriptDir/../data/proteome_561.QuickGO.tsv | cut -f2 | sort| uniq | awk -v OFS="\t" -F"\t" '{ print $1,"yes"}') | sort -k1,1 ) \
<( paste <(cut -f2 -d'|' $scriptDir/../data/proteome_prediction_ecoli/proteome_83333.fractionPredictedDomain.txt ) \
<(cut -f2 $scriptDir/../data/proteome_prediction_ecoli/proteome_83333.fractionPredictedDomain.txt) | sort -k1,1 ) | sort -k3,3 -rn ) \
> $scriptDir/proteome_83333_summary.txt

cat <(echo "UniprotKB_ID	Name	TriPepSVM_Score	TriPepSVM_class	RNA-binding_annotation(27.01.2019)	Fraction_predicted_tertiary_structure") \
<(grep -P "\tRNA-binding protein\tno" $scriptDir/proteome_83333_summary.txt) \
> $scriptDir/proteome_83333.newIdentified.txt






