#!/bin/bash
op=0

while [[ $op != 5 ]];
do
        echo "1. Lista usuario"
        echo "2. Crear usuario"
        echo "3. Borrar usuario"
        echo "4. Modificar password usuario"
        echo "5. Salir"
        read -p "Que quieres hacer? " op 
        case $op in
  1)
    echo "1. Lista usuario"
    ./listar.sh
    echo  ---------------------------
  ;;
  2)
    echo "2.Crear usuario"
    ./crear.sh
    echo ----------------------------
  ;;
  3)
    echo "3. Borrar usuario"
    ./borrar.sh
  ;;
  4)
    echo "4. Modificar password usuario"
    ./modificar.sh
  ;;
        esac
done
