# Esse script irá verificar:

# Alertas enviados pelo projeto
# Irei cruzar esses alertas com as mensagens enviadas para a instâncias a partir de cada um desses alertas
# Irei cruzer as respostas recebidas para as mensagens
# Cruzar com a instância que respondeu.


library(RPostgreSQL)
library(dplyr)
library(data.table)
library(stringi)
library(readr)
library(janitor)
library(googledrive)
library(tidyr)
library(googlesheets)
library(xlsx)

drive_find(n_max=10)
gs_ls() 

# Contatos, para que eu saiba futuramente quem respondeu:
contatos_sheet <- gs_title("planilha_contatos_producao_tdp")
contatos_tdp <- gs_read(contatos_sheet)

# criando df para cruzar código do contato para o qual o alerta foi encaminhado e o tipo de intância:
tipo_contato <- contatos_tdp %>%
  clean_names() %>%
  select(id, instancia)

# Baixando df com a verificação se as respostas são válidas ou não.
respostas_validadas_sheet <- gs_title("Respostas_bianca")
respostas_validadas <- gs_read(respostas_validadas_sheet)

respostas_validadas <- respostas_validadas %>%
  clean_names() %>%
  filter(classificacao == "sem informação relevante") 

# Criei um objeto para mapear respostas que não são válidas:
not_valid_answers <- unique(respostas_validadas$id)

#Alertas que fizeram parte da campanha:

setwd("C:/Users/coliv/Documents/respostas_relatorio")
envio_acao_v2 <- fread("envio_acao_v2.csv")
envio_acao_v2 <- envio_acao_v2 %>%
  clean_names() 

# Criei um objeto para mapear os ids de obras da campanha ( e vão me ajudar a ver quais alertas foram ou não da campanha)
ids_acao <- envio_acao_v2$id_da_obra

################ Bancos de dados  da aplicação que eu preciso do projeto

#Conectando com a aplicação
pg = dbDriver("PostgreSQL")

con = dbConnect(pg,
                user="read_only_user", password="",
                host ="aag6rh5j94aivq.cxbz7geveept.sa-east-1.rds.amazonaws.com",
                port = 5432, dbname="ebdb")

# Bancos (auto-explicativos)

messages <- dbGetQuery(con, "SELECT * FROM messages")
inspections <- dbGetQuery(con, "SELECT * FROM inspections")
projetos = dbGetQuery(con, "SELECT * FROM projects")
respostas = dbGetQuery(con, "SELECT * FROM answers")
location_cities = dbGetQuery(con, "SELECT * FROM location_cities")
location_states = dbGetQuery(con, "SELECT * FROM location_states")

## Sub-bancos para cruzamentos futuros

#Verificando para quais instâncias que o alerta foi encaminhado.
inspection_instancias <- messages %>%
  filter(!is.na(contact_id)) %>%
  arrange(inspection_id) %>%
  left_join(tipo_contato, by=c("contact_id" = "id")) %>%
  group_by(inspection_id) %>%
  summarise(inst = paste(instancia, collapse = " , " )) %>%
  mutate(prefeitura = ifelse(grepl("Prefeitura", inst), 1, 0),
         gov_do_estado = ifelse(grepl("Governo do Estado", inst), 1, 0),
         vereadores = ifelse(grepl("Camara", inst), 1, 0),
         ass_legislativa = ifelse(grepl("Assembleia Legislativa", inst), 1, 0),
         fnde = ifelse(grepl("FNDE", inst), 1, 0),
         cgu = ifelse(grepl("CGU", inst), 1, 0)) %>%
  select(-(inst))

# Resolvendo aqui o encoding do nome das cidades, para não precisar resolver depois:
Encoding(location_cities$name) <- "UTF-8"

# Alertas que foram respondidos, para cruzar com o banco dos alertas.
respondidos <- respostas  %>%
  rename(id_resposta = id) %>%
  select(id_resposta, message_id, content) %>%
  left_join(messages, by=c("message_id" = "id")) %>%
  distinct(id_resposta, content, inspection_id, contact_id)                    # retirando respostas duplicadas

#Resolvendo o encoding do conteúdo das respostas:
Encoding(respondidos$content) <- "UTF-8"

# Criando um objeto para mapear quais ids foram respondidos.
respondidos_ids <- unique(respondidos$inspection_id)
respondidos_ids <- respondidos_ids[-c(1180, 2990)]

#Agora o meu banco de dados final :

todos_alertas <- inspections %>%
  rename(inspection_id = id) %>%
  filter(is.na(deleted_at),          #tirando as deletadas
         !status %in% c(6, 2)) %>%
  select(-c(status, status_incongruity, lat, lon, comment, deleted_at)) %>%
  left_join(projetos, by=c("project_id" = "id")) %>%     # Para saber qual alerta se refere a qual projeto
  select(inspection_id, user_id, project_id, created_at.x, updated_at.x, city_id) %>%
  mutate(respondido = ifelse(inspection_id %in% respondidos_ids , "answered", "not answered" )) %>%   #eu conferi que status e status_incongruity batiam com essa informação, então não está tautológico 
  left_join(respondidos, by=c("inspection_id"))   %>%                                                  # Alguns alertas têm mais de uma resposta, por isso o número de linhas aumenta. Eu verifiquei que são respostas de verdade
  mutate(alerta_campanha = ifelse(user_id == 5977 |                
                                    project_id %in% ids_acao & created_at.x > "2018-12-16" & created_at.x < "2018-12-21",
                                  1, 0),
         alerta_campanha = ifelse(is.na(user_id), 0, alerta_campanha),
         valid_answer = ifelse(id_resposta %in% not_valid_answers, 0, 1),                             # mapeando aquelas que eu verifiquei como respostas válidas. 
         valid_answer = ifelse(respondido ==  "not answered", NA, valid_answer )) %>%
  left_join(contatos_tdp, by=c("contact_id" = "Id")) %>%
  select(-c(contact_id, 'Município', Uf, Contato, Instância, Twitter, 'Data de inclusão', 'Data de atualização')) %>%
  left_join(projetos, by=c("project_id" = "id")) %>%                                                  #isso aqui foi um erro, fiz duas vezes a mesma operação, mas não estou com tempo de arrumar e o resultado está certo.
  select(inspection_id , user_id, project_id, created_at.x, updated_at.x , 
         respondido, content, alerta_campanha, 'Responsável', city_id.y, funded_by, valid_answer) %>%
  rename(inspection_created_at = created_at.x,
         inspection_last_updated = updated_at.x,
         inspection_status = respondido, 
         campaign_alert = alerta_campanha,
         entity_who_answered = 'Responsável',
         answer_content = content) %>%
  left_join(location_cities, by=c("city_id.y" = "id")) %>%
  left_join(location_states, by=c("state_id" = "id")) %>%
  select(-c(name.y, city_id.y, state_id)) %>%
  rename(location_city = name.x,
         state = abbreviation) %>%
  filter(inspection_created_at < "2019-02-01") %>%
  left_join(inspection_instancias, by=c("inspection_id") ) %>%
  select(inspection_id, campaign_alert , inspection_created_at, 
         prefeitura, gov_do_estado, vereadores, ass_legislativa, fnde, cgu, inspection_last_updated, 
         user_id, project_id, funded_by, 
         location_city, state, 
         inspection_status, entity_who_answered, answer_content, valid_answer) 


