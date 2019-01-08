#!/bin/bash
# Evaluate on human proteome (for e.coli and salmonella)
mkdir ../data/cross_species/561_on_9606_proteome
bash ../../TriPepSVM.sh -i ../data/proteome_9606.fasta -o ../data/cross_species/561_on_9606_proteome/ -id 561 -pos 1.8 -neg 0.2 -m trainData

mkdir ../data/cross_species/590_on_9606_proteome
bash ../../TriPepSVM.sh -i ../data/proteome_9606.fasta -o ../data/cross_species/590_on_9606_proteome -id 590 -pos 1.8 -neg 0.2 -m trainData

# evaluate on salmonella proteome (for human and e.coli)
mkdir ../data/cross_species/9606_on_590_proteome
bash ../../TriPepSVM.sh -i ../data/proteome_99287.fasta -o ../data/cross_species/9606_on_590_proteome -id 9606 -pos 1.8 -neg 0.2 -m trainData

mkdir ../data/cross_species/561_on_590_proteome
bash ../../TriPepSVM.sh -i ../data/proteome_99287.fasta -o ../data/cross_species/561_on_590_proteome -id 561 -pos 1.8 -neg 0.2 -m trainData

# evaluate on e.coli proteome (for human and salmonella)
mkdir ../data/cross_species/9606_on_561_proteome
bash ../../TriPepSVM.sh -i ../data/proteome_561.fasta -o ../data/cross_species/9606_on_561_proteome -id 9606 -pos 1.8 -neg 0.2 -m trainData

mkdir ../data/cross_species/590_on_561_proteome
bash ../../TriPepSVM.sh -i ../data/proteome_561.fasta -o ../data/cross_species/590_on_561_proteome -id 590 -pos 1.8 -neg 0.2 -m trainData
