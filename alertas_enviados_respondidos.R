# Municípios que receberam alertas X Municípios que responderam:

library(RPostgreSQL)
library(dplyr)
library(data.table)
library(stringi)
library(readr)
library(janitor)
library(googledrive)
library(tidyr)
library(googlesheets)

drive_find(n_max=10)
gs_ls() 

pg = dbDriver("PostgreSQL")

con = dbConnect(pg,
                user="read_only_user", password="pandoapps",
                host ="aag6rh5j94aivq.cxbz7geveept.sa-east-1.rds.amazonaws.com",
                port = 5432, dbname="ebdb")

dbListTables(con)

messages <- dbGetQuery(con, "SELECT * FROM messages")
inspections <- dbGetQuery(con, "SELECT * FROM inspections")
projetos = dbGetQuery(con, "SELECT * FROM projects")
respostas = dbGetQuery(con, "SELECT * FROM answers")
location_cities = dbGetQuery(con, "SELECT * FROM location_cities")
location_states = dbGetQuery(con, "SELECT * FROM location_states")


############################################################################
## Segunda vez:

setwd("C:/Users/coliv/Documents/respostas_relatorio")

envio_acao_v2 <- fread("envio_acao_v2.csv")

envio_acao_v2 <- envio_acao_v2 %>%
  clean_names() 

ids_acao <- envio_acao_v2$id_da_obra

todos_alertas <- inspections %>%
  rename(inspection_id = id) %>%
  filter( user_id == 5977 |
            project_id %in% ids_acao & created_at > "2018-12-16" & comment != "NA",
          !(project_id == 31175 & user_id == 6866 ),
          !(project_id == 1006216 & user_id == 4564 )) %>%
  select(project_id, inspection_id) %>%
  left_join(projetos, by=c("project_id" = "id")) %>%
  select(project_id, inspection_id, name, city_id, funded_by) %>%
  left_join(messages, by=c("inspection_id")) %>%
  rename(message_id = id) %>%
  arrange(message_id) %>%
  group_by(project_id) %>%
  mutate(num = 1:n(),
         message_num = paste0("msg_id", num)) %>%
  ungroup() %>%
  select(-c(num,category, e_ouv_protocol_number, e_ouv_url, text, status,
            token, updated_at, created_at, instance, contact_id) ) %>%
  spread(message_num, message_id) %>%
  left_join(respostas, by=c("msg_id1" = "message_id")) %>%
  rename(answer_id_1 = id) %>%
  mutate(msg_id2 = ifelse(is.na(msg_id2), paste0("111111111111", project_id), msg_id2),
         msg_id2 = as.numeric(msg_id2),
         msg_id3 = ifelse(is.na(msg_id3), paste0("111111111111", project_id), msg_id3),
         msg_id3 = as.numeric(msg_id3)) %>%
  left_join(respostas, by=c("msg_id2" = "message_id")) %>%
  rename(answer_id_2 = id) %>%
  left_join(respostas, by=c("msg_id3" = "message_id")) %>%
  rename(answer_id_3 = id) %>%
  select(project_id, inspection_id, name, city_id, funded_by, msg_id1, 
         msg_id2, msg_id3, answer_id_1, answer_id_2, answer_id_3) %>%
  mutate(respondido = ifelse(!is.na(answer_id_1) |
                               !is.na(answer_id_2) |
                               !is.na(answer_id_3) , 1, 0)) %>%
  left_join(location_cities, by=c("city_id" = "id")) %>%
  left_join(location_states, by=c("state_id" = "id")) %>%
  rename(nome_obra = name.x,
         municipio = name.y,
         sigla= abbreviation) %>%
  select(-c(state_id, name, city_id))

municipios_alertas <- todos_alertas %>%
  filter(funded_by == 1) %>%
  group_by(sigla, municipio) %>%
  summarise(alertas_enviados = n(),
            alertas_respondidos = sum(respondido))

uf_alertas <- todos_alertas %>%
  filter(funded_by == 2) %>%
  group_by(sigla, municipio) %>%
  summarise(alertas_enviados = n(),
            alertas_respondidos = sum(respondido))

Encoding(municipios_alertas$municipio) <- "UTF-8"
Encoding(uf_alertas$municipio) <- "UTF-8"

setwd("C:/Users/coliv/Documents/respostas_relatorio")

fwrite(municipios_alertas, file="municipios_alertas2.csv")

drive_upload(
  "municipios_alertas2.csv",
  path="~/TB/Tá de Pé/",
  name = "municipios_alertas2",
  type = "spreadsheet")

fwrite(uf_alertas, file="uf_alertas2.csv")

drive_upload(
  "uf_alertas2.csv",
  path="~/TB/Tá de Pé/",
  name = "uf_alertas2",
  type = "spreadsheet")


uf_grouped_alertas <- todos_alertas %>%
  filter(funded_by == 2) %>%
  group_by(sigla) %>%
  summarise(alertas_enviados = n(),
            alertas_respondidos = sum(respondido))

fwrite(uf_grouped_alertas, file="uf_grouped_alertas.csv")

drive_upload(
  "uf_grouped_alertas.csv",
  path="~/TB/Tá de Pé/",
  name = "uf_grouped_alertas",
  type = "spreadsheet")


#Respostas obtidas dos alertas

#Importando nome das instâncias
contatos_sheet <- gs_title("planilha_contatos_producao_tdp")
contatos_tdp <- gs_read(contatos_sheet)

instancias <- contatos_tdp %>%
  clean_names() %>%
  select(id, responsavel)

respostas_obtidas <- inspections %>%
  rename(inspection_id = id) %>%
  filter( user_id == 5977 |
            project_id %in% ids_acao & created_at > "2018-12-16" & comment != "NA",
          !(project_id == 31175 & user_id == 6866 ),
          !(project_id == 1006216 & user_id == 4564 )) %>%
  select(project_id, inspection_id) %>%
  left_join(projetos, by=c("project_id" = "id")) %>%
  select(project_id, inspection_id, name, city_id, funded_by) %>%
  left_join(messages, by=c("inspection_id")) %>%
  rename(message_id = id) %>%
  arrange(message_id) %>%
  group_by(project_id) %>%
  mutate(num = 1:n(),
         message_num = paste0("msg_id", num)) %>%
  ungroup() %>%
  select(-c(num,category, e_ouv_protocol_number, e_ouv_url, text, status,
            token, updated_at, created_at, instance) ) %>%
  spread(message_num, message_id) %>%
  left_join(respostas, by=c("msg_id1" = "message_id")) %>%
  rename(answer_id_1 = id) %>%
  mutate(msg_id2 = ifelse(is.na(msg_id2), paste0("111111111111", project_id), msg_id2),
         msg_id2 = as.numeric(msg_id2),
         msg_id3 = ifelse(is.na(msg_id3), paste0("111111111111", project_id), msg_id3),
         msg_id3 = as.numeric(msg_id3)) %>%
  left_join(respostas, by=c("msg_id2" = "message_id")) %>%
  rename(answer_id_2 = id) %>%
  left_join(respostas, by=c("msg_id3" = "message_id")) %>%
  rename(answer_id_3 = id) %>%
  mutate(content = ifelse(!is.na(content.x), content.x,
                          ifelse(!is.na(content.y), content.y,
                                 content)),
         new_date = if_else(!is.na(new_date.x), new_date.x,
                          if_else(!is.na(new_date.y), new_date.y,
                                 new_date)),
         created_at = if_else(!is.na(created_at.x), created_at.x,
                           if_else(!is.na(created_at.y), created_at.y,
                                  created_at)),
         updated_at = if_else(!is.na(updated_at.x), updated_at.x,
                             if_else(!is.na(updated_at.y), updated_at.y,
                                    updated_at)),
         msg_id1 = ifelse(msg_id1 > 111111111 , NA, msg_id1),
         msg_id2 = ifelse(msg_id2 > 111111111 , NA, msg_id2),
         msg_id3 = ifelse(msg_id3 > 111111111 , NA, msg_id3),
         msg_id = ifelse(!is.na(msg_id1), msg_id1,
                         ifelse(!is.na(msg_id2), msg_id2,
                                msg_id3)),
         answer_id = ifelse(!is.na(answer_id_1), answer_id_1,
                         ifelse(!is.na(answer_id_2), answer_id_2,
                                answer_id_3))) %>%
  select(project_id, inspection_id, name, city_id, funded_by, msg_id,created_at,
         answer_id, updated_at, content, new_date, contact_id) %>%
  left_join(location_cities, by=c("city_id" = "id")) %>%
  left_join(location_states, by=c("state_id" = "id")) %>%
  rename(id_da_obra = project_id,
         id_do_alerta = inspection_id,
         nome_da_obra = name.x,
         responsabilidade = funded_by,
         id_da_msg = msg_id,
         data_envio_msg = created_at,
         id_resposta = answer_id,
         data_resposta = updated_at,
         resposta = content,
         local_municipio = name.y,
         local_uf = abbreviation) %>%
  select(-c(city_id, state_id, name, new_date)) %>%
  filter(!is.na(id_resposta)) %>%
  mutate(responsabilidade = ifelse(responsabilidade == 1, "município", "governo do estado")) %>%
  left_join(instancias, by=c("contact_id" = "id")) %>%
  select(id_da_obra, id_do_alerta, nome_da_obra, local_municipio, local_uf, responsabilidade, responsavel, id_da_msg, data_envio_msg, 
         id_resposta, data_resposta, resposta, contact_id )

Encoding(respostas_obtidas$nome_da_obra) <- "UTF-8"
Encoding(respostas_obtidas$resposta) <- "UTF-8"
Encoding(respostas_obtidas$municipio) <- "UTF-8"
Encoding(respostas_obtidas$responsavel) <- "UTF-8"
Encoding(respostas_obtidas$responsabilidade) <- "UTF-8"
  
setwd("C:/Users/coliv/Documents/respostas_relatorio")

fwrite(respostas_obtidas, file="respostas_obtidas.csv")
library(xlsx)

write.xlsx(as.data.frame(respostas_obtidas), file="respostas_obtidas.xlsx", sheetName="respostas_obtidas",
           col.names=TRUE, row.names=FALSE, append=FALSE, showNA=FALSE)

drive_upload(
  "respostas_obtidas.xlsx",
  path="~/TB/Tá de Pé/",
  name = "respostas_obtidas",
  type = "spreadsheet")
