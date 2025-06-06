#!/bin/bash

source 100idHkl_startup_env

export GI_TYPELIB_PATH=/home/beams2/MWYMAN/micromamba/envs/bluesky_2024_1/envs/hkl/lib/girepository-1.0
# export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

../../bin/rhel9-x86_64/hklApp st_base.cmd

