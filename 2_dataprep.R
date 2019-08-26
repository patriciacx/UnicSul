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

glimpse(dados.join)

# SUBTRAINDO HOMICIDIOS


dados.join[,'HOMICÍDIO DOLOSO (2)']
dados.join[,'HOMICÍDIO DOLOSO POR ACIDENTE DE TRÂNSITO']
dados.join$HomicidioDolosoExcetoTransito <- dados.join[,'HOMICÍDIO DOLOSO (2)'] - 
  dados.join[,'HOMICÍDIO DOLOSO POR ACIDENTE DE TRÂNSITO']


dados.join[,'HOMICÍDIO DOLOSO (2)'] <- NULL

## RETIRANDO VARIAVEIS DE TOTAIS
glimpse(dados.join)

dim(dados.join)

head(dados.join[,23:24])
dados.join[,23:24] <- NULL

## RETIRANDO AS VARIÁVEIS DE NUMERO DE VÍTIMAS
dim(dados.join)
glimpse(dados.join)

head(dados.join[,15:17])
dados.join[,15:17] <- NULL

dim(dados.join)
glimpse(dados.join)


## JUNTANDO HOMICIDIO DOLOCO E CULPOSO POR AC DE TRANSITO

dados.join$homicidio_por_ac_transito <- 
  dados.join$`HOMICÍDIO CULPOSO POR ACIDENTE DE TRÂNSITO` +
  dados.join$`HOMICÍDIO DOLOSO POR ACIDENTE DE TRÂNSITO`

dados.join$`HOMICÍDIO CULPOSO POR ACIDENTE DE TRÂNSITO` <- NULL
dados.join$`HOMICÍDIO DOLOSO POR ACIDENTE DE TRÂNSITO` <- NULL

## juntar lesao corporal seguida de morte e homicidio doloso


dados.join$HomicidioDoloso <- 
  dados.join$HomicidioDolosoExcetoTransito +
  dados.join$`LESÃO CORPORAL SEGUIDA DE MORTE`

dados.join$HomicidioDolosoExcetoTransito <- NULL
dados.join$`LESÃO CORPORAL SEGUIDA DE MORTE` <- NULL

#tirando roubo a banco

dados.join$`ROUBO A BANCO` <-NULL

#RENOMEANDO AS VARIAVEIS

variaveis <- cbind(paste('X',1:15, sep =''),
             colnames(dados.join)[3:17])
variaveis

colnames(dados.join)[3:17] <- paste('X',1:17, sep ='')



### CONSIDERANDO SOMENTE AS DELECAGIAS REGIONAIS

substr(x, start=n1, stop=n2)



dados.join <- dados.join[substr(dados.join$delegacia,5,6) == 'DP',]




write.csv2(dados.join, 'base_boletins_tcc.csv',row.names=FALSE)
write.csv2(variaveis, 'variaveis.csv',row.names=FALSE)


### 

