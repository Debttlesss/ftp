#!/bin/bash

sudo apt -y install vsftpd 
     
touch vsftpd.conf



# MODO PASIVO  #
read -p "Quieres acticvar el modo pasivo? (y)es (N)o: " enablepasivemode

if [ "$enablepasivemode" = "y" ]; then
    read -p "Primer puerto del rango: " puertoentrante
    read -p "Ultimo puerto del rango: " puertosaliente

else
    read "No se ha activado el modo pasivo"
fi

#puertos
ufw allow $puertoentrante:$puertosaliente/tcp 


# UFW #

#instalar
read -p "Quieres instalar ufw? (y)es (n)o: " respuesta1ufw
if [ "$respuesta1ufw" = "y" ]; then
    sudo apt -y install ufw
else
    read "No se ha instalado el servicio ufw"
fi

#habilitar
read -p "Quieres habilitar ufw? (y)es (n)o: " respuesta2ufw
if [ "$respuesta2ufw" = "y" ]; then
    sudo ufw enable
    sudo ufw status
else
    read "No se ha activado el servicio ufw"
fi



#####ESCRIBIR DENTRO DE ARCHIVO

#listen
sed -n '1,13p' configuracionreal > vsftpd.conf

read -p "iniciar automaticamente? (y)es (N)o: " listen

if [ "$listen" = "y" ]; then
    echo "listen=YES" >> vsftpd.conf

else
    echo "listen=NO" >> vsftpd.conf

fi
#anonymouse_enable
sed -n '15,24p' configuracionreal >> vsftpd.conf

read -p "Permitir usuario anonimo? (y)es (N)o: " anonymous

if [ "$anonymous" = "y" ]; then
    echo "anonymous_enable=YES" >> vsftpd.conf
else
    echo "anonymous_enable=NO" >> vsftpd.conf

fi
#local_enable
sed -n '26,27p' configuracionreal >> vsftpd.conf

read -p "Permitir usuarios locales? (y)es (N)o: " local_enable

if [ "$local_enable" = "y" ]; then
    echo "local_enable=YES" >> vsftpd.conf
else
    echo "local_enable=NO" >> vsftpd.conf

fi
#logeos
sed -n '29,56p' configuracionreal >> vsftpd.conf

read -p "Quieres llevar un registro de los logeos? (y)es (N)o: " logeos

if [ "$logeos" = "y" ]; then
    echo "xferlog_enable=YES" >> vsftpd.conf
else
    echo "xferlog_enable=NO" >> vsftpd.conf

fi
#puerto20
sed -n '58,59p' configuracionreal >> vsftpd.conf

read -p "Te quieres conectar desde el puerto 20? (y)es (n)o: " puerto20

if [ "$logeos" = "y" ]; then
    echo "connect_from_port_20=YES" >> vsftpd.conf
else
    echo "connect_from_port_20=NO" >> vsftpd.conf

fi
#certificado
sed -n '61,148p' configuracionreal >> vsftpd.conf

read -p "Quieres cambiar el certificado? (y)es (n)o: " certificado

if [ "$certificado" = "y" ]; then

    read -p "directorio del certificado:" directoriocert

    echo "rsa_cert_file=$directoriocert" >> vsftpd.conf
else
    echo "rsa_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.kev" >> vsftpd.conf

fi
#clave
read -p "Quieres cambiar la clave RSA? (y)es (n)o: " clave

if [ "$clave" = "y" ]; then

    read -p "directorio de la clave:" directorioclave

    echo "rsa_private_key_file=$directorioclave" >> vsftpd.conf
else
    echo "rsa_private_key_file=/etc/ssl/private/ssl-cert-snakeoil1.key" >> vsftpd.conf

fi
#ssl
read -p "Habilitar ssl? (y)es (n)o: " ssl

if [ "$ssl" = "y" ]; then
    echo "ssl_enable=YES" >> vsftpd.conf
else
    echo "ssl_enable=NO" >> vsftpd.conf

fi
# final de archivo #
sed -n '152,156p' configuracionreal >> vsftpd.conf
echo "#" >> vsftd.conf
echo "#" >> vsftd.conf
echo "#" >> vsftd.conf
#enjaular usuario local
read -p "Enjaular usuario local? (y)es (n)o: " jaula
echo "#enjaular usuario local" >> vsftpd.conf

if [ "$jaula" = "y" ]; then
    echo "chroot_local_user=YES" >> vsftpd.conf
else
    echo "chroot_local_user=NO" >> vsftpd.conf

fi
echo "#" >> vsftd.conf


#dar permisos de escritura (el servidor ya no es solo de descarga)
read -p "Dar permisos de escritura (servidor no solo de descarga)? (y)es (n)o: " writeable
echo "#dar permisos de escritura (el servidor ya no es solo de descarga)" >> vsftpd.conf

if [ "$writeable" = "y" ]; then
    echo "allow_writeable_chroot" >> vsftpd.conf
else
    echo "#allow_writeable_chroot" >> vsftpd.conf

fi
echo "#" >> vsftd.conf


#permitir que usuarios modifiquen ficheros
read -p "permitir que usuarios modifiquen ficheros? (y)es (n)o: " writeable
echo "#permitir que usuarios modifiquen ficheros" >> vsftpd.conf

if [ "$writeable" = "y" ]; then
    echo "write_enable=YES" >> vsftpd.conf
else
    echo "write_enable=YES" >> vsftpd.conf

fi
echo "#">> vsftd.conf


#acceso a usuario anonimo sin contrasena
read -p "acceso a usuario anonimo sin contrasena? (y)es (n)o: " anonlogpass
echo "#acceso a usuario anonimo sin contrasena" >> vsftpd.conf

if [ "$anonlogpass" = "y" ]; then
    echo "no_anon_password=YES" >> vsftpd.conf
else
    echo "no_anon_password=NO" >> vsftpd.conf

fi
echo "#" >> vsftd.conf


#permitir logearse con conexión no encriptada (sin ssh)
read -p "permitir logearse con conexión no encriptada (sin ssh)? (y)es (n)o: " nonsshlog 
echo "#permitir logearse con conexión no encriptada (sin ssh)" >> vsftpd.conf

if [ "$nonsshlog" = "y" ]; then
    echo "force_local_logins_ssl=NO" >> vsftpd.conf
else
    echo "force_local_logins_ssl=YES" >> vsftpd.conf

fi
echo "#" >> vsftd.conf


#permitir trafico de archivos no encriptado (sin ssh)
read -p "permitir trafico de archivos no encriptado (sin ssh)? (y)es (n)o: " nonsshdata 
echo "#permitir trafico de archivos no encriptado (sin ssh)" >> vsftpd.conf

if [ "$nonsshdata" = "y" ]; then
    echo "force_local_data_ssl=NO" >> vsftpd.conf
else
    echo "force_local_data_ssl=YES" >> vsftpd.conf

fi
echo "#" >> vsftd.conf


#limitar el tiempo de la sesion (segundos)
read -p "limitar el tiempo de la sesion (segundos)? (y)es (n)o: " limitsesion 
echo "#limitar el tiempo de la sesion (segundos)" >> vsftpd.conf

if [ "$limitsesion" = "y" ]; then
    read -p "Cuantos segundos: " segundos
    echo "idle_session_tiemout=$segundos" >> vsftpd.conf

else
    echo "" >> vsftpd.conf

fi
echo "#" >> vsftd.conf


#limitar tasa maxima de subida de datos (usuario local)
read -p "#limitar tasa maxima de subida de datos (usuario local)? (y)es (n)o: " limitdata
echo "#limitar tasa maxima de subida de datos (usuario local)" >> vsftpd.conf

if [ "$limitdata" = "y" ]; then
    read -p "Cuantos Bytes:" Bytes
    echo "local_max_rate=$Bytes" >> vsftpd.conf
else
    echo "" >> vsftpd.conf

fi
echo "#" >> vsftd.conf


#limitar tasa maxima de subida de datos (usuario anonimo)
read -p "#limitar tasa maxima de subida de datos (usuario anonimo)? (y)es (n)o: " anonlimitdata
echo "#limitar tasa maxima de subida de datos (usuario anonimo)" >> vsftpd.conf

if [ "$anonlimitdata" = "y" ]; then
    read -p "Cuantos Bytes:" anonbytes
    echo "anon_max_rate=$anonbytes" >> vsftpd.conf
else
    echo "" >> vsftpd.conf

fi
echo "#" >> vsftd.conf


#modo pasivo
read -p "Activar modo pasivo? (y)es (n)o: " modopasivo
echo "#modo pasivo" >> vsftpd.conf

if [ "$modopasivo" = "y" ]; then
    read -p "puerto minimo: " minport
    read -p "puerto maximo: " maxport

    echo "pasv_enable=YES" >> vsftpd.conf
    echo "pasv_min_port=$minport" >> vsftpd.conf
    echo "pasv_max_port=$maxport" >> vsftpd.conf
else
    echo "no se ha activado el modo pasivo"
fi


#
# read -p "? (y)es (n)o: " 
#echo "" >> vsftpd.conf
#
#if [ "$" = "y" ]; then
#    echo "" >> vsftpd.conf
#else
#    echo "" >> vsftpd.conf
#
#fi
# # CREAR USUARIO VIRTUAL #  #

#grupo de usuarios virtuales
read -p "Quieres crear un usuario virtual? (y)es (n)o: " crearusuariovirtual
if [ "$crearusuariovirtual" = "y" ]; then
    read -p "Nombre del grupo:" nombredelgrupo
    read -p "Nombre de usuario virtual:" nombreusuariovirtual
    groupadd $nombredelgrupo
    adduser $nombreusuariovirtual
    mkdir -p /home/$nombredelgrupo/$nombreusuariovirtual
    useradd -g $nombredelgrupo -d /home/$nombredelgrupo/$nombreusuariovirtual -s /bin/$nombredelgrupo $nombreusuariovirtual
    read -p "la instalacion ha finalizado"
else
    echo "no se ha creado un usuario virtual"
fi

