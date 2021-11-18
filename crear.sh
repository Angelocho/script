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
        echo "Creando $nombre ...."
        useradd -d /var/www/$nombre -m -s /bin/bash $nombre
		echo "$nombre:$password" | chpasswd
		"echo Tu contraseña de usuario es $password"

		echo "Creando sitio $nombre.iaw.com"
        sed "s/<usuario>/$nombre/g" /etc/apache2/sites-available/000-plantilla.conf > /etc/apache2/sites-available/$nombre.conf
	
		echo "Creando blog blog.$nombre.iaw.com"
        sed "s/<usuario>/$nombre/g" /etc/apache2/sites-available/000-blog-plantilla.conf > /etc/apache2/sites-available/$nombre-blog.conf
	
		a2ensite $nombre.conf
		a2ensite $nombre-blog.conf

		echo "Creando carpetas y modificando permisos..."
		mkdir -p /var/www/$nombre
		mkdir -p /var/www/blog/$nombre
		chown $nombre /var/www/$nombre
		chown -R $nombre /var/www/$nombre/
        mkdir -p /var/www/blog/$nombre/  
		chown $nombre /var/www/blog/$nombre
		chown -R $nombre /var/www/blog/$nombre/
		systemctl reload apache2

		echo "Procediendo a instalar un wordpress..."
		
		mysql -e CREATE DATABASE $nombre;
		mysql -e CREATE USER "$nombre"@"localhost" IDENTIFIED BY "$password";
		mysql -e GRANT ALL ON $nombre.* TO "$nombre"@"localhost";
		exit
fi
