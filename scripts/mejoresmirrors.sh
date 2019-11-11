#!/bin/sh
#
# Script preparado para hacer un testeo de los mirrors más rápidos, elaborando un nuevo
# archivo con los mejores. Con ésto evitamos también los servers caídos.
#
if ! [ $(id -u) = 0 ]; then
   echo "Necesito tener permisos de admin para que ésto funcione :("
   echo
   exit 1
fi
read -p "Ésto va a tardar un buen rato, ¿continúo? (s/N)? " answer
case ${answer:0:1} in
    s|S )
        echo "Vale, ¡vamos allá!"
	echo
	cp /etc/pacman.d/mirrorlist.pacnew /etc/pacman.d/mirrorlist.backup
	awk '/^## Country Name$/{f=1}f==0{next}/^$/{exit}{print substr($0, 2)}' /etc/pacman.d/mirrorlist
	sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist.backup
	rankmirrors -n 6 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist
	echo
	echo Dejándo los repositorios al día...
	echo
	pacman -Sy
	echo
	echo "¡Listo!, repositorios puestos al día con los servers mas rápidos :)"
	echo "Hasta la próxima puesta a punto."
	echo

    ;;
    * )
        echo "Mejor, procura hacerlo cuando tengas tiempo de sobra (+10 minutos)."
        echo
    ;;
esac
