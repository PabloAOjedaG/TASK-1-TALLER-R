# Tarea (Task) 1. Taller R de Estadistica y Programacion.
# Taller elaborado por:
# Pablo Andres Ojeda Gomez, con codigo 202012899;
# Diana Lucia Sanchez Ruiz, con codigo 202013592;
# Gabriel Perdomo Olmos, con codigo 202013093.

# Configuraciones iniciales
rm(list = ls())
if(!require(pacman)) install.packages("pacman") ; require(pacman)
p_load(rio,tidyverse,png,grid)
Sys.setlocale("LC_CTYPE", "en_US.UTF-8")

#--------------------------
#-------- PUNTO 1 ---------
#--------------------------

# ESCRIBIR AQUI, RECORDAD NO PONER TILDES O CARACTERES DEL ESPAÑOL.

#--------------------------
#-------- PUNTO 2 ---------
#--------------------------

# ESCRIBIR AQUI, RECORDAD NO PONER TILDES O CARACTERES DEL ESPAÑOL.

#--------------------------
#-------- PUNTO 3 ---------
#--------------------------

# PARTE A

carac = import(file = "task_1/data/input/2019/Cabecera - Caracteristicas generales (Personas).rds")
ocupa = import(file = "task_1/data/input/2019/Cabecera - Ocupados.rds")
desoc = import(file = "task_1/data/input/2019/Cabecera - Desocupados.rds")
inact = import(file = "task_1/data/input/2019/Cabecera - Inactivos.rds")
fztra = import(file = "task_1/data/input/2019/Cabecera - Fuerza de trabajo.rds")




