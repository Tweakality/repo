#!/usr/bin/env bash 

dpkg-scanpackages -m ./debs > Packages
bzip2 Packages