#!/bin/bash

# Declarando as variaveis
# ---------------------------------------------------------------------------------------------
APP_NAME="ninjachoice"
APP_PATH="/var/www/rails/$APP_NAME"

# Criando pastas para armazenar pids e logs
# -------------------------------
mkdir -p "$APP_PATH"/shared/pids
mkdir -p "$APP_PATH"/shared/log

# Acesando a pasta do projeto
# Copiando o arquivo de database
# Chama o comando bundle install
# ---------------------------------------------------------------------------------------------
cd "$APP_PATH"/current
# cp /root/database.yml "$APP_PATH"/current/confg
bundle

# Carrega o ambiente de producao e gera os assets
# ---------------------------------------------------------------------------------------------
export RAILS_ENV=production
bundle exec rake db:migrate
bundle exec rake assets:precompile
bundle exec rake assets:clean

# Mata o pid do unicorn responsavel por essa aplicacao
# ---------------------------------------------------------------------------------------------
cat "$APP_PATH"/shared/pids/unicorn-"$APP_NAME".pid | awk '{ print $1 }' | xargs kill -9

# Cria um novo processo unicorn paraa aplicacao
# ---------------------------------------------------------------------------------------------
unicorn -c config/unicorn.rb -D -E production