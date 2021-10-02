# Version de R: 4.1.1
# Fecha: 2/10/2021

rm(list = ls())
require(pacman)
p_load(tidyverse,rio,skimr)


# PUNTO 2

#Importamos la base de datos de cultivos de la carpeta input
base_cultivos = import("task_1/data/input/cultivos.xlsx")

#Ahora vamos a organizar y limpiar labase de datos. así que vamos a mirarla a ver que encontramos para mejorar
View(base_cultivos)

# Primero vemos que los nombres de las columnas se encuntran en la fila 4 así que las vamos a renombrar
colnames(base_cultivos) = base_cultivos[4,] %>% tolower()

#Vamos a quitar la informacion que no es relevante para nosotros. Teniendo en cuenta que lo que queremos al final es tener los datos de los municipios que en el algun momento han tenido cultivos de coca

#Vamos a estabalecer como numérica la variable del codigo municipal
base_cultivos$codmpio = as.numeric(base_cultivos$codmpio)

#Ahora borramos datos de esta variable que no tienen informacion porque no nos son relevantes
base_cultivos = base_cultivos %>% drop_na(codmpio)

View(base_cultivos)
#Nos quedaron todos los municipios que alguna ves tuvieron cultivos (información relevante)

#Creamos un vector con los años para poder volverlos todos numericos, porque para el pivot los vamos a necesitar de est forma 
years = 1999:2007 %>% as.character()
for(var in years){base_cultivos[,var] = as.numeric(base_cultivos[,var])}

#Hacemos el pivot
base_cultivos_pivot = base_cultivos %>% pivot_longer(!coddepto:municipio,names_to="year",values_to = "hectareas_cultivadas" )

View(base_cultivos_pivot)