#!/bin/bash
# Define que o script deve ser executado com o interpretador bash

# Definindo arrays para os projetos e seus repositórios correspondentes
PROJECTS[0]="DEVOPS"    # Primeiro projeto é "DEVOPS"
PROJECTS[1]="DISCORD"   # Segundo projeto é "DISCORD"

# Arrays que contêm os nomes dos repositórios para cada projeto
DEVOPS_REPO[0]="analytics"  # Primeiro repositório do projeto "DEVOPS"
DEVOPS_REPO[1]="demo"       # Segundo repositório do projeto "DEVOPS"

DISCORD_REPO[0]="dev-bot"   # Primeiro repositório do projeto "DISCORD"
DISCORD_REPO[1]="bot-suporte" # Segundo repositório do projeto "DISCORD"

# Inicializando um array vazio para uso futuro
currentArray=()  # Cria um array vazio chamado currentArray

# Loop principal para iterar sobre os projetos
for (( a=0; a < ${#PROJECTS[*]}; a++ )); do  # Inicia um loop para percorrer todos os elementos do array PROJECTS
    # Obtendo o nome do projeto atual
    REPO=${PROJECTS[$a]}  # Atribui o valor do projeto atual à variável REPO
    
    # Convertendo o nome do projeto para minúsculas
    DIR_NAME=$(echo $REPO | tr '[:upper:]' '[:lower:]')  # Converte o nome do projeto para minúsculas e armazena em DIR_NAME
    
    # Adicionando o nome do array de repositórios correspondente ao currentArray
    currentArray+=(${REPO}_REPO)  # Adiciona o nome do array de repositórios correspondente ao currentArray
    
    # Verificando se o projeto atual é 'devops'
    if [[ $DIR_NAME == 'devops' ]]; then  # Se DIR_NAME é "devops"
        # Loop para iterar sobre os repositórios do projeto 'devops'
        for (( b=0; b < ${#DEVOPS_REPO[*]}; b++ )); do  # Inicia um loop para percorrer todos os repositórios do array DEVOPS_REPO
            # Mudando para o diretório do repositório e executando git pull
            cd $WORKDIR/$DIR_NAME/${DEVOPS_REPO[b]} || exit 1  # Muda para o diretório do repositório e sai em caso de erro
            git pull  # Executa git pull para atualizar o repositório
            # Voltando para o diretório de trabalho principal
            cd ${WORKDIR} || exit 1  # Volta para o diretório de trabalho principal e sai em caso de erro
        done
    # Verificando se o projeto atual é 'discord'
    elif [[ $DIR_NAME == 'discord' ]]; then  # Se DIR_NAME é "discord"
        # Loop para iterar sobre os repositórios do projeto 'discord'
        for (( c=0; c < ${#DISCORD_REPO[*]}; c++ )); do  # Inicia um loop para percorrer todos os repositórios do array DISCORD_REPO
            # Mudando para o diretório do repositório e executando git pull
            cd $WORKDIR/$DIR_NAME/${DISCORD_REPO[c]} || exit 1  # Muda para o diretório do repositório e sai em caso de erro
            git pull  # Executa git pull para atualizar o repositório
            # Voltando para o diretório de trabalho principal
            cd ${WORKDIR} || exit 1  # Volta para o diretório de trabalho principal e sai em caso de erro
        done
    fi  # Fecha a condição if
done  # Fecha o loop principal
