#!/bin/bash
cat /etc/passwd | grep "/var/www/" | cut -f1 -d:
