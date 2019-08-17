library(httr)  # will be use to make HTML GET and POST requests
library(dplyr)
library(lessR)

delegacias <- c(1410,1246,1143,1067,1015,983,957,934,915,1478,1275,1265,1262,1259,1257,1256,1255,1254,1253,1252,1154,1153,
                1152,1151,1150,1149,1148,1147,1146,1145,1078,1077,1076,1075,1074,1073,1072,1071,1070,1069,1027,1026,1025,
                1024,1023,1022,1021,1020,1019,1018,994,993,992,991,990,989,988,987,986,985,966,965,964,963,962,961,960,
                959,945,943,942,941,940,938,937,926,925,923,921,919,917,910,909,908,907,905,904,903,902,901,1270,1269,
                1268,1267,1251,1144,1068,1017,984,958,935,916,900,1476,773,772,771,764,11,4,5,6,7,8,9,10,758,1469,1411)

url <- 'http://www.ssp.sp.gov.br/Estatistica/Pesquisa.aspx'
#c?digo para dar um POST vazio no site

view_state <- httr::POST(url) %>% 
  xml2::read_html() %>% 
  rvest::html_nodes("input[name='__VIEWSTATE']") %>% 
  rvest::html_attr("value");view_state

event_validation <- httr::POST(url) %>%
  xml2::read_html() %>% 
  rvest::html_nodes("input[name='__EVENTVALIDATION']") %>% 
  rvest::html_attr("value");event_validation

params <- list(`__EVENTTARGET` = "ctl00$conteudo$btnMensal",
               `__VIEWSTATE` = view_state,
               `__EVENTVALIDATION` = event_validation)

view_state <- httr::POST(url, body = params,encode = 'form') %>% 
  xml2::read_html() %>% 
  rvest::html_nodes("input[name='__VIEWSTATE']") %>% 
  rvest::html_attr("value");view_state

event_validation <- httr::POST(url, body = params, encode = 'form') %>% 
  xml2::read_html() %>% 
  rvest::html_nodes("input[name='__EVENTVALIDATION']") %>% 
  rvest::html_attr("value");event_validation

dataset <- data.frame()

for (x in delegacias) {
  params <- list(`__EVENTTARGET` = "ctl00$conteudo$btnMensal",
                 `__VIEWSTATE` = view_state,
                 `__EVENTVALIDATION` = event_validation,
                 `ctl00$conteudo$ddlAnos` = 2018,
                 `ctl00$conteudo$ddlDelegacias` = x)
  
  resposta <- httr::POST(url,
                         body = params,
                         encode = 'form')  %>%
    xml2::read_html() %>% 
    rvest::html_table()
  
  delegacia_id <- c(x)
  
  dat <- as.data.frame (resposta[[1]])
  dat <- cbind(dat,delegacia_id)
  
  dataset<-rbind (dataset, dat)
}