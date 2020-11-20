#! /bin/bash

# Dossier par défaut. 
data="data/mydatalocal"
cd
cd $data

#j'utilise Trimmomatic pour retirer les mauvais rides des fichier
#création des fichier pour les output Trimmomatic
mkdir -p mydata/trimmomatic

#variavle pour input et output 
input="download/Projet_31_20_UE_NGS_2020/FASTQ"
output="mydata/trimmomatic"

#variable fasta et nombre pour la boucle ainsi le nom des fichiers 
fasta="download/adapt.fasta"
boucle="1
2
3
4
5
6"

# Utilisation de Trimmomatic:
#vrai essay: ça télécharge bien sur mydata/trimmomatic
for n in $boucle
do
java -jar /softwares/Trimmomatic-0.39/trimmomatic-0.39.jar PE -threads 4 -phred33 $input/Lib${n}_31_20_S${n}_R1_001.fastq.gz $input/Lib${n}_31_20_S${n}_R2_001.fastq.gz $output/Lib${n}_31_20_S${n}_R1_paired.fastq.gz $output/Lib${n}_31_20_S${n}_R1_unpaired.fastq.gz $output/Lib${n}_31_20_S${n}_R2_paired.fastq.gz $output/Lib${n}_31_20_S${n}_R2_unpaired.fastq.gz ILLUMINACLIP:${fasta}:2:30:10 HEADCROP:9 MINLEN:100
done
