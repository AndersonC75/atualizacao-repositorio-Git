automatizacao-atualizacao-repositorio-Git
O script define dois projetos, "DEVOPS" e "DISCORD".
Para cada projeto, há um conjunto de repositórios associados.
O script itera sobre cada projeto, converte o nome do projeto para minúsculas e adiciona ao currentArray.
Dependendo do projeto, o script navega para cada repositório correspondente e executa git pull para atualizar o repositório.
O script lida com os diretórios de trabalho e volta para o diretório principal após atualizar cada repositório. 
