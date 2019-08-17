library(tidyverse)
library(dplyr)
library(tidyr)


setwd(dirname(rstudioapi::getSourceEditorContext()$path))
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

## RETIRANDO VARIAVEIS DE TOTAIS
dim(dados.join)
dados.join[,24:25] <- NULL

## RETIRANDO AS VARIÁVEIS DE NUMERO DE VÍTIMAS

head(dados.join[,16:18])
dados.join[,16:18] <- NULL

dim(dados.join)
glimpse(dados.join)

#RENOMEANDO AS VARIAVEIS

variaveis <- cbind(paste('X',1:19, sep =''),
             colnames(dados.join)[3:20])
variaveis

colnames(dados.join)[3:23] <- paste('X',1:23, sep ='')


write.csv2(dados.join, 'base_boletins_tcc.csv',row.names=FALSE)
write.csv2(variaveis, 'variaveis.csv',row.names=FALSE)
