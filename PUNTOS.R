# Tarea (Task) 1. Taller R de Estadistica y Programacion.
# Taller elaborado por:
# Pablo Andres Ojeda Gomez, con codigo 202012899;
# Diana Lucia Sanchez Ruiz, con codigo 202013592;
# Gabriel Perdomo Olmos, con codigo 202013093.
# Version de R 4.1.1

# Configuraciones iniciales
rm(list = ls())
if(!require(pacman)) install.packages("pacman") ; require(pacman)
p_load(rio,tidyverse,skimr, qpcR)
Sys.setlocale("LC_CTYPE", "en_US.UTF-8")

#--------------------------
#-------- PUNTO 1 ---------
#--------------------------

vector1 <- c(1:100) #"Creamos el vector con cien numeros de 1 a 100"
vector2 <- c(1:99)  #"creamos la base para el vector de los numeros impares"
(ii <- vector2 %% 2) #"queremos seleccionar los elementos impares en el vector2, se puede hacer como se muestra"
ii <- as.logical(ii)  #"Convertimos ii a lógico para mas adelante utilizarlo para indexar al vector 2"
vector3 <- vector2[ii] #"asi conseguimos un vector con solo los numeros impares de 1 al 99"
vector_combinado <- c(vector3,vector1) #"se combinan ambos vectopres para juntar los valores numericos"
vector_mezclado <- (vector_combinado[-1:-50]) #"se seleccionan los datos pares para el vector mezclado para tener numeros pares e impares"

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

# 3.1 Importar

#Importamos todas las bases de datos
carac = import(file = "task_1/data/input/2019/Cabecera - Caracteristicas generales (Personas).rds") %>% mutate(ocupado=NA) %>% mutate(desocupado=NA)  %>% mutate(inactivo=NA) %>% mutate(fuerza=NA)
ocupa = import(file = "task_1/data/input/2019/Cabecera - Ocupados.rds") %>% mutate(ocupado=1)
desoc = import(file = "task_1/data/input/2019/Cabecera - Desocupados.rds") %>% mutate(desocupado=1)
inact = import(file = "task_1/data/input/2019/Cabecera - Inactivos.rds") %>% mutate(inactivo=1)
fztra = import(file = "task_1/data/input/2019/Cabecera - Fuerza de trabajo.rds") %>% mutate(fuerza=1)


#Unimos todas las bases de datos haciendo el joint
geih = left_join(carac,ocupa,c("secuencia_p","orden","directorio")) %>%
  left_join(.,desoc,c("secuencia_p","orden","directorio")) %>%
  left_join(.,fztra,c("secuencia_p","orden","directorio")) %>%
  left_join(.,inact,c("secuencia_p","orden","directorio")) 

#Dejamos en la base final las columnas relevantes
geih_final = geih[, c("secuencia_p","orden","directorio", "P6020", "P6040", "P6920", "INGLABO", "DPTO", "ESC", "P6050", "Oci", "dsi", "Ft", "ini")]

skim(geih_final)

# 3.2 Descriptivas

#Tabla ingresos por quartiles
geih_final %>% summarise(quartiles = quantile(INGLABO, na.rm = TRUE))

#Tabla de ingresos promedio (ocupados) por sexo 
geih_final %>%  group_by(P6020, Oci)  %>% summarise(ingresos_promedio = mean(INGLABO, na.rm = TRUE))

#Tabla de desocupados por género
geih_final %>% group_by(P6020) %>% summarise(total = table(dsi))
#Tabla de desocupados por departamento
geih_final %>% group_by(DPTO) %>% summarise(total = table(dsi))
#Tabla de desocupados por edad
geih_final %>% group_by(P6040) %>% summarise(total = table(dsi))

#Tabla total de ocupados cotizando a pension
geih_final %>% group_by(Oci) %>% summarise(total = table(P6920))

#Gráfica histograma de distribucion de ingreso
hist_ing = hist(geih_final$INGLABO)
ggsave(hist=hist_ing, file = "task_1/views/hist_ing.jpeg")

#Gráfica histograma de distribucion de edad
hist_edad = ggplot(geih_final) + geom_histogram(aes(P6040))
ggsave(plot=hist_edad, file = "task_1/views/hist_edad.jpeg")

#Gráfica densidad del ingreso laboral
graph_1 = ggplot(geih_final) + geom_density(aes(INGLABO))
ggsave(plot=graph_1, file = "task_1/views/graph_1.jpeg")



