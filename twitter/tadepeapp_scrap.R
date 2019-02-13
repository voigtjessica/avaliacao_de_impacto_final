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
                                       "outro")))

save(tweets_tdpapp , file="tweets_tdpapp.Rdata")
