from pandas import DataFrame, read_csv
import matplotlib.pyplot as plt
import pandas as pd 
import os

#crear nueva carpeta
if not os.path.exists('DataSets/'):
    os.makedirs('DataSets/')

#leer listadoPromedios
file = r'ListadoPromedios.xlsx'
df = pd.read_excel(file,encoding = "ISO-8859-1")

for index, row in df.iterrows():
    #leer archivo de notas de cada estudiante
    file = r'Notas/'+str(row['ID'])+'.csv'
    try:
        df2 = pd.read_csv(file,encoding = "ISO-8859-1")
    except FileNotFoundError:
        print("El archivo "+str(row['ID'])+".csv , No existe")
        continue

    df2['ID'] = row['ID']
    
    mergedDf = df.merge(df2)
    if not os.path.exists('DataSets/'):
        os.makedirs('DataSets/')
    mergedDf.to_csv('DataSets/'+str(row['ID'])+'.csv')


