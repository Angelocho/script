#!/bin/bash
read -p "Dame el nombre " nombre
if [[ -z "$nombre" ]]
then
        echo " el nombre está vacio" 
else
        echo Borrando $nombre ....
        userdel $nombre
	rm -r /var/www/$nombre
	rm -r /etc/apache2/sites-available/$nombre.conf
	rm -r /etc/apache2/sites-available/$nombre-blog.conf
fi
