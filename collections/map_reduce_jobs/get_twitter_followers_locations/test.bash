#!/bin/bash


for i in ../../data/* 
do
    if test -f "$i" 
    then
       cat $i | ./map.py | ./reduce.py
    fi
done
