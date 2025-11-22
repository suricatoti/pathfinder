#!/bin/bash

# Inicia o serviço SSH para permitir o acesso
service ssh start

# Mantém o container rodando indefinidamente em primeiro plano
# Isso é crucial para evitar que o Docker feche após iniciar o SSH
tail -f /dev/null
