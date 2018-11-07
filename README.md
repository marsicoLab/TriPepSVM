# TriPepSVM
Predict RNA-binding proteins from amino acid sequences using string kernel SVMs.

TriPepSVM was developed by the [Marsico RNA bioinformatics group](https://www.molgen.mpg.de/2733742/RNA-Bioinformatics) at the Max-Planck-Institute for Molecular Genetics in Berlin.

## Getting Started

### Requirements

* Unix system
* R (>= 3.2.0)
* [HMMER](http://hmmer.org/) (3.1)
* [CDHIT](https://github.com/weizhongli/cdhit) (4.6.4)  

### Remarks:
* If TriPepSVM is applied to a new taxon id, you need a stable internet connection 
* Please change the PATH system variable:

  1. Edit the startup file (~/.bashrc)
  2. Modify PATH variable
  3. Save and close the file

For example (please adjust your path):
```
export PATH=$PATH:/home/Programms/cdhit-4.6.4
export PATH=$PATH:/home/Programms/hmmer-3.1b2-linux-intel-x86_64/binaries
```

### Usage
```
./TriPepSVM.sh [OPTION] ... -i INPUT.[fasta|fa]

-i,\t--input [INPUT.fasta|fa]: AA sequence in fasta format, NO DEFAULT 
-o,\t--output : path to output folder, DEFAULT: current directory 
-id,\t--taxon-id [9606|590|...] : Uniprot taxon id, DEFAULT: 9606 (human) 
-c,\t--cost : change COST parameter, DEFAULT: 1 
-k,\t--oligo-length : change k parameter, DEFAULT: 3 
-pos,\t--pos-class : change positive class weight, DEFAULT: inverse proportional to class size 
-neg,\t--neg-class : change negative class weight, DEFAULT: inverse proportional to class size 
-thr,\t--threshold : change prediction threshold, DEFAULT: 0 
-r,\t--recursive [TRUE|FALSE]: apply recursive mode, DEFAULT: FALSE 
-h,\t--help : help text
```

Example 1: Salmonella

```
./TriPepSVM.sh -i salmonellaProteom.fasta -o Results/ -id 590 -r True -posW 1.8 -negW 0.2 -thr 0.68
```

Example 2: Human

```
./TriPepSVM.sh -i humanProteom.fasta -o Results/ -id 9606 -posW 1.8 -negW 0.2 -thr 0.28
```
### Output

Result folder contains two files:

* nameInputFile.TriPepSVM.pred.txt: Main output file containing prediction for the input file
  * Identifier
  * SVM score
  * Classification
  
  ```
  sp|P0CL07|GSA_SALTY -0.664768610799015	Non RNA-binding protein
  sp|O68838|GSH1_SALTY	-0.592678648819721	Non RNA-binding protein
  sp|P43666|EPTB_SALTY	-0.443698432714576	Non RNA-binding protein
  sp|P36555|EPTA_SALTY	-0.303451909779383	Non RNA-binding protein
  ...
  ```
  
* nameInputFile.featureWeights.txt: Feature weights used by SVM classifier
  * Feature (tri-peptide sequences)
  * Feature weight
  
  ```
  AAA	0.518691300046882
  AAC	0.10328499221261
  AAD	0.0894537449099789
  AAE	-0.0464292430990747
  ...
  ```

## Authors

* **Annkatrin Bressin** - [bressin](https://github.molgen.mpg.de/bressin)
* **Roman Schulte-Sasse** - [schulte-sasse](https://github.molgen.mpg.de/sasse)

