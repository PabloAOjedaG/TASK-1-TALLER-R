# Tarea (Task) 1. Taller R de Estadistica y Programacion.
# Taller elaborado por:
# Pablo Andres Ojeda Gomez, con codigo 202012899;
# Diana Lucia Sanchez Ruiz, con codigo 202013592;
# Gabriel Perdomo Olmos, con codigo 202013093.

# Configuraciones iniciales
rm(list = ls())
if(!require(pacman)) install.packages("pacman") ; require(pacman)
p_load(rio,tidyverse,skimr, qpcR)
Sys.setlocale("LC_CTYPE", "en_US.UTF-8")

#--------------------------
#-------- PUNTO 1 ---------
#--------------------------

vector1 <- c(1:100) "Creamos el vector con cien numeros de 1 a 100"
vector2 <- c(1:99)  "creamos la base para el vector de los numeros impares"
(ii <- vector2 %% 2) "queremos seleccionar los elementos impares en el vector2, se puede hacer como se muestra"
ii <- as.logical(ii)  "Convertimos ii a lógico para mas adelante utilizarlo para indexar al vector 2"
vector3 <- vector2[ii] "asi conseguimos un vector con solo los numeros impares de 1 al 99"
vector_combinado <- c(vector3,vector1) "se combinan ambos vectopres para juntar los valores numericos"
vector_mezclado <- (vector_combinado[-1:-50]) "se seleccionan los datos pares para el vector mezclado para tener numeros pares e impares"

#--------------------------
#-------- PUNTO 2 ---------
#--------------------------

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

#Nos quedaron todos los municipios que alguna ves tuvieron cultivos (información relevante)

#Creamos un vector con los años para poder volverlos todos numericos, porque para el pivot los vamos a necesitar de est forma 
years = 1999:2007 %>% as.character()
for(var in years){base_cultivos[,var] = as.numeric(base_cultivos[,var])}

#Hacemos el pivot
base_cultivos_pivot = base_cultivos %>% pivot_longer(!coddepto:municipio,names_to="year",values_to = "hectareas_cultivadas" )

View(base_cultivos_pivot)

#--------------------------
#-------- PUNTO 3 ---------
#--------------------------

# PARTE A

carac = import(file = "task_1/data/input/2019/Cabecera - Caracteristicas generales (Personas).rds") %>% mutate(ocupado=NA) %>% mutate(desocupado=NA)  %>% mutate(inactivo=NA) %>% mutate(fuerza=NA)
ocupa = import(file = "task_1/data/input/2019/Cabecera - Ocupados.rds") %>% mutate(ocupado=1)
ocupado <- c("ocupado")
df1 = ocupa[ocupado]
# comando extrapolado desde la página:
browseURL(url = "https://www.listendata.com/2015/06/r-keep-drop-columns-from-data-frame.html")
browseURL(url = "https://stackoverflow.com/questions/7531868/how-to-rename-a-single-column-in-a-data-frame")

desoc = import(file = "task_1/data/input/2019/Cabecera - Desocupados.rds") %>% mutate(desocupado=1)
desocupado <- c("desocupado")
df2 = desoc[desocupado]
# comando extrapolado desde la página:
browseURL(url = "https://www.listendata.com/2015/06/r-keep-drop-columns-from-data-frame.html")
browseURL(url = "https://stackoverflow.com/questions/7531868/how-to-rename-a-single-column-in-a-data-frame")

inact = import(file = "task_1/data/input/2019/Cabecera - Inactivos.rds") %>% mutate(inactivo=1)
inactivo <- c("inactivo")
df3 = inact[inactivo]
# comando extrapolado desde la página:
browseURL(url = "https://www.listendata.com/2015/06/r-keep-drop-columns-from-data-frame.html")
browseURL(url = "https://stackoverflow.com/questions/7531868/how-to-rename-a-single-column-in-a-data-frame")

fztra = import(file = "task_1/data/input/2019/Cabecera - Fuerza de trabajo.rds") %>% mutate(fuerza=1)
fuerza <- c("fuerza")
df4 = fztra[fuerza]
# comando extrapolado desde la página:
browseURL(url = "https://www.listendata.com/2015/06/r-keep-drop-columns-from-data-frame.html")
browseURL(url = "https://stackoverflow.com/questions/7531868/how-to-rename-a-single-column-in-a-data-frame")


geral = left_join(carac, ocupa, c("secuencia_p", "orden", "directorio")) %>%
  left_join(., desoc, c("secuencia_p", "orden", "directorio")) %>%
  left_join(., inact, c("secuencia_p", "orden", "directorio")) %>%
  left_join(., fztra, c("secuencia_p", "orden", "directorio"))

vari <- c("secuencia_p", "orden", "directorio","P6020","P6040","P6920","P6050","DPTO","ESC", "ocupado.x", "desocupado.x", "inactivo.x", "fuerza.x")
final = geral[vari]
# comando extrapolado desde la página:
browseURL(url = "https://www.listendata.com/2015/06/r-keep-drop-columns-from-data-frame.html")

final <- qpcR:::cbind.na(df1, final)
colnames(final)[colnames(final) == "ocupado.x"] <- "ocupado"

final <- qpcR:::cbind.na(df2, final)
colnames(final)[colnames(final) == "desocupado.x"] <- "desocupado"

final <- qpcR:::cbind.na(df3, final)
colnames(final)[colnames(final) == "inactivo.x"] <- "inactivo"

final <- qpcR:::cbind.na(df4, final)
colnames(final)[colnames(final) == "fuerza.x"] <- "fuerza"

# comando extrapolado desde la página:
browseURL(url = "https://stackoverflow.com/questions/3699405/how-to-cbind-or-rbind-different-lengths-vectors-without-repeating-the-elements-o")





