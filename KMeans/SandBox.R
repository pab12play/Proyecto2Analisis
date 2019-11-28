#install.packages("readxl")
library("readxl")

#install.packages("factoextra")
library("factoextra")

#install.packages("gridExtra")
library("gridExtra")

#install.packages("ggplot2")
library(ggplot2)

setwd("C:/Users/Abraham/Desktop/Proyecto2Analisis") #comentar y agregar sus rutas
setwd("D:/Documents/Universidad/Octavo ciclo/ANÁLISIS DE DATOS/Proyecto2/Proyecto2Analisis")

# xlsx files
my_data <- read_excel("ProjectData/ListadoPromedios.xlsx")
set.seed(23544727)

#Plot de promedio simple por anio
pdf("KMeans/Plots/PromedioSimplePorAnio.pdf", width=22, height=12)
ggplot() + geom_point(aes(x = my_data$año, y =  (my_data$Promedio_Simple_Acumulado)), data = my_data, alpha = 0.5) + ggtitle('Conjunto de Datos') + labs(colour = "Cylinders") + labs(x = "Anio") + labs(y = "Promedio Ponderado")
dev.off()

#Plot de promedio ponderado por anio
pdf("KMeans/Plots/PromedioPondPorAnio.pdf", width=22, height=12)
ggplot() + geom_point(aes(x = my_data$año, y =  (my_data$Promedio_Ponderado_Acumulado)), data = my_data, alpha = 0.5) + ggtitle('Conjunto de Datos')  + labs(colour = "Cylinders") + labs(x = "Anio") + labs(y = "Promedio Ponderado")
dev.off()

#Box diagram de promedio ponderado por anio
pdf("KMeans/Plots/PromedioPondPorAnioBox.pdf", width=20, height=12)
ggplot() + geom_boxplot(aes(x = my_data$año, y =  (my_data$Promedio_Ponderado_Acumulado)), data = my_data, alpha = 0.5) + ggtitle('Conjunto de Datos')  + labs(colour = "Cylinders") + labs(x = "Anio") + labs(y = "Promedio Ponderado")
dev.off()

#Promedio simple x numero de cursos 
PromedioSimple = my_data[,c("prom_simp_x_ciclo", "cursos_acumulados")]
row.names(PromedioSimple) = my_data$ID
nclustersPromSimp = fviz_nbclust(PromedioSimple, kmeans, method = "wss") + geom_vline(xintercept = 3 ,linetype = 2) + ggtitle("N?mero ?ptimo de clusters")
clustersPromSimp = kmeans(PromedioSimple, 3, nstart = 20)
graficakPromSimp = fviz_cluster(clustersPromSimp, data = PromedioSimple) + ggtitle("Promedio Simple x Numero de cursos") + labs(x = "Promedio simple", y = "Total cursos")
save(PromedioSimple, file = "KMeans/Data/PromedioSimple.RData")
pdf("KMeans/Plots/PromedioSimple.pdf", width=30, height=50)
grid.arrange(graficakPromSimp, nclustersPromSimp, nrow = 2)
dev.off()


PromedioPonderado = my_data[, c("Promedio_Ponderado_Acumulado", "cursos_acumulados")]
row.names(PromedioPonderado) = my_data$ID
nclustersPromPond = fviz_nbclust(PromedioPonderado, kmeans, method = "wss") + geom_vline(xintercept = 3, linetype = 2) + ggtitle("N?mero ?ptimo de clusters") 
clustersPromPond = kmeans(PromedioPonderado, 3, nstart = 100)
graficakPromPond = fviz_cluster(clustersPromPond, data = PromedioPonderado) + ggtitle("Promedio acomulado x N?meroo de cursos") +  labs(x = "Promedio ponderado", y = "Total cursos")
save(PromedioPonderado, file = "KMeans/Data/PromedioPonderado.RData")
pdf("KMeans/Plots/PromedioPond.pdf", width=30, height=50)
grid.arrange(graficakPromPond, nclustersPromPond, nrow = 2)
dev.off()

PromedioAno = my_data[, c("año", "prom_simp_x_ciclo")]
PromedioAno$año = as.numeric(as.character(PromedioAno$año))
row.names(PromedioAno) = my_data$ID
nClustersPromAno = fviz_nbclust(PromedioAno, kmeans, method = "wss") + geom_vline(xintercept = 3, linetype = 2) + ggtitle("N?mero ?ptimo de clusters")
clustersPromAno = kmeans(PromedioAno, 3, nstart = 30)
graficakPromAno = fviz_cluster(clustersPromAno, data = PromedioAno) + ggtitle("Promedio acomulado x A?o (No relevante)") +  labs(x = "Promedio simple", y = "Anio")
save(PromedioAno, file = "KMeans/Data/PromedioAnio.RData")
pdf("KMeans/Plots/PromedioAni.pdf", width=30, height=50)
grid.arrange(graficakPromAno, nClustersPromAno, nrow = 2)
dev.off()

promedioCursoCFI = read.csv("ProjectData/promedioCursoCFI.csv", header = TRUE)
promedioCursoCFI = promedioCursoCFI[, c("Cursos", "Promedio")]
row.names(promedioCursoCFI) = promedioCursoCFI$ID
nClustersPromCFI = fviz_nbclust(promedioCursoCFI, kmeans, method = "wss") + geom_vline(xintercept = 7, linetype = 2) + ggtitle("Numero optimo de clusters")
clustersPromCFI = kmeans(promedioCursoCFI, 7, nstart = 30)
  graficakPromCFI = fviz_cluster(clustersPromCFI, data = promedioCursoCFI) + ggtitle("Promedio cursos CFI x Numero de cursos") +  labs(x = "Cursos", y = "Promedio Cursos CFI")
save(promedioCursoCFI, file = "KMeans/Data/promedioCursoCFI.RData")
pdf("KMeans/Plots/PromedioCFI.pdf", width=30, height=50)
grid.arrange(graficakPromCFI, nClustersPromCFI, nrow = 2)
dev.off()

#-----------------

promedioCursoEspecifico = read.csv("ProjectData/promedioCursoEspecifico.csv", header = TRUE)
promedioCursoEspecifico = promedioCursoEspecifico[, c("Cursos", "Promedio")]
row.names(promedioCursoEspecifico) = promedioCursoEspecifico$ID
nClustersPromEspecifico = fviz_nbclust(promedioCursoEspecifico, kmeans, method = "wss") + geom_vline(xintercept = 3, linetype = 2) + ggtitle("Numero optimo de clusters")
clustersPromEspecifico = kmeans(promedioCursoEspecifico, 3, nstart = 30)
graficakPromEspecifico = fviz_cluster(clustersPromEspecifico, data = promedioCursoEspecifico) + ggtitle("Promedio cursos area especifica x Numero de cursos") +  labs(x = "Cursos", y = "Promedio Cursos especificos")
save(promedioCursoEspecifico, file = "KMeans/Data/promedioCursoEspecifico.RData")
pdf("KMeans/Plots/PromedioEspecifico.pdf", width=30, height=50)
grid.arrange(graficakPromEspecifico, nClustersPromEspecifico, nrow = 2)
dev.off()

promedioCursoNumerico = read.csv("ProjectData/promedioCursoNumerico.csv", header = TRUE)
promedioCursoNumerico = promedioCursoNumerico[, c("Cursos", "Promedio")]
row.names(promedioCursoNumerico) = promedioCursoNumerico$ID
nClustersPromNumerico = fviz_nbclust(promedioCursoNumerico, kmeans, method = "wss") + geom_vline(xintercept = 4, linetype = 2) + ggtitle("Numero optimo de clusters")
clustersPromNumerico = kmeans(promedioCursoNumerico, 4, nstart = 30)
graficakPromNumerico = fviz_cluster(clustersPromNumerico, data = promedioCursoNumerico) + ggtitle("Promedio cursos area Basicos x Numero de cursos") +  labs(x = "Cursos", y = "Promedio Cursos Basicos")
save(promedioCursoNumerico, file = "KMeans/Data/promedioCursoNumerico.RData")
pdf("KMeans/Plots/PromedioNumerico.pdf", width=30, height=50)
grid.arrange(graficakPromNumerico, nClustersPromNumerico, nrow = 2)
dev.off()

promedioCursoProfecionales = read.csv("ProjectData/promedioCursosProfecionales.csv", header = TRUE)
promedioCursoProfecionales = promedioCursoProfecionales[, c("Cursos", "Promedio")]
row.names(promedioCursoProfecionales) = promedioCursoProfecionales$ID
nClustersPromProfecionales = fviz_nbclust(promedioCursoProfecionales, kmeans, method = "wss") + geom_vline(xintercept = 4, linetype = 2) + ggtitle("Numero optimo de clusters")
clustersPromProfecionales = kmeans(promedioCursoProfecionales, 5, nstart = 30)
graficakPromProfecionales = fviz_cluster(clustersPromProfecionales, data = promedioCursoProfecionales) + ggtitle("Promedio cursos area Profesional x Numero de cursos") +  labs(x = "Cursos", y = "Promedio Cursos profesionales")
save(promedioCursoProfecionales, file = "KMeans/Data/promedioCursoProfecionales.RData")
pdf("KMeans/Plots/PromedioProfecionales.pdf", width=30, height=50)
grid.arrange(graficakPromProfecionales, nClustersPromCFI, nrow = 2)
dev.off()
















