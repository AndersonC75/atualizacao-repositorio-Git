#!/bin/bash

#==============================================================================
# Script de Automatização de Atualização de Repositórios Git
# Versão: 2.0
# Autor: AndersonC75
# Data: 2025-09-21
#==============================================================================

set -euo pipefail  # Modo strict: para em erros, variáveis não definidas e pipes com falha

#==============================================================================
# CONFIGURAÇÕES
#==============================================================================

# Diretório base dos projetos (DEVE ser definido)
WORKDIR="${WORKDIR:-$HOME/projetos}"

# Arquivo de log
LOG_FILE="${LOG_FILE:-$WORKDIR/logs/git-update.log}"

# Arrays de configuração dos projetos e repositórios
declare -A PROJECT_REPOS=(
    ["devops"]="analytics demo infrastructure monitoring"
    ["discord"]="dev-bot bot-suporte config-manager"
    ["webapp"]="frontend backend api-gateway"
)

# Contadores para estatísticas
SUCCESS_COUNT=0
FAILURE_COUNT=0
TOTAL_REPOS=0

#==============================================================================
# FUNÇÕES
#==============================================================================

# Função para logging com timestamp
log_message() {
    local level="$1"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    echo "[$timestamp] [$level] $message" | tee -a "$LOG_FILE"
}

# Função para verificar se um diretório existe
check_directory() {
    local dir="$1"
    
    if [[ ! -d "$dir" ]]; then
        log_message "ERROR" "Diretório não encontrado: $dir"
        return 1
    fi
    return 0
}

# Função para executar git pull com tratamento de erro
execute_git_pull() {
    local repo_path="$1"
    local repo_name="$2"
    
    if ! check_directory "$repo_path"; then
        log_message "ERROR" "Repositório $repo_name: diretório não existe"
        ((FAILURE_COUNT++))
        return 1
    fi
    
    log_message "INFO" "Atualizando repositório: $repo_name"
    
    if cd "$repo_path" 2>/dev/null; then
        if git pull 2>&1 | tee -a "$LOG_FILE"; then
            log_message "SUCCESS" "✓ $repo_name atualizado com sucesso"
            ((SUCCESS_COUNT++))
            return 0
        else
            log_message "ERROR" "✗ Falha ao atualizar $repo_name"
            ((FAILURE_COUNT++))
            return 1
        fi
    else
        log_message "ERROR" "✗ Não foi possível acessar o diretório $repo_path"
        ((FAILURE_COUNT++))
        return 1
    fi
}

# Função para mostrar estatísticas finais
show_summary() {
    log_message "INFO" "==========================================="
    log_message "INFO" "RESUMO DA EXECUÇÃO"
    log_message "INFO" "Total de repositórios: $TOTAL_REPOS"
    log_message "INFO" "Sucessos: $SUCCESS_COUNT"
    log_message "INFO" "Falhas: $FAILURE_COUNT"
    log_message "INFO" "Taxa de sucesso: $(( (SUCCESS_COUNT * 100) / TOTAL_REPOS ))%"
    log_message "INFO" "==========================================="
}

# Função para validar pré-requisitos
validate_requirements() {
    # Verificar se git está instalado
    if ! command -v git >/dev/null 2>&1; then
        log_message "ERROR" "Git não está instalado ou não está no PATH"
        exit 1
    fi
    
    # Verificar se WORKDIR está definido e existe
    if [[ -z "$WORKDIR" ]]; then
        log_message "ERROR" "Variável WORKDIR não está definida"
        exit 1
    fi
    
    if ! check_directory "$WORKDIR"; then
        log_message "ERROR" "Diretório de trabalho não existe: $WORKDIR"
        exit 1
    fi
    
    # Criar diretório de logs se não existir
    local log_dir
    log_dir=$(dirname "$LOG_FILE")
    if [[ ! -d "$log_dir" ]]; then
        if ! mkdir -p "$log_dir"; then
            echo "Erro: Não foi possível criar o diretório de logs: $log_dir"
            exit 1
        fi
    fi
    
    # Verificar permissões de escrita no arquivo de log
    if ! touch "$LOG_FILE" 2>/dev/null; then
        echo "Erro: Sem permissão para escrever no arquivo de log: $LOG_FILE"
        exit 1
    fi
}

#==============================================================================
# FUNÇÃO PRINCIPAL
#==============================================================================

main() {
    # Validar pré-requisitos
    validate_requirements
    
    # Iniciar logging
    log_message "INFO" "Iniciando atualização dos repositórios Git"
    log_message "INFO" "Diretório de trabalho: $WORKDIR"
    log_message "INFO" "Arquivo de log: $LOG_FILE"
    
    # Calcular total de repositórios
    for project in "${!PROJECT_REPOS[@]}"; do
        local repos=(${PROJECT_REPOS[$project]})
        TOTAL_REPOS=$((TOTAL_REPOS + ${#repos[@]}))
    done
    
    log_message "INFO" "Total de repositórios para processar: $TOTAL_REPOS"
    
    # Processar cada projeto
    for project in "${!PROJECT_REPOS[@]}"; do
        log_message "INFO" "Processando projeto: ${project^^}"
        
        # Verificar se o diretório do projeto existe
        local project_path="$WORKDIR/$project"
        if ! check_directory "$project_path"; then
            log_message "WARN" "Diretório do projeto não encontrado: $project_path. Pulando..."
            continue
        fi
        
        # Converter string de repositórios em array
        local repos=(${PROJECT_REPOS[$project]})
        
        # Processar cada repositório do projeto
        for repo in "${repos[@]}"; do
            local repo_path="$project_path/$repo"
            execute_git_pull "$repo_path" "$project/$repo"
        done
    done
    
    # Mostrar resumo
    show_summary
    
    # Retornar ao diretório original
    cd "$WORKDIR" || {
        log_message "ERROR" "Não foi possível retornar ao diretório de trabalho"
        exit 1
    }
    
    # Exit code baseado no resultado
    if [[ $FAILURE_COUNT -eq 0 ]]; then
        log_message "INFO" "Script concluído com sucesso!"
        exit 0
    else
        log_message "WARN" "Script concluído com algumas falhas. Verifique o log para detalhes."
        exit 1
    fi
}

#==============================================================================
# EXECUÇÃO
#==============================================================================

# Verificar se o script está sendo executado diretamente (não sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
