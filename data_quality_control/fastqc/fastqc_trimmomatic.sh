#! /bin/bash

# Dossier par défaut. 
data="data/mydatalocal"
cd
cd $data

#réalisation de FASTQC sur le resultat trimmomatic paired. Donc réalisation des inputs et outputs
input="mydata/trimmomatic"
mkdir -p mydata/fastqc/trimmomatic
output="mydata/fastqc/trimmomatic"

#vrai fastqc du résultat trimmomatic "paired"
for fichier in $input/*_paired.fastq.gz
do
fastqc $fichier --outdir $output \
--format fastq \
--threads 8
done
