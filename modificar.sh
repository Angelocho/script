#!/bin/bash
read -p "Dame el nombre " nombre
read -p "Dame el mail " mail
password=$(openssl rand -base64 12)
nombre=$(echo $nombre | tr '[:upper:]' '[:lower:]')

if [[ -z "$nombre" ]]
then
        echo " el nombre está vacio" 
      elif id $nombre;  then
        echo "$nombre:$password" | chpasswd
        echo "Tu NUEVA contraseña de usuario para conectarte por sftp es $password y tu usuario $nombre" | mail -s "New Account Password $nombre" $mail >&/dev/null
        echo "Contraseña modificada"
       else
           echo "Usuario no existe"

fi