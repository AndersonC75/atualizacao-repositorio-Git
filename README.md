# Automação de Atualização de Repositórios Git

## Descrição
Script em Bash para automatizar a atualização de múltiplos repositórios Git através do comando `git pull`. O script define projetos (como DEVOPS e DISCORD) e seus respectivos repositórios, iterando sobre cada um para mantê-los atualizados.

## Recursos
- Suporte a múltiplos projetos e repositórios
- Logging com timestamp das operações
- Validação de existência de diretórios
- Tratamento de erros em operações Git
- Configuração customizável através de arrays
- Checagem do diretório de trabalho

## Requisitos
- Bash 4.0+
- Git instalado e configurado
- Acesso aos repositórios (SSH keys configuradas)
- Permissões de escrita no diretório de logs

## Estrutura de Pastas Recomendada
```
~/projetos/
├── devops/
│   ├── repo1/
│   ├── repo2/
│   └── repo3/
├── discord/
│   ├── bot-repo/
│   └── config-repo/
└── logs/
    └── git-update.log
```

## Configuração
1. Clone o repositório
2. Edite o script para definir seus projetos e repositórios
3. Configure a variável `WORKDIR` para o diretório base dos projetos
4. Defina o caminho do arquivo de log em `LOG_FILE`
5. Torne o script executável: `chmod +x atualizacao-repositorio-Git.sh`

## Uso
### Execução Manual
```bash
./atualizacao-repositorio-Git.sh
```

### Agendamento via Cronjob
Para executar automaticamente a cada 30 minutos:
```bash
# Editar crontab
crontab -e

# Adicionar linha:
*/30 * * * * /caminho/para/atualizacao-repositorio-Git.sh
```

Para execução diária às 2:00 AM:
```bash
0 2 * * * /caminho/para/atualizacao-repositorio-Git.sh
```

## Logs
O script gera logs detalhados com:
- Timestamp de cada operação
- Status de sucesso/erro para cada repositório
- Detalhes dos erros encontrados
- Estatísticas de repositórios processados

### Visualizar Logs
```bash
# Ver últimas 20 linhas
tail -20 ~/projetos/logs/git-update.log

# Monitorar em tempo real
tail -f ~/projetos/logs/git-update.log

# Buscar erros
grep -i error ~/projetos/logs/git-update.log
```

## Dicas
- **Performance**: Configure SSH keys para evitar prompts de senha
- **Monitoramento**: Use `logrotate` para gerenciar o tamanho dos logs
- **Backup**: Faça backup dos repositórios importantes antes de automatizar
- **Teste**: Execute manualmente antes de agendar via cron
- **Notificações**: Configure alertas por email em caso de falhas críticas

## Exemplo de Saída
```
[2025-09-21 01:02:30] Iniciando atualização dos repositórios...
[2025-09-21 01:02:31] Projeto: DEVOPS
[2025-09-21 01:02:32] ✓ repo1 atualizado com sucesso
[2025-09-21 01:02:35] ✗ repo2 falhou: remote: Repository not found
[2025-09-21 01:02:40] ✓ repo3 atualizado com sucesso
[2025-09-21 01:02:41] Resumo: 2 sucessos, 1 falha
```

## Contribuição
1. Faça fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/nova-funcionalidade`)
3. Commit suas mudanças (`git commit -am 'Adiciona nova funcionalidade'`)
4. Push para a branch (`git push origin feature/nova-funcionalidade`)
5. Abra um Pull Request

## Licença
Este projeto está sob a licença MIT. Veja o arquivo LICENSE para mais detalhes.
