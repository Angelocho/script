#!/bin/bash
mail=0
nombre=0
password=$(openssl rand -base64 12)
read -p "Dame el nombre " nombre
read -p "Dame el mail " mail

id $nombre >&/dev/null && echo "usuario existente" && exit 3

if [[ -z "$nombre" ]] || [[ -z "$mail" ]]
then
        echo " el nombre o el mail está vacio" 
else
        echo Creando $nombre ....
        useradd -d /var/www/$nombre -m -s /bin/bash $nombre
		echo "$nombre:$password" | chpasswd
		echo Tu contraseña de usuario es $password

		echo Creando sitio $nombre.iaw.com
        sed 's/<usuario>/${nombre}/g' /etc/apache2/sites-available/000-plantilla.conf > /etc/apache2/sites-available/$nombre.conf
	
		echo Creando blog blog.$nombre.iaw.com
        sed 's/<usuario>/${nombre}/g' /etc/apache2/sites-available/000-blog-plantilla.conf > /etc/apache2/sites-available/$nombre-blog.conf
	
		a2ensite $nombre.conf
		a2ensite $nombre-blog.conf
		mkdir -p /var/www/$nombre
		mkdir -p /var/www/blog/$nombre
		chown $nombre /var/www/$nombre
		chown -R $nombre /var/www/$nombre/
        mkdir -p /var/www/blog/$nombre/  
		chown $nombre /var/www/blog/$nombre
		chown -R $nombre /var/www/blog/$nombre/
		systemctl
fi
