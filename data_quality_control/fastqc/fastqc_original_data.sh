#! /bin/bash

# Dossier par défaut. 
data="data/mydatalocal"
cd
cd $data

# réalisation de FASTQC afin de vérifier si les données sont correctes.

#création du dossier pour FASTQC. 
mkdir -p mydata/fastqc

#Récupérer mes données fastq:
fasta="download/Projet_31_20_UE_NGS_2020/FASTQ/*.gz"


# realisation et collecter des données en local. 
for fichier in $fasta
do
fastqc $fichier --outdir mydata/fastqc/original_data \
--format fastq \
--threads 4
done
