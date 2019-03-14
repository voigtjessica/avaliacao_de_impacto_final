# Dados do @tadepeapp 
# url do tutorial: https://github.com/leobarone/cebrap_lab_raspagem_r/blob/master/tutorials/webscraping_tutorial09.Rmd#L11

library(ROAuth)
library(httr)
library(twitteR)
library(dplyr)

consumer_key <- 
consumer_secret <- 
access_token <- 
access_secret <- 


#Usamos agora a função "setup_twitter_oauth" e nos conectamos ao Twitter via R:
 
setup_twitter_oauth(consumer_key,
                    consumer_secret,
                    access_token,
                    access_secret)

#Escolher a opção (1). Você será redirecionad@ ao browser para concluir a autenticação.

# Usuários e timeline de usuários
# podemos obter informações dos usuários com a função "getUser". 

tdp_user <- getUser('tadepeapp')
tdp_user$statusesCount    #tweets

#Todos os tweets do TDPapp

tdp_timeline <- userTimeline('tadepeapp', n = 788)
df.timeline <- twListToDF(tdp_timeline)

#Classificando se é uma resposta ou o anúncio de um encaminhamento de alerta:

tweets_tdpapp <- df.timeline %>%
  mutate(tipo_mensagem = ifelse(grepl("A construção da", text), "alerta",
                                ifelse(grepl("Veja a resposta", text), "resposta",
                                       "outro"))) %>%
filter(tipo_mensagem != "outro" ) %>%
mutate(entidade_que_respondeu = ifelse(tipo_mensagem == "resposta" , sub(".*?que", "", text),
                         sub("A construção d" , "", text)),
         entidade_que_respondeu = str_sub(entidade_que_respondeu, 3, str_length(entidade_que_respondeu)),
         entidade_que_respondeu  = ifelse(tipo_mensagem == "resposta" , sub("deu.*", "", entidade_que_respondeu),
                         sub("apresenta.*" , "", entidade_que_respondeu)),
         alerta_encaminhado_obra = ifelse(tipo_mensagem == "alerta", entidade_que_respondeu, NA),
         entidade_que_respondeu = ifelse(tipo_mensagem == "resposta", entidade_que_respondeu, NA))

save(tweets_tdpapp , file="tweets_tdpapp.Rdata")
