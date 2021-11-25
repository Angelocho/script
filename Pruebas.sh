#!/bin/bash
mail=0
read -p "gidasygu " mail
if [[ $mail =~ ^[a-zA-Z0-9_]+@[a-zA-Z_]+?\.[a-zA-Z]{2,5}$ ]]; then
    echo "Valido"
else
    echo "Email Invalido"
fi