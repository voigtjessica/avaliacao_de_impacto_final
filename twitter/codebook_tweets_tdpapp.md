## Codebook "tweets_tdpapp.Rdata" 

O arquivo foi criado no dia 13 de fevereiro com os tweets que até então tinham sido realizados. As colunas dos arquivos são:

|Coluna|Descrição|
|:-----:|:------|
|text| Conteúdo do tweet|
|favorited| Se o tweet foi favoritado (TRUE) ou não (FALSE)|
|favoriteCount| Contagem de likes |
|replyToSN| Descobrir |
|created| Data de criação do tweet |
|truncated| Se a mensagem foi cortada por excesso de caractere (sim == TRUE, não == FALSE) |
|replyToSID| Descobrir |
|id| Id do tweet |                    
|replyToUID| Descobrir |
|statusSource| fonte do tweet |
|screenName| Nome do usuário |
|retweetCount| Contagem de retweets |
|isRetweet| Se é um retweet |
|retweeted| Se foi retuitado |
|longitude| descobrir |
|latitude| descobrir |
|tipo_mensagem| Se a mensagem automatica foi gerada a partir de um alerta ou de uma resposta |
|entidade_que_respondeu| nome da entidade que respondeu ao alerta e foi tweetada na nossa conta |
|alerta_encaminhado_obra| Nome da obra para o qual foi encaminhado o alerta |

### Importante:

Conversei com os nossos fornecedores e não há como vincular um tweet a um alerta específico. Os dados nas últimas 3 colunas foram gerados por mim a partir de informações do texto do tweet. 
Eu não realizei um join do nome das obras com a base de projetos pois existem muitas obras com nomes genéricos e repetidos ( "ESCOLA PAC / 001 ETC...") o que iria gerar uma série de duplicadas no meu bando e eu não necessariamente teria como dizer a qual dos alertas aquele tweet se refere. 
