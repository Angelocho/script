#!/bin/bash
read -p "Dame el nombre " nombre
nombre=$(echo $nombre | tr '[:upper:]' '[:lower:]')
if [[ -z "$nombre" ]]
then
        echo " el nombre está vacio" 
      elif id $nombre;  then

        echo Borrando $nombre ....
        userdel $nombre
	rm -rf /var/www/$nombre
        rm -rf /var/www/blog/$nombre
        a2dissite $nombre.conf >&/dev/null
        a2dissite $nombre-blog.conf >&/dev/null
	rm -rf /etc/apache2/sites-available/$nombre.conf
	rm -rf /etc/apache2/sites-available/$nombre-blog.conf
        
        mysql -e "DROP DATABASE $nombre";
        mysql -e "DROP USER $nombre@localhost";
       else
           echo "Usuario no existe"

fi
