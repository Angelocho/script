#!/bin/bash
mail=0
nombre=0
password=$(openssl rand -base64 12)
read -p "Dame el nombre " nombre
read -p "Dame el mail " mail

nombre=$(echo $nombre | tr '[:upper:]' '[:lower:]')

id $nombre >&/dev/null && echo "usuario existente" && exit 3
#(echo "$mail"| grep -Eq ^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,5}$) 


if [[ $mail =~ ^[a-zA-Z0-9_]+@[a-zA-Z_]+?\.[a-zA-Z]{2,5}$ ]]; then
if [[ -z "$nombre" ]] || [[ -z "$mail" ]]
then
        echo " el nombre o el mail está vacio" 
else
        echo "Creando $nombre ...."
        useradd -d /var/www/$nombre -m -s /bin/bash $nombre
		echo "$nombre:$password" | chpasswd
		

		echo "Creando sitio $nombre.iaw.com"

        sed "s/<usuario>/$nombre/g" /etc/apache2/sites-available/000-plantilla.conf > /etc/apache2/sites-available/$nombre.conf
	   
		echo "Creando blog blog.$nombre.iaw.com"

        sed "s/<usuario>/$nombre/g" /etc/apache2/sites-available/000-blog-plantilla.conf > /etc/apache2/sites-available/$nombre-blog.conf
	
		a2ensite $nombre.conf >&/dev/null
		a2ensite $nombre-blog.conf >&/dev/null

		echo "Creando carpetas y modificando permisos..."
		mkdir -p /var/www/$nombre
		mkdir -p /var/www/$nombre/files
		chown root:root /var/www/$nombre
		chmod 755 /var/www/$nombre
		chown $nombre:$nombre /var/www/$nombre/*
		chmod 770 /var/www/$nombre/*  
		echo "Este es el fichero index.html de $nombre" >> /var/www/$nombre/files/index.html
		chown $nombre:$nombre /var/www/$nombre/files/index.html
		systemctl reload apache2

		echo "Procediendo a instalar un wordpress..."
		
		mysql -e "CREATE DATABASE $nombre";
		mysql -e "CREATE USER "$nombre"@"localhost" IDENTIFIED BY '$password'";
		mysql -e "GRANT ALL ON $nombre.* TO "$nombre"@"localhost"";
		wget -O /var/www/blog/$nombre https://es.wordpress.org/latest-es_ES.tar.gz >&/dev/null
		tar -xvzf /var/www/blog/$nombre -C /var/www/blog/ >&/dev/null
		rm -rf /var/www/blog/$nombre
		mv /var/www/blog/wordpress /var/www/blog/$nombre
		chown $nombre /var/www/blog/$nombre
		chmod 770 /var/www/blog/$nombre
		chown -R $nombre /var/www/blog/$nombre/ 
		

		echo "Configurando Wordpress..."
		cp /var/www/blog/$nombre/wp-config-sample.php /var/www/blog/$nombre/wp-config.php
		chown $nombre:$nombre /var/www/blog/$nombre/wp-config.php
		
		sed -i "s/database_name_here/$nombre/g" "/var/www/blog/$nombre/wp-config.php"
		sed -i "s/username_here/$nombre/g" "/var/www/blog/$nombre/wp-config.php"
		sed -i "s/password_here/$password/g" "/var/www/blog/$nombre/wp-config.php"
		         
		mv /var/www/blog/$nombre /var/www/blog/wordpress
		chown $nombre:$nombre -R /var/www/blog/wordpress
		mv /var/www/blog/wordpress /var/www/$nombre/
		
		chmod 770 /var/www/$nombre/* 
		echo "Configurando acceso por sftp..."
		adduser $nombre sftpusers
		

		echo "Enviando por mail la contraseña...."
		echo $password
		echo "Tu contraseña de usuario para conectarte por sftp es $password y tu usuario $nombre, además ya puedes visitar tu sitio web ($nombre.iaw.com) y blog (blog.$nombre.iaw.com)" | mail -s "Account Password for you $nombre" $mail >&/dev/null

fi
else
    echo "Email Invalido"
fi