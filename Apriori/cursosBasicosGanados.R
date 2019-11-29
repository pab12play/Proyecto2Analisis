#install.packages("readxl")
library("readxl")

#install.packages("factoextra")
library("factoextra")

#install.packages("gridExtra")
library("gridExtra")

#install.packages("ggplot2")
library(ggplot2)

#install.packages('Matrix')
library('Matrix')

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
transacciones <- read.transactions("ProjectData/DataSets/cursosPerdidos.csv", rm.duplicates = FALSE,format="single",sep=",", header = TRUE,cols=c('Nombre_Curso', 'Nombre_Ciclo'))
summary(transacciones)



# lista de todos los cursos de los que se tiene registro que al menos un usuario ha reprobado
colnames(transacciones)
rownames(transacciones)

transaccionesImage <- image(transacciones, colors=rainbow(5))

#frecuencia de las transacciones
frecuencia_items <- itemFrequency(x = transacciones, type = "absolute")
frecuencia_items = sort(frecuencia_items, decreasing = TRUE)
frecuencia_items <- as.data.frame(frecuencia_items)

xx <- rownames(frecuencia_items)
yy <- frecuencia_items$frecuencia_items

#grafica de la frecuencia
frecuenciaImage <-  ggplot(data = frecuencia_items, aes(x = reorder(xx, -yy),y = yy))   + 
                    geom_bar( stat="identity" ) + 
                    geom_hline(yintercept = 0, alpha = 1, color="black", size=0.5) +
                    geom_vline(xintercept = 0, alpha = 1, color="black", size=0.5) +
                    labs(title = "Distribución de cursos perdidos por ciclo", y = 'Estudiantes') +
                    theme(axis.text.x = element_text(angle = 90))
  
#distribucion de cursos perdidos
frecuencia_items <- itemFrequency(x = transacciones, type = "absolute")
distribucion <- quantile(frecuencia_items, probs = seq(0,1,0.10))
distribucion <- as.data.frame(distribucion)
distribucionImage <- ggplot(distribucion) + aes(x =  seq(0,1,0.1), y = distribucion) +
                      geom_line( size = 0.5, color='coral' ) + geom_col( width = 0.05, alpha = 0.3) + 
                      scale_y_continuous(breaks=round(distribucion), labels = round(distribucion)) +
                      geom_hline(yintercept = 0, alpha = 1, color="black", size=0.5) +
                      geom_vline(xintercept = 0, alpha = 1, color="black", size=0.5) +
                      labs(title = "Proporción de cursos perdidos",
                           x = "Proporción", y = 'Cursos Perdidos')

#carguemos algunas reglas
soporte <- 0.1
confianza <- 0.95

reglas <- apriori(transacciones,parameter=list(sup=soporte,conf=confianza,target="rules", maxlen=3))

reglas_ordenadas_confidence = sort(x=reglas, decreasing = TRUE, by = "confidence")
reglas_ordenadas_lift = sort(x=reglas, decreasing = TRUE, by = "lift")
#plot (reglas, method = "two-key plot")

inspect(reglas_ordenadas_lift[0:10])


#guardamos los datos leidos
save(transacciones, file = "Apriori/Data/cursosPerdidosCiclos.RData")

#guardamos las reglas calculadas
save(reglas, file = paste0("Apriori/Data/cursosPerdidosCiclosReglas_Soporte-",(soporte),"_Confianza-",(confianza),".RData"))

#guardar imagenes
jpeg("Apriori/Plots/cursosPerdidosCiclosTransacciones.jpg", width=800, height=800)
transaccionesImage
dev.off()

jpeg("Apriori/Plots/cursosPerdidosCiclosFrecuencias.jpg", width=900, height=600)
frecuenciaImage
dev.off()

jpeg("Apriori/Plots/cursosPerdidosCiclosDistribuciones.jpg", width=800, height=800)
distribucionImage
dev.off()

