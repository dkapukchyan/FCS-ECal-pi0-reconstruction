#!/bin/bash

echo "Please write down the run number"
read run

for i in {0..9}
do
    Target="./$run/StFcsPi0invariantmassAll$i.root"
    Source="./$run/StFcsPi0invariantmass${run}_*$i.root"
    eval "hadd -f $Target $Source"
done

eval "hadd -f ./$run/StFcsPi0invariantmassAll.root ./$run/StFcsPi0invariantmassAll?.root"
