### TP NGS Bat paillasse

readme du projet ngs

La réponse immunitaire aux Interférons pourrais être différent entre les différentes espèces de chauve-souris. Par ailleurs, différentes duplications des IGSs ont été observées dans les différentes espèces de chauves-souris, mais les différentes copies n'inspecterai pas les la réponse à l'interférons de type I. 

Une équipe du CIRI, à Lyon, France, a donc réalisé un RNAsaq sur des cultures de cellules de *Myotis velifer* exposées ou non à de l'IFN pendant 6 heures. Cela à notamment pour but de déterminer quel ISGs sont transcriptomiquement réguler par l'induction d'IFN. 

Pour ce faire, nous avons utilisé différents scripts et programmes que l'**on peut trouver les références en bas du document**. 


# Téléchargement des données :

En premier lieu, les données sont récupérées via site FTP de la paterforme de séquençage de l'IGFL. Cela fut réalisé grace au script suivant :
```
wget -r --ftp-user=igfl-UE_NGS_2020 --ftp-password=XXX ftp:YYY
```

Étant donné que les données sont privées, l'identifiant et le mot de passe sont remplacés par XXX et YYY. 

La structure du jeu de données est la suivante:
6 échantillons, composés de 3 controles et de 3 traitements, avec environ 30 millions de lectures par échantillons. Chaque échantillons est composé de 2 fichiers étant les 2 read paired-end lu, R1 et R2 :
![image echantillons](picture/Capture%20d’écran%202020-11-20%20à%2009.46.43.png)

**Tout ce qui se trouve dans /mydata et /download sont indisponibles car sont des données privés.**


# controle qualité :

On a commencé par examiner la qualité des jeux de données que l'on a reçu. Pour ce faire, on a utilisé le programme FASTQC afin de pouvoir analyser la qualité des différents jeux de données comprenant le séquençage des ARNm. On peut retrouver le code qui a été écrit pour faire cela dans le fichier data_quality_control/fastqc/fastqc_original_data.sh

Voici les paramètres de FASTQC:

    - Sortie : mydata/fastqc/original_data
    - Format de fichier : fastq
    - nombre de Coeur utilisé : 4


voici 2 résultats type:

Celui de Lib1_31_20_S1_R1 :
![FASTQC image](picture/Lib1_31_20_S1_R1_001.fastq.gz%20FastQC%20Report-1.png)

Celui de Lib1_31_20_S1_R2 :
![FASTQC image](picture/Lib1_31_20_S1_R2_001.fastq.gz%20FastQC%20Report-1.png)

Sur la gauche, on peut constater dans le summary les différents tests qui ont été réalisés ainsi que la qualité des résultats qui sont bon (vert), moyen (orange) ou mauvais (rouge). 

Sur la droite, il s'agit des résultats de la qualité des séquences le long des lectures. En premier lieu, on peut constater que parmi les premières pairs de bases (bp) il y a une mauvaise qualités des séquences. De même, la qualité de ses dernières diminu de plus en plus quand on avance sur les séquences. Cela est très certainement dû à la lecture des adaptateurs sur certaines séquences, ce qui est corrélé avec le résultat de "Adapter Content" qui monte jusqu'à 22% des séquences. Il faudrat donc réaliser une coupe au début de la séquence et enlever les séquences des adaptateur utilisez à la fin.

Afin d'harmoniser les résultats ainsi que d'améliorer la qualité des séquences, nous avons utilisé le programme Trimmomatic. Il est possible de voir le code utilisé dans trimmomatic/trimmomatic.sh.
**La suite est réalisée avec uniquement les paired fichiers**.

Voici les paramètres de Trimmomatic :

    - Entrer 1 : download/Projet_31_20_UE_NGS_2020/FASTQ/fichier avec fichier = R1
    - Entrer 2 : download/Projet_31_20_UE_NGS_2020/FASTQ/fichier avec fichier = R2
    - Les 4 sorties : mydata/trimmomatic/
    - nombre de coeur : 4
    - Phred33
    - taille minimum : MINLEN:100
    - taille de la coupe au début des séquences : HEADCROP:9
    - la séquence de l'adaptateur : ILLUMINACLIP:download/adapt.fasta:2:30:10 HEADCROP:9 MINLEN:100


Comme on peut constater, les résultats sont globalement concluant sur la qualité des séquençage. Au revanche, on peut constater qu'il y a des problèmes au niveau des neuf premiers pas de base ainsi que à la fin de chaque séquence. Pour ce dernier, il est possible que ce soit les inserts qui soit aussi analyser, réduisant ainsi la fiabilité à la fin. Pour régler le problème, on a décidé de faire fonctionner le logiciel Trimmomatic afin de régler les différents problèmes Ainsi que d'harmoniser les différents séquençage. 

La suite est réalisée avec uniquement les paired fichiers. Le résultat de Trimmomatic se situe dans mydata/trimmomatic. 


# second controle qualité:

Le programme FASTQC À été relancé cette Fois ci sur les résultats de Trimmomatic paired, afin de vérifier si la qualité des séquences à été améliorées. Le script utilisé pour ce FASTQC est quality_control/fatsqc/fastqc_trimmomatic.sh. 

Voici les paramètres de ce FASTQC: 

    - Sortie : mydata/fastqc/trimmomatic
    - Format de fichier : fastq
    - nombre de Coeur utilisé : 4

Un résultat type avec celui de Lib3_31_20_S3_R1_paired :
![FASTQC image](picture/Lib3_31_20_S3_R1_paired.fastq.gz%20FastQC%20Report-1.png)

Comme on peut le constater, la qualité des séquences notamment au début se sont améliorées, ainsi que les résultats des autres test. Au revanche, on a toujours une légère baisse de Q à la fin des lectures mais c'est classique avec Illumina. Concernant le test "Adapter Content", on est passé de 22% à moins de 2% des séquences qui contient un adaptateur. 

# Trinity :

Grâce à Trinity, on pourra reconstrure les séquences des transcrits dans les cellules étudiées. Ainsi on pourra avoir pour chaque gène exprimé, un ou plusieurs transcrits alternatif. le script utilisé se trouve dans data_quality_control/Trinity.sh.                  

Voici les paramètres utilisés pour Trinity :

    - seqType : fq
    - max_memory : 14 GB
    - nombre de coeur CPU : 4
    - SS_lib_type : RF
    - Entrée gauche : tous les *R1_paired.fastq.gz dans mydata/trimmomatic/
    - Entrée droite : tous les *R2_paired.fastq.gz dans mydata/trimmomatic/
    - Sortie : mydata/trinity/Trinity_RF.fasta

afin de voir le nombre de transcrit sans compter le nombre les différents isoforme, j'ai utilisé le script suivant :
```
grep ">" mydata/trinity/Trinity_RF.fasta |cut -f1,2,3,4 -d "_"|sort |uniq |wc -l
```
Cela nous donne un résultat de 311 364, soit 10 fois plus que le nombre de gènes codant dans une cellule. 


# Quantification des gènes transcrits :

Afin de quantifier le résultat obtenu avec Trinity, nous avons utilisé Salmon pour quantifier. Ainsi nous avons utilisé le programme index de Salmon afin de créer en premier lieu une index grâce au résultat de Trinity. Le code utilisé est le fichier salmon_index.sh. 

Voici les paramètres utilisés pour salmon index :

    - Entrée : mydata/trinity/Trinity_RF.fasta
    - Sortie : mydata/salmon_index
    - nombre de coeur du CPU : 4

Cela a été utilisé pour faire la quantification via l'outil quant de Salmon. 

Voici les paramètres utilisés pour salmon quant :

    - Type de librairie : -l A
    - Entrée index : mydata/salmon_index
    - Entrée 1 : *R1_paired.fastq.gz de chaque échantillon dans mydata/trimmomatic/
    - Entrée 2 : *R2_paired.fastq.gz de chaque échantillon dans mydata/trimmomatic/
    - Sortie : mydata/salmon_quant/
    - --validateMappings


# outils utilisés :

FASTQC :

  - Version : FastQC v0.11.8
  - Référence : https://www.bioinformatics.babraham.ac.uk/projects/fastqc/


Trimmomatic :

  - Version : 0.39
  - Référence : http://www.usadellab.org/cms/?page=trimmomatic


Trinity :

  - Version : Trinity-v2.8.5
  - Référence : https://github.com/trinityrnaseq/trinityrnaseq/wiki


Salmon :

  - Version : salmon 0.14.1
  - Référence : https://salmon.readthedocs.io/en/latest/salmon.html


















