import excel "/Users/pablo/Desktop/EPIDEMIOLOGIA/MAGISTER 2024/TESIS 2/BBDD/BBDD_v2_variables_tabuladas.xlsx", sheet("Hoja1") firstrow
drop X Y Z AA Riesgo4 Riesgo3 Riesgo2 Riesgo1

*CODIFICAR VARIABLES 
label variable SEXO "Sexo" 
label define Etsex 0 "Femenino" 1 "Masculino"
label values SEXO Etsex

label variable GRUPO_ETAREO "Grupo Etareo"
label define Etedad 0 "10 a 19"  1 "20 a 29" 2 "30 a 39" 3 "40 a 49" 4 "50 a 59" 5 "60 a 69" 6 "70 a 79" 7 ">=80"
label values GRUPO_ETAREO Etedad

label variable NACIONALIDAD_DICOTOMICA "Nacionalidad" 
label define Etnac 0 "Chileno" 1 "Extranjero"
label values NACIONALIDAD_DICOTOMICA Etnac

label variable ALCOHOL "Alcoholismo" 
label define Etalc 0 "No" 1 "Si"
label values ALCOHOL Etalc

label variable COINFECCIONVIH "Vivir con VIH" 
label define Etvih 0 "No" 1 "Si"
label values COINFECCIONVIH Etvih

label variable CONTACTOTB "Contacto TB" 
label define Ettb 0 "No" 1 "Si"
label values CONTACTOTB Ettb

label variable DIABETICO "Vivir con diabetes" 
label define Etdm 0 "No" 1 "Si"
label values DIABETICO Etdm

label variable DROGADICCION "Consumo drogas" 
label define Etdrogas 0 "No" 1 "Si"
label values DROGADICCION Etdrogas

label variable EXTRANJERO "Extranjero" 
label define Etextr 0 "No" 1 "Si"
label values EXTRANJERO Etextr

label variable OTRAIS "Otras IS" 
label define Etis 0 "No" 1 "Si"
label values OTRAIS Etis

label variable PERSONALDESALUD "Personal de salud" 
label define Etps 0 "No" 1 "Si"
label values PERSONALDESALUD Etps

label variable PRIVADODELIBERTAD "Privado de libertad" 
label define Etpl 0 "No" 1 "Si"
label values PRIVADODELIBERTAD Etpl

label variable PUEBLOINDIGENA "Pueblo originario" 
label define Etpo 0 "No" 1 "Si"
label values PUEBLOINDIGENA Etpo

label variable RESIDENTEDEHOGAR "Residente de hogar" 
label define Etrh 0 "No" 1 "Si"
label values RESIDENTEDEHOGAR Etrh

label variable SITUACIONDECALLE "Situacion de calle" 
label define Etsc 0 "No" 1 "Si"
label values SITUACIONDECALLE Etsc

label variable NINGUNO "Sin FR" 
label define Etsf 0 "No" 1 "Si"
label values NINGUNO Etsf

label variable CASO "Cáncer de pulmón"
label define Etcp 0 "No" 1 "Si"
label values CASO Etcp

gen rango_tiempo =.
replace rango_tiempo = 1 if (TIEMPO >= 0   & TIEMPO < 30)
replace rango_tiempo = 2 if (TIEMPO >= 30  & TIEMPO < 90)
replace rango_tiempo = 3 if (TIEMPO >= 90  & TIEMPO < 180)
replace rango_tiempo = 4 if (TIEMPO >= 180 & TIEMPO < 365)
replace rango_tiempo = 5 if (TIEMPO >= 365 & TIEMPO < 540)
replace rango_tiempo = 6 if (TIEMPO >= 540 & TIEMPO < 730)
replace rango_tiempo = 7 if (TIEMPO >= 730 & TIEMPO < 910)
replace rango_tiempo = 8 if (TIEMPO >= 910 & TIEMPO < 1095)
replace rango_tiempo = 9 if (TIEMPO >= 1095 & TIEMPO < 1275)
replace rango_tiempo = 10 if (TIEMPO >= 1275 & TIEMPO < 1460)
replace rango_tiempo = 11 if (TIEMPO >= 1460 & TIEMPO < 1645)
replace rango_tiempo = 12 if (TIEMPO >= 1645 & TIEMPO <= 1825)

label define Etrangos 1 "0-29 días" 2 "1-3 meses" 3 "3-6 meses" 4 "6-12 meses" 5 "12-18 meses" 6 "18-24 meses"  7 "24-30 meses" 8 "30-36 meses" 9 "36-42 meses" 10 "42-48 meses" 11 "48-54 meses" 12 "54-60 meses"
label values rango_tiempo Etrangos

*DESCRIPCIÓN BBDD
describe 
dtable i.AÑO_TB i.SEXO i.NACIONALIDAD_DICOTOMICA i.ALCOHOL i.COINFECCIONVIH i.CONTACTOTB i.DIABETICO i.DROGAS i.OTRAIS i.PERSONALDESALUD i.PRIVADODELIBERTAD i.PUEBLOORIGINARIO i.RESIDENTEDEHOGAR i.SITUACIONDECALLE, title("Tabla 3: Descripción de variables categóricas") export(tabla3.docx)

*DESCRIPCION VARIABLES CATEGORICAS (Tabla 3)
dtable i.SEXO i.NACIONALIDAD_DICOTOMICA i.ALCOHOL i.COINFECCIONVIH i.CONTACTOTB i.DIABETICO i.DROGAS i.OTRAIS i.PERSONALDESALUD i.PRIVADODELIBERTAD i.PUEBLOORIGINARIO i.RESIDENTEDEHOGAR i.SITUACIONDECALLE, by(CASO, test)

dtable i.GRUPO_EDAD, by(CASO, test)

*Prueba de proporción con 1 muestra con un valor fijo (Tabla 5)
db prtest 

*DESCRIPCION VARIABLE NUMERICA
sum TIEMPO
by CASO, sort : summarize TIEMPO
histogram TIEMPO, normal by(CASO)

*DESCRIPCION de casos = si 
tabstat TIEMPO if CASO == 1, statistics( count min p10 p25 p50 p75 p90 max )
histogram TIEMPO if CASO == 1, bin(50) frequency normal ytitle("Nº casos") ylabel(, nogrid) xtitle("Tiempo (días)") xlabel(#16, nogrid) title("", size(small) orientation(horizontal) span margin(zero) bexpand)
tabulate rango_tiempo if CASO ==1

*Casos por rangos de tiempos
dtable i.rango_tiempo if CASO ==1, by(AÑO_TB, notests totals missing) column( by(, halign(center)) ) title(Tabla 9: Tiempo al diagnóstico de cáncer de pulmón según año de diagnóstico de tuberculosis pulmonar, Chile, 2019-2023.)

*COMPARACIÓN ENTRE CASO Y NO CASOS 
dtable i.AÑO_TB i.SEXO i.EDAD i.NACIONALIDAD_DICOTOMICA i.NINGUNO i.ALCOHOL i.DROGAS i.DIABETICO i.COINFECCIONVIH i.SITUACIONDECALLE i.CONTACTOTB i.OTRAIS i.PUEBLOORIGINARIO i.PRIVADODELIBERTAD i.PERSONALDESALUD i.RESIDENTEDEHOGAR TIEMPO, by(CASO, tests nototals missing) column( by(, halign(center)) ) continuous(TIEMPO , statistics(median q1 q3) test(none)) title(Tabla 6: Comparación entre casos de tuberculosis pulmonar con y sin cáncer de pulmón, Chile, 2019-2023.) note(Test de chi cuadrado de Pearson para variables categóricas) note(Prueba de rangos de Wilcoxon para variable numérica.) export(Tabla_5.docx)

*comparar tasas de incidencia (Tabla 8)
db iri
iri 9 3969 1627 19458310

