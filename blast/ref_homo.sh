#! /bin/bash

# Dossier par défaut. 
data="data/mydatalocal"
cd
cd $data

# création du dossier de sortie et de sa direction:
output="mydata/blast/homo"
mkdir -p $output

#téléchargement du document:
wget -O $output/Homo_sapiens.GRCh38.cds.fa.gz ftp://ftp.ensembl.org/pub/release-101/fasta/homo_sapiens/cds/Homo_sapiens.GRCh38.cds.all.fa.gz

# décompression du fichier obtenu:
gunzip mydata/blast/homo/Homo_sapiens.GRCh38.cds.fa.gz
