#$ -S /bin/bash
#$ -V
#$ -cwd
#$ -j yes

## Copyright 2017 Luz Marina Martin and Noelia Almagro

## This file is part of MREPIPE

## MREPIPE is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.

## MREPIPE is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.

## You should have received a copy of the GNU General Public License
## along with MREPIPE.  If not, see <http://www.gnu.org/licenses/>.


SAMPLE_TYPE=$1
WORKING_DIR=$2
EXPERIMENT=$3
INTERSECTION=$4

echo "Mapping" $SAMPLE_TYPE "is running" >> $WORKING_DIR/$EXPERIMENT/logs.txt

## Accessing sample directory

cd $WORKING_DIR/$EXPERIMENT/samples/$SAMPLE_TYPE

## Quality analysis

echo "Quality analysis of control sample" >> $WORKING_DIR/$EXPERIMENTlogs.txt

fastqc $SAMPLE_TYPE.fastq

## Mapping control sample to reference genome

echo "Mapping control sample to reference genome" >> $WORKING_DIR/$EXPERIMENT/logs.txt

bowtie $WORKING_DIR/$EXPERIMENT/genome/index -q $SAMPLE_TYPE.fastq -S -v 2 --best --strata -m 1 > $SAMPLE_TYPE.sam

## Converting .sam into .bam in order to be able to visualize in IGV 

echo "Converting " $SAMPLE_TYPE".sam into" $SAMPLE_TYPE".bam" >> $WORKING_DIR/$EXPERIMENT/logs.txt

samtools view -b -S $SAMPLE_TYPE.sam > $SAMPLE_TYPE.bam

## When you align FASTQ files, the alignments produced are in random order with
## the respect to heir position in the referece genomes. To visualize the alignment in 
## IGV BAM files require further manipulation. It must be sorted such the alignments
## occur in genome order. ORdered positionally based upon their alignment coordinates
## on each chromosome.

samtools sort $SAMPLE_TYPE.bam -o $SAMPLE_TYPE.sorted.bam

echo $SAMPLE_TYPE".sam bam sorted" >> $WORKING_DIR/$EXPERIMENT/logs.txt

## Indexing a genome sorted BAM file allows one to quickly extract alignments overlapping
## particular genomic regions. Moreover, indexing is required by genome viewers
## can quickly display alignments in each genomic region to which you navigate.

samtools index $SAMPLE_TYPE.sorted.bam

echo "Index created" >> $WORKING_DIR/$EXPERIMENT/logs.txt

####################################

## Synchronysation point using a blackboard

## Writing information to the blackboard

echo $SAMPLE_TYPE "DONE" >> $WORKING_DIR/$EXPERIMENT/blackboard.txt

## Reading information from the blackboard 

DONE_SAMPLES=$( wc -l $WORKING_DIR/$EXPERIMENT/blackboard.txt | awk '{ print $1 }' )

## Checking point of synchronisation point to check whether or not all samples are already done

if [ $DONE_SAMPLES -eq 2 ]
then
   qsub -N peak_calling -o log_peak_calling $HOME/opt/MREPIPE/peak_calling.sh $WORKING_DIR $EXPERIMENT $INTERSECTION
fi


