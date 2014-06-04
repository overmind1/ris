#!/bin/bash
set -e
set -x

srcIP='172.17.8.8'

geanyName=''

DIRRPM=rpmdir
mkdir -p $DIRRPM

declare -A plt=( ['i386']='i686' ['x86_64']='x86_64')
declare -a lct=( 10.242.40.103 \
                 10.242.50.103 \
                 10.252.10.65 \
                 10.252.20.65 \
                 10.252.30.65 \
                 10.252.40.65 )
#                 10.252.50.65 )

for p in "${!plt[@]}"
do
        rsync -a ris@$srcIP:/mnt/repo/extra/el6/$p/geany-1.24.1-2.el6.${plt[$p]}.rpm $DIRRPM/.
done

for p in "${!plt[@]}"
do
        for l in "${lct[@]}"
        do
        rsync -a $DIRRPM/geany-1.24.1-2.el6.${plt[$p]}.rpm ris@$l:/mnt/repo/extra/el6/$p/
        ssh ris@$l "createrepo /mnt/repo/extra/el6/$p"
        done
done

