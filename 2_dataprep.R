library(tidyverse)
library(dplyr)
library(tidyr)


#setwd(dirname(rstudioapi::getSourceEditorContext()$path))
getwd()



arquivo <- read.csv("tcc_dataset.csv", encoding="UTF-8")

delegacias <- read.csv("delegacias.csv", encoding="UTF-8", sep=';')
dados <- arquivo[,c('delegacia_id', 'Natureza', 'Total')]
dados <- dados %>% spread(key='Natureza',value = 'Total')

colnames(delegacias)[1] <- 'delegacia_id'

dados.join <- left_join(x= dados, 
                        y=delegacias, 
                        by='delegacia_id')

dados.join <- dados.join[,c(1,25,2:24)]

names(dados.join)

# SUBTRAINDO HOMICIDIOS


dados.join[,'HOMIC�DIO DOLOSO (2)']
dados.join[,'HOMIC�DIO DOLOSO POR ACIDENTE DE TR�NSITO']
dados.join[,'HOMIC�DIO DOLOSO (2)'] <- dados.join[,'HOMIC�DIO DOLOSO (2)'] - 
  dados.join[,'HOMIC�DIO DOLOSO POR ACIDENTE DE TR�NSITO']


names(dados.join)[names(dados.join)=='HOMIC�DIO DOLOSO (2)'] <- 'HOMIC�DIO DOLOSO OUTROS'

#dados.join[,'HOMIC�DIO DOLOSO (2)'] <- NULL

## RETIRANDO VARIAVEIS DE TOTAIS
names(dados.join)

dim(dados.join)

names(dados.join[,24:25])
dados.join[,24:25] <- NULL

## RETIRANDO AS VARI�VEIS DE NUMERO DE V�TIMAS
dim(dados.join)
names(dados.join)

names((dados.join[,16:18]))
dados.join[,16:18] <- NULL

dim(dados.join)
names(dados.join)


## JUNTANDO HOMICIDIO DOLOCO E CULPOSO POR AC DE TRANSITO

#dados.join$homicidio_por_ac_transito <- 
#  dados.join$`HOMIC�DIO CULPOSO POR ACIDENTE DE TR�NSITO` +
#  dados.join$`HOMIC�DIO DOLOSO POR ACIDENTE DE TR�NSITO`

#dados.join$`HOMIC�DIO CULPOSO POR ACIDENTE DE TR�NSITO` <- NULL
#dados.join$`HOMIC�DIO DOLOSO POR ACIDENTE DE TR�NSITO` <- NULL

## juntar lesao corporal seguida de morte e homicidio doloso


#dados.join$HomicidioDoloso <- 
#  dados.join$HomicidioDolosoExcetoTransito +
#  dados.join$`LES�O CORPORAL SEGUIDA DE MORTE`

#dados.join$HomicidioDolosoExcetoTransito <- NULL
#dados.join$`LES�O CORPORAL SEGUIDA DE MORTE` <- NULL

#tirando roubo a banco e roubo de carga

dados.join$`ROUBO A BANCO` <-NULL

dados.join$`ROUBO DE CARGA` <- NULL


#RENOMEANDO AS VARIAVEIS
names(dados.join)

variaveis <- data.frame(Nome = paste('X',
                        str_pad(string = as.character(1:16),width = 2,pad = '0'), 
                        sep =''),
                        'Descri��o' = colnames(dados.join)[3:18])
variaveis

colnames(dados.join)[3:18] <- paste('X',
                                    str_pad(string = as.character(1:16),width = 2,pad = '0'), 
                                     sep ='')



### CONSIDERANDO SOMENTE AS DELECAGIAS REGIONAIS



dados.join <- dados.join[substr(dados.join$delegacia,5,6) == 'DP',]




write.csv2(dados.join, 'base_boletins_tcc.csv',row.names=FALSE, dec=".")
write.csv2(variaveis, 'variaveis.csv',row.names=FALSE, col.names = FALSE, quote = FALSE, dec="")


### 

