#! /bin/bash

# Dossier par défaut. 
data="data/mydatalocal"
cd
cd $data

#création du dossier pour FASTQC. 
mkdir -p mydata/fastqc

#Récupérer mes données fastq:
fasta="download/Projet_31_20_UE_NGS_2020/FASTQ/*.gz"

#utilisation de Trinity test avec le premier jeu de données


Trinity --seqType fq \
        --max_memory 10G \
        --CPU 4 \
        --left Lib1_31_20_S1_R1_001.fastq.gz \
        --right Lib1_31_20_S1_R2_001.fastq.gz

#Résultat: cela prend une heure juste pour un jeu de données.


#Utinisation generalisé de trinity
        
Trinity --seqType fq \
        --max_memory 14G \
        --CPU 4 \
        --left Lib1_31_20_S1_R1_001.fastq.gz, \
        --right Lib4_31_20_S4_R2_001.fastq.gz,

# test de la boucle FASTQC: elle fonctionne correctement. 

for fichier in $fasta
do
  echo "$fichier"
done

# realisation et collecter des données en local. 

for fichier in $fasta
do
  fastqc $fichier --outdir mydata/fastqc \
        --format fastq \
        --threads 8
done

#j'utilise Trimmomatic pour retirer les mauvais rides des fichier
#création des output Trimmomatic
mkdir mydata/trimmomatic

#variavle pour input et output 
input="download/Projet_31_20_UE_NGS_2020"
output="mydata/trimmomatic"

# Utilisation de Trimmomatic:

java -jar /softwares/Trimmomatic-0.39/trimmomatic-0.39.jar -threads 8 -#! /bin/bash

# Dossier par défaut. 
data="data/mydatalocal"
cd
cd $data

#création du dossier pour FASTQC. 
mkdir -p mydata/fastqc

#Récupérer mes données fastq:
fasta="download/Projet_31_20_UE_NGS_2020/FASTQ/*.gz"

#utilisation de Trinity test avec le premier jeu de données


Trinity --seqType fq \
        --max_memory 10G \
        --CPU 4 \
        --left Lib1_31_20_S1_R1_001.fastq.gz \
        --right Lib1_31_20_S1_R2_001.fastq.gz

#Résultat: cela prend une heure juste pour un jeu de données.
        
#Utinisation generalisé de trinity
        
Trinity --seqType fq \
        --max_memory 14G \
        --CPU 4 \
        --left Lib1_31_20_S1_R1_001.fastq.gz, \
        --right Lib4_31_20_S4_R2_001.fastq.gz,

# test de la boucle FASTQC: elle fonctionne correctement. 

for fichier in $fasta
do
  echo "$fichier"
done

# realisation et collecter des données en local. 

for fichier in $fasta
do
  fastqc $fichier --outdir mydata/fastqc \
        --format fastq \
        --threads 8
done

#j'utilise Trimmomatic pour retirer les mauvais rides des fichier
#création des output Trimmomatic
mkdir mydata/trimmomatic

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
#test de la boucle
for n in $boucle
do
  echo "${n} fois"
done

#vrai essay: ça télécharge bien sur mydata/trimmomatic
for n in $boucle
do
  java -jar /softwares/Trimmomatic-0.39/trimmomatic-0.39.jar PE -threads 8 -phred33 $input/Lib${n}_31_20_S${n}_R1_001.fastq.gz $input/Lib${n}_31_20_S${n}_R2_001.fastq.gz $output/Lib${n}_31_20_S${n}_R1_paired.fastq.gz $output/Lib${n}_31_20_S${n}_R1_unpaired.fastq.gz $output/Lib${n}_31_20_S${n}_R2_paired.fastq.gz $output/Lib${n}_31_20_S${n}_R2_unpaired.fastq.gz ILLUMINACLIP:${fasta}:2:30:10 HEADCROP:9 MINLEN:100
done


### Jour 3:

#réalisation de FASTQC sur le resultat trimmomatic paired. Donc réalisation des inputs et outputs
input="mydata/trimmomatic"
mkdir -p mydata/fastqc/trimmomatic
output="mydata/fastqc/trimmomatic"

# test de fastqc
for fichier in $input/*_paired.fastq.gz
do
  echo $fichier
done

#vrai fastqc du résultat trimmomatic "paired"
for fichier in $input/*_paired.fastq.gz
do
  fastqc $fichier --outdir $output \
        --format fastq \
        --threads 8
done

# realisation de Trinity. 

# définition des outputs et inputs, ainsi que les listes pour les différents inputs: les R1 et les R2
input="mydata/trimmomatic"
mkdir -p mydata/trinity2
output="mydata/trinity2"
input_all1=$(ls $input/*R1_paired.fastq.gz |paste -d "," -s)
input_all2=$(ls $input/*R2_paired.fastq.gz |paste -d "," -s)

#teste des listes
echo $input_all1
echo $input_all2

#Trinity en fonctionnement
Trinity --seqType fq \
        --max_memory 14G \
        --CPU 4 \
        --left $input_all1 \
        --right $input_all2 \
        --output $output \
        --SS_lib_type RF

