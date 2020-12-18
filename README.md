## TP NGS Bat paillasse

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

# De novo :

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

  >Afin de quantifier le résultat obtenu avec Trinity, nous avons utilisé Salmon pour quantifier. Ainsi nous avons utilisé le programme index de Salmon afin de créer en premier lieu une index grâce au résultat de Trinity. Le code utilisé est le fichier salmon/salmon_index.sh. 

Voici les paramètres utilisés pour salmon index :

    - Entrée : mydata/trinity/Trinity_RF.fasta
    - Sortie : mydata/salmon_index
    - nombre de cœur du CPU : -p 4

  >Cela a été utilisé pour faire la quantification via l'outil quant de Salmon. Le code utilisé est le fichier salmon/salmon_quant.sh.

Voici les paramètres utilisés pour salmon quant :

    - Type de librairie : -l A
    - Entrée index : mydata/salmon_index
    - Entrée 1 : *R1_paired.fastq.gz de chaque échantillon dans mydata/trimmomatic/
    - Entrée 2 : *R2_paired.fastq.gz de chaque échantillon dans mydata/trimmomatic/
    - Sortie : mydata/salmon_quant/
    - nombre de cœur du CPU : -p 4
    - --validateMappings
    - --gcBias

Voici les résultats obtenus:

  - "compatible_fragment_ratio": **1.0**,
  - "num_compatible_fragments": **18,791,541**,
  - "num_assigned_fragments": **18,791,541**,
  - "num_frags_with_consistent_mappings": **18,289,808**,
  - "num_frags_with_inconsistent_or_orphan_mappings": **501,835**. 

En conclusion, nous pouvons y constater que le ratio de fragments compatibles est excellant et que cela est du en premier lieu à un nombre de fragments assigné (qui est égale au nombre de fragments compatibles) qui est élevé (18.791.541), et en second lieu un nombre de fragments avec un "mapping" consistant qui se trouve être très nettement supérieur à celui des "mapping" inconsistants ou orphelins (18.289.808 << 501.835). 

Une fois les résultats obtenus, j'ai réalisé le code suivant afin de voir combien de transcris de gènes sont présents (en prenant pour exemple celui de quant_4) :
```
grep "_" mydata/salmon_quant/quant_4/quant.sf |wc -l
```
On obtient alors 404 732, soit plus de 10 fois le nombre de gènes codant dans une cellule. 


# trouver les régions codants :

Afin d'identifier et d'annoté les régions codant, nous avons utilisé TransDecoder composer de **TransDecoder.LongOrfs** et **TransDecoder.Predict**. Le code utilisé est le fichier comparison/transdecoder/transdecoder.sh. 

  > Avec TransDecoder.LongOrfs, nous avons extrait les "long open reading frames" (LongORFs). Voici les différents paramètres utilisés :
  
    - Entrée fasta : mydata/trinity/Trinity_RF.fasta
    - Entrée gene_trans_map : mydata/trinity/Trinity_RF.fasta.gene_trans_map
    - Sortie de fichier : mydata/transdecoder
    - Taille minimum de protéines : 100
    - strand-specific : -S
    
  > Avec TransDecoder.Predict, nous avons prédit les régions codant probable. Voici les différents paramètres utilisés :
  
    - Entrée fasta : mydata/trinity/Trinity_RF.fasta
    - Sortie de fichier : mydata/transdecoder
    - --single_best_only

# Comparaison du transcrit :

Par la suite, nous avons comparais l'homologie entre le résultat que l'on a obtenu après avoir réalisé les scripts TransDecoder, et celui de Homo sapiens. 

  >Pour commencer, il a fallu récupérer les gènes de références de Homo sapiens. Pour cette étape, Le code utilisé est le fichier comparison/blast/ref_homo.sh. 

Voici les paramètres utilisés pour le téléchargement (utilisant le script wget) :

    - Sortie de téléchargement : mydata/blast/homo
    - Lien de téléchargement : ftp://ftp.ensembl.org/pub/release-101/fasta/homo_sapiens/cds/Homo_sapiens.GRCh38.cds.all.fa.gz

Le fichier obtenu à par la suite été décompresser afin d'utiliser le fichier par la suite via le code gunzip via le paramètre :

    - fichier à décompresser : mydata/blast/homo/Homo_sapiens.GRCh38.cds.fa.gz

  > Puis, nous avons ainsi pu comparais l'homologie en l'Homme et la chauve-souris. Pour cette étape, Le code utilisé est le fichier comparison/blast/blastn.sh.

Pour se faire, nous avons d'abord utilisé le logiciel de /softwares/ncbi-blast-2.10.1+/bin/makeblastdb avec comme paramètres :

    - Entrée : mydata/blast/homo/Homo_sapiens.GRCh38.cds.fa
    - Sortie : mydata/blast/makeblastdb/banque
    - Type de molecule du fichier cible : -dbtype nucl
    - -parse_seqids

Par la suite, nous avons utilisé le logiciel de /softwares/ncbi-blast-2.10.1+/bin/blastn afin de comparer contre Homo sapiens la similarité des séquences de chauves-souris obtenues, avec comme paramètres :

    - Entrée du résultat de makeblastdb : mydata/blast/makeblastdb/banque
    - Entrée du résultat TransDecoder : mydata/transdecoder/Trinity_RF.fasta.transdecoder.cds
    - Sortie : mydata/blast/blastn/blastn.blast
    - Expectation value threshold : -evalue 1e-4
    - Format de sortie : -outfmt 6
    - Nombre maximal de séquence aligner à conserver : -max_target_seqs 1

De la sorte, nous avons obtenu un fichier sous la forme d'un tableau nommé blastn.blast dans mydata/blast/. Celui-ci contient notamment le nom de chaque transcrit ainsi que le pourcentage d'homologie avec le génome de référence : Homo sapiens.


# comparaison de gènes exprimés entre le contrôle et le INF induction échantillon 

Une fois la quantification réalisée grâce à Salmon, on utilise le script de Deseq2 sur r afin de pouvoir comparer les gènes qui sont sur-exprimé ou sous-exprimé en condition d'induction INF contre le contrôle. Les détaille du code utilisé et les annotations sont dans le fichier DESeq2/DESeq.rmd. Les graphiques de cette partie y seront disponibles sur DESeq.html. 

dans le point "# La comparaison" de DESeq2/DESeq.rmd, les graphiques sont stockés dans graphic_NGS/GOrilla/, créé par GOrilla à partir des jeu de données téléchargées allreg, upreg et downreg (ech6) (ou de la version "x" pour ech5) sur le téléchargement all.csv (pour ech6 our bien la version "x" pour ech5). On n'observe pas une grande différence pour ech6 par port au jeu de données ech5. 

Cependant, nous pouvons constater que c'est uniquement la "sur transcription"  qui a un effet significatif sur les différentes fonctions et process de la cellule. 
  - Concernant le processus moléculaire, nous pouvons constater différents facteurs qui sont très significativement modifié. En premier lieu la réponse immunitaire que ce soit contre les virus (se trouve très particulièrement activé notamment sur la plupart des processus où que la lutte contre le virus sont importants) mais aussi contre tout type de pathogènes et tout activation du système immunitaire se voit de façon générale activée. Bien entendu, cela active aussi la régulation de différents types d'interféron.
  - concernant les fonctions cellulaires, ce sera surtout ceux qui impact l'activité catalytique qui sera le plus différentiellement réguler. Cependant, la p-value reste assez élevé par rapport à précédemment montrant que cela est bien moins impacté que les processus moléculaire.
  - enfin, concernant les composants cellulaires, ce sera surtout ceux qui qui se situ au niveau de la partie endosomale et la membrane endosomale qui y sera différentiellement réguler.

** Avant de continuer ici, il faut finir de lire le DESeq.rmd**

# Conclusion 

En conclusion, voici un schéma récapitulatif de ce que nous avons réalisé durant tout le TP de NGS :

![TP NGS résumé](picture/final_summary.png)

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


TransDecoder.LongOrfs :

  - Version : /softwares/TransDecoder-TransDecoder-v5.5.0/TransDecoder.LongOrfs
  - Référence : https://github.com/TransDecoder/TransDecoder/wiki


TransDecoder.Predict :

  - Version : /softwares/TransDecoder-TransDecoder-v5.5.0/TransDecoder.Predict
  - Référence : https://github.com/TransDecoder/TransDecoder/wiki


/softwares/ncbi-blast-2.10.1+/bin/makeblastdb :

  - Version : makeblastdb: 2.10.1+ / Package: blast 2.10.1, build May 12 2020 12:15:11
  - Référence : https://blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=Web&PAGE_TYPE=BlastNews


/softwares/ncbi-blast-2.10.1+/bin/blastn :

  - Version : blastn: 2.10.1+ / Package: blast 2.10.1, build May 12 2020 12:15:11
  - Référence : https://blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=Web&PAGE_TYPE=BlastNews


tximport :

  - Version : 1.18.0
  - Référence : Charlotte Soneson, Michael I. Love, Mark D. Robinson (2015) Differential analyses for RNA-seq: transcript-level estimates improve gene-level inferences. F1000Research. http://doi.org/10.12688/f1000research.7563


DESeq2-package :

  - Version : 1.30.0
  - Référence : Love, M.I., Huber, W., Anders, S. (2014) Moderated estimation of fold change and dispersion for RNA-seq data with DESeq2. Genome Biology, 15:550. https://doi.org/10.1186/s13059-014-0550-8


BiocManager :

  - Version : 1.30.10
  - Référence : https://github.com/Bioconductor/BiocManager


biomaRt :

  - Version : 2.46.0
  - Référence : https://git.bioconductor.org/packages/biomaRt

GOrilla :

  - Version : utilisée en date du 17/12/2020
  - Référence : http://cbl-gorilla.cs.technion.ac.il


XXX :

  - Version : 
  - Référence :

XXX :

  - Version : 
  - Référence :


XXX :

  - Version : 
  - Référence :

XXX :

  - Version : 
  - Référence :


XXX :

  - Version : 
  - Référence :

