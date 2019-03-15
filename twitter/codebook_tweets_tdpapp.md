## Codebook "tweets_tdpapp.Rdata" 

O arquivo foi criado no dia 13 de fevereiro com os tweets que até então tinham sido realizados. As colunas dos arquivos são:

|Coluna|Descrição|
|:-----:|:------|
|text| Conteúdo do tweet|
|favorited| Se o tweet foi favoritado (TRUE) ou não (FALSE)|
|favoriteCount| Contagem de likes |
|replyToSN| Screen name of the user this is in reply to |
|created| Data de criação do tweet |
|truncated| Se a mensagem foi cortada por excesso de caractere (sim == TRUE, não == FALSE) |
|replyToSID| ** Não consta na documentação da biblioteca twitteR |
|id| Id do tweet |                    
|replyToUID| ID of the user this was in reply to |
|statusSource| Source user agent for this tweet |
|screenName| Screen name of the user who posted this statusid |
|retweetCount| Contagem de retweets |
|isRetweet| Se é um retweet |
|retweeted| Se foi retuitado |
|longitude| localização do momento da postagem |
|latitude| localização do momento da postagem |
|tipo_mensagem| Se a mensagem automatica foi gerada a partir de um alerta ou de uma resposta |
|entidade_que_respondeu| Nome da entidade que respondeu ao alerta e foi tweetada na nossa conta |
|alerta_encaminhado_obra| Nome da obra para o qual foi encaminhado o alerta |


### Importante:

Conversei com os nossos fornecedores e não há como vincular um tweet a um alerta específico. Os dados nas últimas 3 colunas foram gerados por mim a partir de informações do texto do tweet. 
Eu não realizei um join do nome das obras com a base de projetos pois existem muitas obras com nomes genéricos e repetidos ( "ESCOLA PAC / 001 ETC...") o que iria gerar uma série de duplicadas no meu bando e eu não necessariamente teria como dizer a qual dos alertas aquele tweet se refere. 
