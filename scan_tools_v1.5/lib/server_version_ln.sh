#!/bin/bash
ls /opt -l |grep dragonball|cut -d '-' -f 3|cut -d '.' -f 1-4
