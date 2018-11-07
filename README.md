# TriPepSVM
Predict RNA-binding proteins from amino acid sequences using string kernel SVMs.

## Getting Started

### Requirements

* Unix system
* R (>= 3.2.0)
* [HMMER] (http://hmmer.org/)
* [CDHIT] (https://github.com/weizhongli/cdhit) 
* Internet connection (if tool is applied to new taxon id) 

* Please change the PATH system variable:

1. Edit the startup file (~/.bashrc)
2. Modify PATH variable

For example:
```
export PATH=$PATH:/home/Programms/cdhit-4.6.4
export PATH=$PATH:/home/Programms/hmmer-3.1b2-linux-intel-x86_64/binaries
```
3. Save and close the file

### Usage

./TriPepSVM.sh [OPTION] ... -i INPUT.[fasta|fa] 
-i,\t--input [INPUT.fasta|fa] : AA sequence in fasta format, NO DEFAULT 
-o,\t--output : path to output folder, DEFAULT: current directory 
-id,\t--taxon-id [9606|590|...] : Uniprot taxon id, DEFAULT: 9606 (human) 
-c,\t--cost : change COST parameter, DEFAULT: 1 
-k,\t--oligo-length : change k parameter, DEFAULT: 3 
-pos,\t--pos-class : change positive class weight, DEFAULT: inverse proportional to class size 
-neg,\t--neg-class : change negative class weight, DEFAULT: inverse proportional to class size 
-thr,\t--threshold : change prediction threshold, DEFAULT: 0 
-r,\t--recursive [TRUE|FALSE]: apply recursive mode, DEFAULT: FALSE 
-h,\t--help : help text

Example 1: prediction Salmonella proteome
```
./TriPepSVM.sh -i salmonellaProteom.fasta -o Results/ -id 590 -r True -posW 1.8 -negW 0.2 -thr 0.68 \n
```

Example 2: prediction human proteome
```
# ./TriPepSVM.sh -i humanProteom.fasta -o Results/ -id 9606 -posW 1.8 -negW 0.2 -thr 0.28 \n
```

## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags). 

## Authors

* **Annkatrin Bressin** - *Initial work* - [bressin](https://github.molgen.mpg.de/bressin)
* **Roman Schulte-Sasse** - [schulte-sasse](https://github.molgen.mpg.de/sasse)

## Acknowledgments

* Hat tip to anyone whose code was used
* Inspiration
* etc

