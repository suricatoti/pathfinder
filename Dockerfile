cat <<EOF > Dockerfile
# Dockerfile para o Lab PATHFINDER (Busca Avançada)
# Este lab é 100% focado em comandos 'find' e 'which'.

FROM docker.io/parrotsec/core:latest

# 1. Instalar pacotes essenciais (incluindo fallocate e xxd)
RUN apt-get update && apt-get install -y \
    openssh-server iproute2 net-tools nano vim sudo man-db gcc fallocate xxd

# 2. Configurar SSH, Usuário e Senha
# Usuário: dome-scout / Senha: Oper@tion_Sh3ll!
RUN mkdir -p /var/run/sshd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    useradd -m -s /bin/bash dome-scout && \
    echo "dome-scout:Oper@tion_Sh3ll!" | chpasswd

# 3. SETUP DAS QUESTÕES

# Q1: Last Modified File (Timestamp)
# Cria os arquivos e garante que 'apt.extended_states.0' tenha o timestamp mais recente.
RUN mkdir -p /var/backups && \
    echo "Apt Extended Data" > /var/backups/apt.extended_states.0 && \
    echo "Shadow backup" > /var/backups/shadow.bak && \
    echo "Old file" > /var/backups/old_file.txt && \
    touch /var/backups/apt.extended_states.0

# Q2: Contagem de Arquivos .bak (Garantir exatamente 4)
# Criamos 4 arquivos .bak em locais diferentes do filesystem.
RUN touch /home/dome-scout/config.bak && \
    touch /etc/security_backup.bak && \
    touch /tmp/temp.bak && \
    touch /var/log/audit.bak 
# Contagem total = 4

# Q3: Binary Path (xxd)
# O pacote 'xxd' já foi instalado no passo 1. O caminho será /usr/bin/xxd

# 4. Copiar script de entrada (entrypoint.sh)
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 22
ENTRYPOINT ["/entrypoint.sh"]
EOF
