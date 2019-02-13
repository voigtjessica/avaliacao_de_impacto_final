# Situação das obras no final da primeira etapa do projeto, em março de 2018.

library(dplyr)
library(data.table)
library(janitor)

como_data <- function(x) {
  
  stopifnot(require(dplyr))
  x <- gsub(" .*", "", x)
  y <- gsub(".*/", "", x)
  x <- if_else((nchar(y)==4), as.Date(x, format="%d/%m/%Y"),
               as.Date(x, format="%d/%m/%y"))
  
}

projetos_escolas_e_creches <- c("Escola de Educação Infantil Tipo B",
                                "MI - Escola de Educação Infantil Tipo B",
                                "Projeto 2 Convencional",
                                "Projeto 1 Convencional",
                                "Escola de Educação Infantil Tipo C",
                                "Espaço Educativo - 12 Salas" ,
                                "Escola com Projeto elaborado pelo proponente",
                                "Espaço Educativo Ensino Médio Profissionalizante",
                                "Espaço Educativo - 02 Salas",
                                "Espaço Educativo - 06 Salas",
                                "Espaço Educativo - 04 Salas",
                                "Espaço Educativo - 01 Sala",
                                "Espaço Educativo - 08 Salas",
                                "Espaço Educativo - 10 Salas",
                                "Escola de Educação Infantil Tipo A",
                                "Escola com projeto elaborado pelo concedente",
                                "MI - Escola de Educação Infantil Tipo C",
                                "Projeto Tipo C - Bloco Estrutural",
                                "Projeto Tipo B - Bloco Estrutural")

projetos_visiveis_no_app <- c("Projeto 2 Convencional",
                              "Projeto 1 Convencional",
                              "Espaço Educativo - 12 Salas" ,
                              "Espaço Educativo - 02 Salas",
                              "Espaço Educativo - 06 Salas",
                              "Espaço Educativo - 04 Salas",
                              "Espaço Educativo - 01 Sala")

status_visiveis_app <- c("Inacabada",
                         "Planejamento pelo proponente",
                         "Execução",
                         "Paralisada",
                         "Licitação",
                         "Contratação",
                         "Em Reformulação")

setwd("C:/Users/coliv/Documents/tadepe-tdp_impact2/bancos")

#grupo controle:
load("controle1.Rdata")

obras_08032018 <- fread("obras_08032018.csv", encoding = "UTF-8")

obras_fim_fase_1 <- obras_08032018 %>%
  clean_names() %>%
  filter(tipo_do_projeto %in% projetos_escolas_e_creches) %>%
  select(id, nome, situacao, municipio, uf, cep, logradouro, bairro, percentual_de_execucao,
         data_prevista_de_conclusao_da_obra, tipo_do_projeto, rede_de_ensino_publico, 
         nome_da_entidade) %>%
  mutate(visivel_no_app = ifelse(situacao %in% status_visiveis_app &
                                   tipo_do_projeto %in% projetos_visiveis_no_app, 1, 0)) %>%
  left_join(munic_controle, by = c("municipio" = "municipality" , "uf" = "state")) %>%
  mutate(grupo_controle = ifelse(is.na(grupo_controle) | visivel_no_app == 0, 0, grupo_controle),
         visivel_no_app = ifelse(grupo_controle == 1, 0, visivel_no_app),
         data_prevista_de_conclusao_da_obra = como_data(data_prevista_de_conclusao_da_obra))

save(obras_fim_fase_1 , file="obras_fim_fase_1.Rdata")  
