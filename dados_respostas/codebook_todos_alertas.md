## Objeto "todos_alertas" 

### O que é?

Um objeto R que contém um data.frame onde cada entrada é um alerta recebido pelo projeto Tá de Pé. 
Os alertas têm início no dia 17/06/2017 e vão até o dia 01/02/2019. 

### Codebook:

| Nome Coluna    | Descrição           |
| :-------------:|:-------------------:|
| inspection_id  | id do alerta |
| campaign_alert | se alerta faz parte ou não da campanha, se sim == 1, se não == 2 |
| inspection_created_at| data de criação do alerta |
| prefeitura | Se alerta foi encaminhado para a prefeitura |
| gov_do_estado | Se alerta foi encaminhado para o governo estadual|
| vereadores | Se alerta foi encaminhado para a câmara municipal |
| ass_legislativa | Se alerta foi encaminhado para a assembléia legislativa |
| fnde | Se alerta foi encaminhado para o fnde |
| cgu | Se alerta foi encaminhado para a cgu |
| inspection_last_updated | última atualização do alerta. Se respondido é a data da ultima resposta, se não respondido é a data do último encaminhamento |
| user_id        | id do usuário que criou o alerta* |
| project_id     | id da obra |
| funded_by      | responsável pela execução da obra, se prefeitura == 1, se governo estadual == 2 | 
| location_city  | localização da obra |
| state          | localização da obra |
|inspection_status| se alerta foi respondido ou não |
|entity_who_answered| entidade que respondeu o alerta |
|answer_content| conteúdo da resposta |
|valid_answer| se a resposta é válida ou não. Foram consideradas não válidas respostas que pediam o redirecionamento do alerta para outro órgão |

