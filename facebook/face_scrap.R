# Tutorial
# http://thinktostart.com/analyzing-facebook-with-r/
# https://github.com/voigtjessica/cebrap_lab_raspagem_r/blob/master/tutorials/webscraping_tutorial11.md
# https://cran.r-project.org/web/packages/Rfacebook/Rfacebook.pdf


library(Rfacebook)
library(RCurl)
library(devtools)
library(tidyverse)
library(googledrive)
library(data.table)
library(janitor)

#autenticação no google drive:
drive_find(n_max=10)  

token_acesso <- ""

me <- getUsers("me", token_acesso, private_info = TRUE)


# Now we saved our own public information in the variable „me“ and you can take a look at it.

page <- getPage(page = "brasil.transparencia", 
                token = token_acesso,
                n = 1000,
                since='2017/08/13',
                until='2019/02/15')


#Salve a planilha em csv:

setwd("C:/Users/coliv/Documents/tadepe-tdp_impact2/facebook_things")

fwrite(page , file="page.csv")

#agora, ele vai buscar no diretório já setado o arquivo para upload:

drive_upload(
  "page.csv",
  path="~/TB/Comunicação/Redes sociais",
  name = "postagens_tbrasil",
  type = "spreadsheet")

# Agora análise:

anuncios <- fread("export_20190315_1527.csv", encoding = "UTF-8")

anuncios1 <- anuncios %>%
  select(1:5,Body, Title, 13:21, 40,41,73,74,75,167) %>%
  clean_names() %>%
  mutate(id_post = gsub("https://www.facebook.com/280994653587/posts/", "", permalink))

anuncios1 %>%
  filter(id_post == "1694824487264852") %>%
  select(permalink)

ad_id <- unique(anuncios1$id_post)

page_tdp <- page %>%
  filter(grepl("Tá de Pé", message) | grepl("obra", message) | grepl("tá de pé", message)) %>%
  mutate(id_post = gsub("280994653587_", "", id),
         post_patrocinado = ifelse(id_post %in% ad_id, 1, 0))


setwd("C:/Users/coliv/Documents/tadepe-tdp_impact2/facebook_things")

fwrite(page_tdp , file="page_tdp.csv")
save(page_tdp , file="page_tdp.Rdata")
save(anuncios1, file = "anuncios_tdp.Rdata")
