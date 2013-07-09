#!/bin/bash
# (C) 2013 Sergio Alonso <escuelaint@gmail.com>
# 
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 2 as published
# by the Free Software Foundation.
#
# Version 1
# 


echo "Configurador para Fluxbox, XFCE o cualquier Windows Manager que no implemente control panel, tal que controle segundas pantallas y teclados"
echo "Escenario: notebook a 1360x768, con monitor y teclado extra"

while [ "$A" != "q" ]
do
  echo "t) - Teclado"
  echo "p) - Pantallas Dobles (Segundo Monitor) de Notebook"
  echo "r) - Quitar segunda pantalla, volver actual a 1360x768"
  echo "q) - Salir"
  echo .
  read A
  
  if [ "$A" = "r" ]; 
    then
    xrandr -s 1360x768
  fi

  if [ "$A" = "t" ]; 
    then
    echo "Escoja Teclado"
    echo "1) - EEUU con acentos"
    echo "2) - Español"
    echo "3) - Latinoamericano"
    read t
    case $t in
      [1] ) setxkbmap us -variant alt-intl 
            ;;
      [2] ) setxkbmap es 
            echo "Ok. Seteando ademas las inutiles teclas Super (en Flux y en LXDE no hacen nada) para servir como < y >"
            xmodmap -e "keycode 133 = 60"
            xmodmap -e "keycode 134 = 62"

            ;;
      [3] ) setxkbmap latam 
            ;;
      [*] ) echo "Eh?" 
            ;;
    esac
  fi

  if [ "$A" = "p" ]; 
    then
    echo "El otro monitor se encuentra a"
    echo "i) - Izquierda"
    echo "d) - Derecha"
    read m
    case $m in
      [i] ) LADO="--left-of"
            ;;
      [d] ) LADO="--right-of"
            ;;
      [*] ) echo "Perdón?"
            ;;
    esac

    xrandr
    echo .
    echo Lea arriba y responda:HDMI o a VGA?
    echo "h) - HDMI"
    echo "v) - VGA"
    read c
    case $c in
      [h] ) SALIDA="HDMI1"
            ;;
      [v] ) SALIDA="VGA1"
            ;;
      [*] ) echo "Lo que?"
            ;;
    esac

    echo "Resolución?"
    echo "1) - 1024x768 (atención: solo monitores crt viejos de 17 pulgadas soportan 85 hz"
    echo "2) - 1920x1080"
    echo "3) - 1360x768"
    read r
    case $r in
      [1] ) MODE="1024x768"
            CVT1="1024"
            CVT2="768"
            ;;
      [2] ) MODE="1920x1080"
            CVT1="1920"
            CVT2="1080"
            ;;
      [3] ) MODE="1360x768"
            CVT1="1360"
            CVT2="768"
            ;;
      [*] ) echo "Perdón?"
            ;;
    esac

    clear

    #######################################################
    echo "Paso 1, Oso agente especial"
    echo "cvt $CVT1 $CVT2"
    cvt $CVT1 $CVT2

    RESTOCVT=`cvt $CVT1 $CVT2`
    #Ejemplo - 1920x1080 59.96 Hz (CVT 2.07M9) hsync: 67.16 kHz; pclk: 173.00 MHz Modeline "1920x1080_60.00" 173.00 1920 2048 2248 2576 1080 1083 1088 1120 -hsync +vsync

    LIMPIO=`echo $RESTOCVT | cut -d ' ' -f 14-`
    #Ejemplo "1920x1080_60.00" 173.00 1920 2048 2248 2576 1080 1083 1088 1120 -hsync +vsync
    
    #echo 'Comando cvt limpio con cut: '$LIMPIO
    echo .    
    #######################################################
    echo "Paso 2, Añadiendo modo"
    echo "xrandr --newmode "$LIMPIO
    xrandr --newmode $LIMPIO

    #######################################################
    echo .    
    echo "Paso 3, Añadiendo modo a la salida "$SALIDA
    LIMPIO2=`echo $RESTOCVT | cut -d ' ' -f 14`
    echo "xrandr --addmode $SALIDA $LIMPIO2"
    xrandr --addmode $SALIDA $LIMPIO2

    #######################################################
    echo .    
    echo Paso 4, Lanzando xrandr final
    echo "xrandr --output LVDS1 --mode 1360x768 --rotate normal --output $SALIDA --mode $MODE $LADO LVDS1"
          xrandr --output LVDS1 --mode 1360x768 --rotate normal --output $SALIDA --mode $MODE $LADO LVDS1
    echo .
    echo Instrucción terminada
    echo .
 
  fi

done

#cvt 1920 1080
#xrandr --newmode "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
#xrandr --addmode VGA1 1920x1080_60.00

#xrandr --output LVDS1 --mode 1360x768 --output VGA1 --mode 1920x1080_60.00 --right-of LVDS1
#cvt 1920 1080
#xrandr --newmode "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
#xrandr --addmode VGA1 1920x1080_60.00
#xrandr --output VGA1 --mode 1920x1080_60.00

#xrandr --output LVDS1 --mode 1360x768 --pos 1920x312 --rotate normal --output VGA1 --mode 1024x768 --right-of LVDS1
