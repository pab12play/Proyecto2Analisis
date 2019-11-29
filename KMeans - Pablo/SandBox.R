#install.packages("readxl")
library("readxl")
library(readr)

#install.packages("factoextra")
library("factoextra")

#install.packages("gridExtra")
library("gridExtra")

#install.packages("ggplot2")
library(ggplot2)
library(tidyverse)

#setwd("C:/Users/Abraham/Desktop/Proyecto2Analisis") #comentar y agregar sus rutas
#setwd("D:/Documents/Universidad/Octavo ciclo/ANÁLISIS DE DATOS/Proyecto2/Proyecto2Analisis")
setwd("/home/akabane/Desktop/Proyecto2Analisis")

# xlsx files
my_data <- read_excel("ProjectData/ListadoPromedios.xlsx")
dataCompletos <- read_csv("ProjectData/DataSets/cursosCompletos.csv")
dataCursosAprobados <- read_csv("ProjectData/DataSets/ListadoPromedios.csv")
dataCursosPerdidos <- read_csv("ProjectData//DataSets/conteoCursosPerdidos.csv")
set.seed(23544727)


#CursosAprobados = dataCursosAprobados[c(1,6:8,11,18,20,22:23,26:27,29)]
CursosAprobados = dataCursosAprobados[c("prom_simp_x_ciclo","cursos_x_ciclo","cursos_acumulados")]
CursosAprobadosScale <- scale(CursosAprobados)
nClustersCursosAprobados = fviz_nbclust(CursosAprobadosScale, kmeans, method = "wss") + geom_vline(xintercept = 4, linetype = 2) + ggtitle("Numero optimo de clusters")
clustersCursosAprobados = kmeans(CursosAprobadosScale, 4, nstart = 30)
graficakCursosAprobados = fviz_cluster(clustersCursosAprobados, data = CursosAprobadosScale) + ggtitle("Similitud en cursos aprobados")
aggregate(CursosAprobados,by=list(clustersCursosAprobados$cluster),mean)

CursosPerdidos = dataCursosPerdidos[c("prom_simp_x_ciclo","cursos_x_ciclo","cursos_acumulados")]
CursosPerdidosScale <- scale(CursosPerdidos)
nClustersCursosPerdidos = fviz_nbclust(CursosPerdidosScale, kmeans, method = "wss") + geom_vline(xintercept = 4, linetype = 2) + ggtitle("Numero optimo de clusters")
clustersCursosPerdidos = kmeans(CursosPerdidosScale, 3, nstart = 30)
graficakCursosPerdidos = fviz_cluster(clustersCursosPerdidos, data = CursosPerdidosScale) + ggtitle("Similitud en cursos Perdidos")
aggregate(CursosPerdidos,by=list(clustersCursosPerdidos$cluster),mean)

porTipoExamen = dataCompletos[c("No_tip_examen","Nota")]
porTipoExamenScale <- scale(porTipoExamen)
nClustersTipoExamen = fviz_nbclust(porTipoExamenScale, kmeans, method = "wss") + geom_vline(xintercept = 3, linetype = 2) + ggtitle("Numero optimo de clusters")
clustersTipoExamen = kmeans(porTipoExamenScale, 3, nstart = 30)
graficakTipoExamen = fviz_cluster(clustersTipoExamen, data = porTipoExamenScale) + ggtitle("Similitud por Tipo de Examen")
aggregate(porTipoExamen,by=list(clustersTipoExamen$cluster),mean)




