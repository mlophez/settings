#!/bin/bash

if test -L /dev/shm; then
    rm /dev/shm
    mkdir /dev/shm
    chmod 777 /dev/shm
    mount --bind /run/shm /dev/shm
    chmod 777 /dev/shm
fi
