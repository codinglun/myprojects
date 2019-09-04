#!/bin/bash
systemctl status NetworkManager|grep Active|cut -d ':' -f 2-
