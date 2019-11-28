#install.packages("readxl")
library("readxl")

#install.packages("factoextra")
library("factoextra")

#install.packages("gridExtra")
library("gridExtra")

#install.packages("ggplot2")
library(ggplot2)

#install.packages('arules')
library('arules')

#install.packages('grid')
library('grid')

#install.packages('arulesViz')
library('arulesViz')


setwd("C:/Users/Abraham/Desktop/Proyecto2Analisis") #comentar y agregar sus rutas

# leemos el CSV como transacciones
# estas transacciones se realizan en base a
# USUARIO y CURSOS 
transacciones <- read.transactions("ProjectData/DataSets/cursosPerdidos.csv", rm.duplicates = FALSE,format="single",sep=",", header = TRUE,cols=c('Nombre_Ciclo', 'Nombre_Curso'))
summary(transacciones)



# lista de todos los cursos de los que se tiene registro que al menos un usuario ha reprobado
colnames(transacciones)
rownames(transacciones)

transaccionesImage <- image(transacciones, colors=rainbow(5))

#frecuencia de las transacciones
frecuencia_items <- itemFrequency(x = transacciones, type = "absolute")
frecuencia_items = sort(frecuencia_items, decreasing = TRUE)

#grafica de la frecuencia
frecuenciaImage <-  ggplot() + aes(x = frecuencia_items) + 
                    geom_hline(yintercept = frecuencia_items, alpha = 0.3, color="coral", size=0.3) +
                    geom_histogram( binwidth = 0.5 ) + 
                    scale_y_continuous(breaks=round(frecuencia_items), labels = round(frecuencia_items)) +
                    geom_hline(yintercept = 0, alpha = 1, color="black", size=0.5) +
                    geom_vline(xintercept = 0, alpha = 1, color="black", size=0.5) +
                    labs(title = "Distribución de cursos perdidos por estudiante",
                         x = "Cantidad de Cursos Perdidos", y = 'Estudiantes')
  
#distribucion de cursos perdidos
distribucion <- quantile(frecuencia_items, probs = seq(0,1,0.10))
distribucion <- as.data.frame(distribucion)
distribucionImage <- ggplot(distribucion) + aes(x =  seq(0,1,0.1), y = distribucion) +
                      geom_line( size = 0.5, color='coral' ) + geom_col( width = 0.05, alpha = 0.3) + 
                      scale_y_continuous(breaks=round(distribucion), labels = round(distribucion)) +
                      geom_hline(yintercept = 0, alpha = 1, color="black", size=0.5) +
                      geom_vline(xintercept = 0, alpha = 1, color="black", size=0.5) +
                      labs(title = "Proporción de la cantidad de cursos perdidos",
                           x = "Proporción", y = 'Cursos Perdidos')

#carguemos algunas reglas
soporte <- 0.8
confianza <- 0.95

reglas <- apriori(transacciones,parameter=list(sup=soporte,conf=confianza,target="rules"))

reglas_ordenadas_confidence = sort(x=reglas, decreasing = TRUE, by = "confidence")
reglas_ordenadas_lift = sort(x=reglas, decreasing = TRUE, by = "lift")
#plot (reglas, method = "two-key plot")

inspect(reglas_ordenadas_lift[0:10])


#guardamos los datos leidos
save(transacciones, file = "Apriori/Data/cursosPerdidos.RData")

#guardamos las reglas calculadas
save(reglas, file = paste0("Apriori/Data/cursosPerdidosReglas_Soporte-",(soporte),"_Confianza-",(confianza),".RData"))

#guardar imagenes
jpeg("Apriori/Plots/Transacciones.jpg", width=800, height=800)
transaccionesImage
dev.off()

jpeg("Apriori/Plots/Frecuencias.jpg", width=900, height=600)
frecuenciaImage
dev.off()

jpeg("Apriori/Plots/Distribuciones.jpg", width=800, height=800)
distribucionImage
dev.off()

