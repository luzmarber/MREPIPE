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


WORKING_DIR=$1
EXPERIMENT=$2
INTERSECTION=$3

echo "Peak calling" >> $WORKING_DIR/$EXPERIMENT/logs.txt

## Accessing the results directory

cd $WORKING_DIR/$EXPERIMENT/results

## Peak Calling

macs2 callpeak -t $WORKING_DIR/$EXPERIMENT/samples/chip/chip.sam -c $WORKING_DIR/$EXPERIMENT/samples/control/control.sam -f SAM --outdir . -n chipout

## Running R script model.R generated by the peak calling

echo "Running R script model.R generated by the peak calling" >> $WORKING_DIR/$EXPERIMENT/logs.txt

Rscript chipout_model.r

## Peak Annotation

echo "Peak annotation" >> $WORKING_DIR/$EXPERIMENT/logs.txt

java -jar -Xmx4g /home/noeluz/opt/PeakAnnotator.jar -u NDG -p chipout_summits.bed -a $WORKING_DIR/$EXPERIMENT/annotation/annotation.gtf -o . -g all

## Selecting targets genes

echo "Selecting targets genes" >> $WORKING_DIR/$EXPERIMENT/logs.txt 

Rscript $HOME/opt/MREPIPE/target_genes.R $WORKING_DIR/$EXPERIMENT/results/chipout_summits.ndg.bed $WORKING_DIR/$EXPERIMENT/results/chipout_summits.overlap.bed target_genes.txt

## Intersectioning genes

Rscript $HOME/opt/MREPIPE/venny.R $INTERSECTION $WORKING_DIR/$EXPERIMENT/results/target_genes.txt  $WORKING_DIR/$EXPERIMENT/results

## TSS Mapping with HOMER

##echo "TSS Mapping with HOMER" >> $WORKING_DIR/$EXPERIMENT/logs.txt

##findMotifsGenome.pl chipout_summits.bed $WORKING_DIR/$EXPERIMENT/genome/genome.fa HOMER_results/primary_motifs -size 50 
##findMotifsGenome.pl chipout_summits.bed $WORKING_DIR/$EXPERIMENT/genome/genome.fa HOMER_results/secondary_motifs -size 200

echo "Crying because it is done" >> $WORKING_DIR/$EXPERIMENT/logs.txt
