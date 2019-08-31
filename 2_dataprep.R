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


dados.join[,'HOMICÍDIO DOLOSO (2)']
dados.join[,'HOMICÍDIO DOLOSO POR ACIDENTE DE TRÂNSITO']
dados.join[,'HOMICÍDIO DOLOSO (2)'] <- dados.join[,'HOMICÍDIO DOLOSO (2)'] - 
  dados.join[,'HOMICÍDIO DOLOSO POR ACIDENTE DE TRÂNSITO']


names(dados.join)[names(dados.join)=='HOMICÍDIO DOLOSO (2)'] <- 'HOMICÍDIO DOLOSO OUTROS'

#dados.join[,'HOMICÍDIO DOLOSO (2)'] <- NULL

## RETIRANDO VARIAVEIS DE TOTAIS
names(dados.join)

dim(dados.join)

names(dados.join[,24:25])
dados.join[,24:25] <- NULL

## RETIRANDO AS VARIÁVEIS DE NUMERO DE VÍTIMAS
dim(dados.join)
names(dados.join)

names((dados.join[,16:18]))
dados.join[,16:18] <- NULL

dim(dados.join)
names(dados.join)


## JUNTANDO HOMICIDIO DOLOCO E CULPOSO POR AC DE TRANSITO

#dados.join$homicidio_por_ac_transito <- 
#  dados.join$`HOMICÍDIO CULPOSO POR ACIDENTE DE TRÂNSITO` +
#  dados.join$`HOMICÍDIO DOLOSO POR ACIDENTE DE TRÂNSITO`

#dados.join$`HOMICÍDIO CULPOSO POR ACIDENTE DE TRÂNSITO` <- NULL
#dados.join$`HOMICÍDIO DOLOSO POR ACIDENTE DE TRÂNSITO` <- NULL

## juntar lesao corporal seguida de morte e homicidio doloso


#dados.join$HomicidioDoloso <- 
#  dados.join$HomicidioDolosoExcetoTransito +
#  dados.join$`LESÃO CORPORAL SEGUIDA DE MORTE`

#dados.join$HomicidioDolosoExcetoTransito <- NULL
#dados.join$`LESÃO CORPORAL SEGUIDA DE MORTE` <- NULL

#tirando roubo a banco e roubo de carga

dados.join$`ROUBO A BANCO` <-NULL

dados.join$`ROUBO DE CARGA` <- NULL


#RENOMEANDO AS VARIAVEIS
names(dados.join)

variaveis <- data.frame(Nome = paste('X',
                        str_pad(string = as.character(1:16),width = 2,pad = '0'), 
                        sep =''),
                        'Descrição' = colnames(dados.join)[3:18])
variaveis

colnames(dados.join)[3:18] <- paste('X',
                                    str_pad(string = as.character(1:16),width = 2,pad = '0'), 
                                     sep ='')



### CONSIDERANDO SOMENTE AS DELECAGIAS REGIONAIS



dados.join <- dados.join[substr(dados.join$delegacia,5,6) == 'DP',]




write.csv2(dados.join, 'base_boletins_tcc.csv',row.names=FALSE)
write.csv2(variaveis, 'variaveis.csv',row.names=FALSE, col.names = FALSE, quote = FALSE)


### 

