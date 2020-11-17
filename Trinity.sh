#! /bin/bash

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

for fichier in download/sharegate-igfl.ens-lyon.fr/Projet_31_20_UE_NGS_2020/FASTQ/*.gz
do
  echo "$fichier"
done

# realisation et collecter des données en local. 

for fichier in download/sharegate-igfl.ens-lyon.fr/Projet_31_20_UE_NGS_2020/FASTQ/*.gz
do
  fastqc $fichier --outdir download/fastqc \
        --format fastq \
        --threads 8
done


