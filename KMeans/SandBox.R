#install.packages("readxl")
library("readxl")

#install.packages("factoextra")
library("factoextra")

#install.packages("gridExtra")
library("gridExtra")

#install.packages("ggplot2")
library(ggplot2)

setwd("C:/Users/Abraham/Desktop/Proyecto2Analisis") #comentar y agregar sus rutas

# xlsx files
my_data <- read_excel("ProjectData/ListadoPromedios.xlsx")
set.seed(23544727)

#Plot de promedio simple por anio
ggplot() + geom_point(aes(x = my_data$año, y =  (my_data$Promedio_Simple_Acumulado)), data = my_data, alpha = 0.5) + ggtitle('Conjunto de Datos')

#Plot de promedio ponderado por anio
ggplot() + geom_point(aes(x = my_data$año, y =  (my_data$Promedio_Ponderado_Acumulado)), data = my_data, alpha = 0.5) + ggtitle('Conjunto de Datos')

#Box diagram de promedio ponderado por anio
ggplot() + geom_boxplot(aes(x = my_data$año, y =  (my_data$Promedio_Ponderado_Acumulado)), data = my_data, alpha = 0.5) + ggtitle('Conjunto de Datos')


#Promedio simple x numero de cursos 
PromedioSimple = my_data[,c("prom_simp_x_ciclo", "cursos_acumulados")]
row.names(PromedioSimple) = my_data$ID
nclustersPromSimp = fviz_nbclust(PromedioSimple, kmeans, method = "wss") + geom_vline(xintercept = 3 ,linetype = 2) + ggtitle("Número óptimo de clusters")
clustersPromSimp = kmeans(PromedioSimple, 3, nstart = 20)
graficakPromSimp = fviz_cluster(clustersPromSimp, data = PromedioSimple) + ggtitle("Promedio Simple x Numero de cursos")
save(PromedioSimple, file = "KMeans/Data/PromedioSimple.RData")
pdf("KMeans/Plots/PromedioSimple.pdf", width=30, height=50)
grid.arrange(graficakPromSimp, nclustersPromSimp, nrow = 2)
dev.off()


PromedioPonderado = my_data[, c("Promedio_Ponderado_Acumulado", "cursos_acumulados")]
row.names(PromedioPonderado) = my_data$ID
nclustersPromPond = fviz_nbclust(PromedioPonderado, kmeans, method = "wss") + geom_vline(xintercept = 4, linetype = 2) + ggtitle("Número óptimo de clusters")
clustersPromPond = kmeans(PromedioPonderado, 4, nstart = 100)
graficakPromPond = fviz_cluster(clustersPromPond, data = PromedioPonderado) + ggtitle("Promedio acomulado x Númeroo de cursos")
pdf("KMeans/Plots/PromedioPond.pdf", width=30, height=50)
grid.arrange(graficakPromPond, nclustersPromPond, nrow = 2)
dev.off()

PromedioAno = my_data[, c("año", "prom_simp_x_ciclo")]
PromedioAno$año = as.numeric(as.character(PromedioAno$año))
row.names(PromedioAno) = my_data$ID
nClustersPromAno = fviz_nbclust(PromedioAno, kmeans, method = "wss") + geom_vline(xintercept = 3, linetype = 2) + ggtitle("Número óptimo de clusters")
clustersPromAno = kmeans(PromedioAno, 3, nstart = 30)
graficakPromAno = fviz_cluster(clustersPromAno, data = PromedioAno) + ggtitle("Promedio acomulado x Año (No relevante)")
pdf("KMeans/Plots/PromedioAni.pdf", width=30, height=50)
grid.arrange(graficakPromAno, nClustersPromAno, nrow = 2)
dev.off()

# Estudiante 119
my_data <- read.csv("ProjectData/DataSets/119.csv")
NotasNumericas = my_data[]















