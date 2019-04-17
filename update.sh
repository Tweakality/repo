#!/usr/bin/env bash 
rm -r -f Packages.bz2
dpkg-scanpackages -m ./debs > Packages
bzip2 Packages