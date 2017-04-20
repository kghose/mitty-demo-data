Demo scripts and data for the Mitty program
===========================================

[Mitty](https://github.com/sbg/Mitty) is a data simulator meant to help debug aligners and variant callers. 
This repository contains scripts and data files that demonstrate Mitty's features and accompanies the full
[Mitty tutorial](https://github.com/sbg/Mitty#detailed-tutorial-with-commentary).

The data are released under the [Apache](LICENSE.txt) license except for when they are copies of publicly 
available data, in which case the original license applies to them.

Getting started
---------------
After cloning the project run the `get-data.sh` script in under the `data` directory to download a reference
FASTA and a 1000G VCF section. **The reference download and index generation are time consuming. It is possible you have suitable FASTA and VCF files on your hard-drive already which you can copy or link into
the data directory. You just have to ensure the names in the script match those on disk**

_(As a reference, on my laptop the process of indexing hg19 takes 4889.075 sec)_

You can then run the scripts under each example directory. Note that some scripts rely on the outputs of 
other scripts to work. Following the order in the tutorial will be best.