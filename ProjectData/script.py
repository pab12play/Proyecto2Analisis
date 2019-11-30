from pandas import DataFrame, read_csv
import matplotlib.pyplot as plt
import pandas as pd 
import os

#crear nueva carpeta
if not os.path.exists('DataSets/'):
    os.makedirs('DataSets/')

#leer listadoPromedios
file = r'ListadoPromedios.xlsx'
df = pd.read_excel(file,encoding = "iso-8859-1")


df = df.drop(df.columns[0], axis=1) #elimina la columna vacia
df = df.rename(columns={"año" : 'anio'}) #renombra 

cursosNumericos = pd.DataFrame()
cursosNumericosGanados = pd.DataFrame()
cursosNumericosPerdidos = pd.DataFrame()
cursosEspecificos = pd.DataFrame()
cursosEspecificosGanados = pd.DataFrame()
cursosEspecificosPerdidos = pd.DataFrame()
cursosProfesionales = pd.DataFrame()
cursosProfesionalesGanados = pd.DataFrame()
cursosProfesionalesPerdidos = pd.DataFrame()
cursosCFI = pd.DataFrame()
cursosGanados = pd.DataFrame()
cursosPerdidos = pd.DataFrame()
cursosCompletos = pd.DataFrame()
conteoCursosPerdidos = pd.DataFrame()

for index1, row in df.iterrows():
    #leer archivo de notas de cada estudiante
    file = r'Notas/'+str(row['ID'])+'.csv'
    try:
        df2 = pd.read_csv(file,encoding = "iso-8859-1")
    except FileNotFoundError:
        print("El archivo "+str(row['ID'])+".csv , No existe")
        continue

    df2['ID'] = row['ID']
    copia = df2.copy()
    #frequencia = df2['Nota'].value_counts()
    #if("A" in frequencia.index.tolist()):
    #    print(frequencia["A"])

    mergedDf = df.merge(df2)
    mergedDf = mergedDf.drop(mergedDf[mergedDf.Nombre_Curso.str.contains('INGLES', na=False)].index) #ELIMINA INGLES
    mergedDf = mergedDf.dropna(subset=['Nota']) #ELIMINA NOTAS VACIAS
    mergedDf = mergedDf.drop(mergedDf[mergedDf.Nota.astype(str).str.contains('A', na=False)].index) #ELIMINA NOTAS INVALIDAD
    mergedDf = mergedDf.drop(mergedDf[mergedDf.Nota.astype(str).str.contains('E', na=False)].index) #ELIMINA NOTAS INVALIDAD
    mergedDf = mergedDf.drop(mergedDf[mergedDf.Nota.astype(str).str.contains('R', na=False)].index) #ELIMINA NOTAS INVALIDAD

    #cambiar nombre de columnas
    mergedDf.loc[mergedDf.Nombre_Ciclo.str.contains('Primer', na=False), 'Nombre_Ciclo'] = 'Primer Ciclo'
    mergedDf.loc[mergedDf.Nombre_Ciclo.str.contains('Segundo', na=False),  'Nombre_Ciclo'] = 'Segundo Ciclo'
    mergedDf.loc[mergedDf.Nombre_Ciclo.str.contains('Interciclo', na=False),  'Nombre_Ciclo'] = 'Interciclo'
    mergedDf["Nombre_Curso"] = mergedDf["Nombre_Curso"].astype(str).str.replace("\([0-9]*\)", "")
    mergedDf["Nombre_Curso"] = mergedDf["Nombre_Curso"].astype(str).str.strip()
    mergedDf.loc[mergedDf.Eje.astype(str).str.contains('CIENCIAS BASICAS', na=False), 'Eje'] = 'CIENCIAS BASICAS'
    mergedDf.loc[mergedDf.Eje.astype(str).str.contains('CIENCAS DE INGENIERIA', na=False),  'Eje'] = 'CIENCAS DE INGENIERIA'
    mergedDf.loc[mergedDf.Eje.astype(str).str.contains('INGENIERIA', na=False),  'Eje'] = 'CIENCAS DE INGENIERIA'
    mergedDf.loc[mergedDf.Eje.astype(str).str.contains('COMPUTA', na=False),  'Eje'] = 'CIENCAS DE INGENIERIA'
    mergedDf.loc[mergedDf.Eje.astype(str).str.contains('PROGRAMA', na=False),  'Eje'] = 'CIENCAS DE INGENIERIA'
    mergedDf.loc[mergedDf.Eje.astype(str).str.contains('DATOS', na=False),  'Eje'] = 'CIENCAS DE INGENIERIA'
    mergedDf.loc[mergedDf.Eje.astype(str).str.contains('APLICADA', na=False),  'Eje'] = 'INGENIERIA APLICADA'
    mergedDf.loc[mergedDf.Eje.astype(str).str.contains('PROFESIONAL', na=False),  'Eje'] = 'PROFESIONAL'
    mergedDf.loc[mergedDf.Eje.astype(str).str.contains('OTROS', na=False),  'Eje'] = 'OTROS'

    cursosCFI = cursosCFI.append(mergedDf.loc[mergedDf.Nombre_Curso.str.contains('(CFI)', na=False)])
    cursosNumericos = cursosNumericos.append(mergedDf.loc[mergedDf.Eje.astype(str).str.contains('CIENCIAS BASICAS', na=False)])
    cursosEspecificos = cursosEspecificos.append(mergedDf.loc[mergedDf.Eje.astype(str).str.contains('CIENCAS DE INGENIERIA', na=False) | mergedDf.Eje.astype(str).str.contains('APLICADA', na=False)])
    cursosProfesionales = cursosProfesionales.append(mergedDf.loc[mergedDf.Eje.astype(str).str.contains('PROFESIONAL', na=False)])
    cursosGanados = cursosGanados.append(mergedDf.loc[mergedDf.Nota.astype(int) >= 65])
    cursosPerdidos = cursosPerdidos.append(mergedDf.loc[mergedDf.Nota.astype(int) < 65])
    cursosPerdidos = cursosPerdidos.drop_duplicates(subset=['ID', 'No_curso'])
    cursosCompletos = cursosCompletos.append(mergedDf)

    copia = copia.dropna(subset=['Nota']) #ELIMINA NOTAS VACIAS
    copia = copia.drop(copia[copia.Nota.astype(str).str.contains('A', na=False)].index) #ELIMINA NOTAS INVALIDAD
    copia = copia.drop(copia[copia.Nota.astype(str).str.contains('E', na=False)].index) #ELIMINA NOTAS INVALIDAD
    copia = copia.drop(copia[copia.Nota.astype(str).str.contains('R', na=False)].index) #ELIMINA NOTAS INVALIDAD
    idx = copia.groupby(['No_curso'])['No_tip_examen'].transform(max) == copia['No_tip_examen']
    cursosPerdidosRaw = copia[idx].loc[copia[idx].Nota.astype(int) < 65]
    conteoCursosPerdidosTemp = pd.DataFrame({"ID":[row['ID']],"Conteo_cursos_perdidos":[len(cursosPerdidosRaw.index)]})
    conteoCursosPerdidos = conteoCursosPerdidos.append(df.merge(conteoCursosPerdidosTemp))
    


cursosNumericosGanados = cursosNumericosGanados.append(cursosGanados.loc[cursosGanados.Eje.astype(str).str.contains('CIENCIAS BASICAS', na=False)])  
cursosNumericosPerdidos = cursosNumericosPerdidos.append(cursosPerdidos.loc[cursosPerdidos.Eje.astype(str).str.contains('CIENCIAS BASICAS', na=False)])

cursosEspecificosGanados = cursosEspecificosGanados.append(cursosGanados.loc[cursosGanados.Eje.astype(str).str.contains('CIENCIAS BASICAS', na=False)])  
cursosEspecificosPerdidos = cursosEspecificosPerdidos.append(cursosPerdidos.loc[cursosPerdidos.Eje.astype(str).str.contains('CIENCIAS BASICAS', na=False)]) 

cursosProfesionalesGanados = cursosProfesionalesGanados.append(cursosGanados.loc[cursosGanados.Eje.astype(str).str.contains('CIENCIAS BASICAS', na=False)])  
cursosProfesionalesPerdidos = cursosProfesionalesPerdidos.append(cursosPerdidos.loc[cursosPerdidos.Eje.astype(str).str.contains('CIENCIAS BASICAS', na=False)]) 

if not os.path.exists('DataSets/'):
    os.makedirs('DataSets/')

cursosCFI.to_csv('DataSets/cursosCFI.csv', index=False)
cursosNumericos.to_csv('DataSets/cursosNumericos.csv', index=False)
cursosNumericosGanados.to_csv('DataSets/cursosNumericosGanados.csv', index=False)
cursosNumericosPerdidos.to_csv('DataSets/cursosNumericosPerdidos.csv', index=False)
cursosEspecificos.to_csv('DataSets/cursosEspecificos.csv', index=False)
cursosEspecificosGanados.to_csv('DataSets/cursosEspecificosGanados.csv', index=False)
cursosEspecificosPerdidos.to_csv('DataSets/cursosEspecificosPerdidos.csv', index=False)
cursosProfesionales.to_csv('DataSets/cursosProfesionales.csv', index=False)
cursosProfesionalesGanados.to_csv('DataSets/cursosProfesionalesGanados.csv', index=False)
cursosProfesionalesPerdidos.to_csv('DataSets/cursosProfesionalesPerdidos.csv', index=False)
cursosGanados.to_csv('DataSets/cursosGanados.csv', index=False)
cursosPerdidos.to_csv('DataSets/cursosPerdidos.csv', index=False)
conteoCursosPerdidos.to_csv('DataSets/conteoCursosPerdidos.csv', index=False)
cursosCompletos.to_csv('DataSets/cursosCompletos.csv', index=False)



