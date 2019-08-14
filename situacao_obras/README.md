### Situação das obras

#### Arquivos: 

* ["obras_inicio_projeto.Rdata"](https://github.com/voigtjessica/tadepe-tdp_impact2/blob/master/situacao_obras/obras_inicio_projeto.Rdata) - Situação das obras no início do projeto
* ["obras_fim_fase_1.Rdata"](https://github.com/voigtjessica/tadepe-tdp_impact2/blob/master/situacao_obras/obras_fim_fase_1.Rdata) - Situação das obras no final da primeira etapa do projeto, em março de 2018:
* ["obras_antes_inicio_seg_fase.Rdata"](https://github.com/voigtjessica/tadepe-tdp_impact2/blob/master/situacao_obras/obras_antes_inicio_seg_fase.Rdata)- Situação das obras antes do início da segunda fase do projeto (09/2018)
* ["obras_fim_seg_fase.Rdata"](https://github.com/voigtjessica/tadepe-tdp_impact2/blob/master/situacao_obras/obras_fim_seg_fase.Rdata) - Situação das obras no fim da segunda fase do projeto (13/02/2019)

### Codebook:

| Nome variável      | Descrição   |
| :-------------: |:-------------:|
| id     | Id da obra, gerado pelo FNDE |
| nome| Nome da obra, de acordo com o acordo firmado com o FNDE (pode ser que a escola / creche tenha adotado um outro nome ) |
| situacao | Situação oficial da obra, de acordo com o FNDE (ver abaixo) |
| municipio | Município onde se localiza a obra |
| uf | UF onde se localiza a obra |
| cep | CEP onde se localiza a obra, de acordo com ente executor |
| logradouro | Logradouro onde se localiza a obra , de acordo com ente executor |
| bairro | Bairro onde se localiza a obra , de acordo com ente executor |
| percentual_de_execucao | Percentual de execução da obra, de acordo com o ente executor |
| data_prevista_de_conclusao_da_obra | Data prevista de conclusão da obra oficial |
| tipo_do_projeto | Projeto da obra |                   
| rede_de_ensino_publico | Rede de ensino público para o qual a obra irá servir |            
| nome_da_entidade | Entidade executora |
| visivel_no_app | Se a obra atendia aos critérios para estar visível no app ou foi inserida manualmente, se sim == 1, se não == 0 (ver abaixo) |
| grupo_controle | Se a obra fazia parte do grupo controle no momento em que planilha foi extraída |  
| campanha_tdp* | Se obra participou da campanha do TDP. Se sim == 1, se não == 0 |
| grupo_controle_app* | Se obra fazia parte do grupo controle no aplicativo no momento em que planilha foi extraída |
| grupo_controle_campanha* | Se a obra fez parte do grupo controle da campanha |

*Apenas * nos arquivos da segunda fase*

### Observações

#### Situação

Pode assumir os seguintes valores:

* Concluída
* Inacabada : obra iniciada que não será mais executada (abandonada)
* Obra Cancelada: obra não iniciada que não será mais executada (pode ter tido transferência mas não houve uso do dinheiro) 
* Planejamento pelo proponente: fase pré-licitação, de elaboração / escolha do projeto
* Execução: obra com execução normal
* Paralisada: obra iniciada, paralisada e que deverá ser retomada pelo ente executor                  
* Licitação: Obra está sendo licitada
* Contratação: Licitação já foi realizada e o contrato está sendo feito
* Em Reformulação: Quando há interrupção do contrato. Nunca ficou claro se as obras com esse status já teriam sido iniciadas ou se obras não iniciadas também poderiam ter esse status.

É importante frisar que essa classificação é oficial e apenas no caso "em reformulação" admite a existência de um segundo contrato para uma mesma obra. Isso foi abordado no [relatório da Transparência Brasil em 2017](https://www.transparencia.org.br/downloads/publicacoes/RelatorioTadePe23082017.pdf) :

*"A Transparência Brasil constatou, entretanto, que das 2.477 obras em reformulação, licitação ou planejamento pelo proponente, 756 (31%) são obras que já foram iniciadas no passado, tiveram que ser interrompidas e voltaram para fases iniciais pré-construção. Portanto, seria mais preciso que essas obras fossem classificadas como inacabadas ou paralisadas e que estão para serem retomadas."*

### Visível no app:

Para uma obra estar visível no app TDP, ela precisa ter o cronograma conhecido e não estar concluída ou cancelada. Na primeira fase, estavam visíveis apenas aquelas que tinham um dos seguintes projetos:

* Espaço educativo 12 salas
* Espaço educativo 1 sala
* Espaço educativo 2 salas
* Espaço educativo 4 salas
* Espaço educativo 6 salas
* Projeto 1 Convencional
* Projeto 2 Convencional

Esses projetos possuem cronogramas padronizados, e por isso conhecidos.
Já na segunda fase do projeto foram adicionados também cronogramas solicitados via LAI. A coluna visivel_no_app dá conta tanto dos cronogramas padronizados quanto daqueles obtidos via LAI.
