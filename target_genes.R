args <- commandArgs(TRUE)

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


if(length(args) != 3)
{
	print("Incorrect number of parameters. Parameters are:")
	print(" NDG file")
	print(" Overlap file")
	print(" Name of output file")

}


ndg.file <- args[1]
overlap.file <- args[2]
output.file <- args[3]


get.first <- function(elto)
{
  return(strsplit(elto,"\\.")[[1]][1])
}

peaks.overlap <- read.table(file=overlap.file, header=TRUE,comment.char="%",fill=TRUE)
overlapping.genes <- as.vector(peaks.overlap[["OverlapGene"]])

overlapping.genes <- sapply(overlapping.genes,get.first)
names(overlapping.genes) <- NULL
overlapping.genes <- unique(overlapping.genes)
length(overlapping.genes)

peaks.ndg <- read.table(file=ndg.file, header=TRUE,comment.char="%",fill=TRUE)
head(peaks.ndg)
fw.genes <- as.vector(peaks.ndg[["Downstream_FW_Gene"]])
rv.genes <- as.vector(peaks.ndg[["Downstream_REV_Gene"]])

ndg.fw.genes <- as.vector(fw.genes[peaks.ndg[["X.Overlaped_Genes"]] == 0 & 
                          (peaks.ndg[["Distance"]] < peaks.ndg[["Distance.1"]]) & 
                          (peaks.ndg[["Distance"]] < 2000)])
ndg.rv.genes <- as.vector(rv.genes[peaks.ndg[["X.Overlaped_Genes"]] == 0 & 
                         (peaks.ndg[["Distance_fw"]] > peaks.ndg[["Distance.1"]]) & 
                         (peaks.ndg[["Distance.1"]] < 2000)]) 

ndg.genes <- c(ndg.fw.genes,ndg.rv.genes)
ndg.genes <- sapply(ndg.genes,get.first)
names(ndg.genes) <- NULL
length(ndg.genes)

target.genes <- unique(c(ndg.genes,overlapping.genes))
length(target.genes)
write(as.vector(unlist(target.genes)),file=output.file)

