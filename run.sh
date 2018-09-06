#!/usr/bin/bash

make;
./search | perl -n smali_injection.pl;
