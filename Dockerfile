# Dockerfile para o Lab PATHFINDER (Busca Avançada e Localização)

FROM docker.io/parrotsec/core:latest

# 1. Instalar pacotes essenciais (xxd está na lista)
RUN apt-get update && apt-get install -y     openssh-server iproute2 net-tools nano vim sudo man-db gcc xxd

# 2. Configurar SSH, Usuário e Senha
# Usuário: dome-scout / Senha: Oper@tion_Sh3ll!
RUN mkdir -p /var/run/sshd &&     sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config &&     sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config &&     useradd -m -s /bin/bash dome-scout &&     echo "dome-scout:Oper@tion_Sh3ll!" | chpasswd

# 3. SETUP DAS QUESTÕES

# Q1: Last Modified File (Timestamp)
# Cria os arquivos e garante que 'apt.extended_states.0' tenha o timestamp mais recente.
RUN mkdir -p /var/backups &&     echo "Apt Extended Data" > /var/backups/apt.extended_states.0 &&     echo "Shadow backup" > /var/backups/shadow.bak &&     echo "Old file" > /var/backups/old_file.txt &&     touch /var/backups/apt.extended_states.0

# Q2: Contagem de Arquivos .bak (Garantir exatamente 4)
# Criamos 4 arquivos .bak em locais diferentes do filesystem para a busca global.
RUN touch /home/dome-scout/config.bak &&     touch /etc/security_backup.bak &&     touch /tmp/temp.bak &&     touch /var/log/audit.bak 

# Q3: Busca por Tamanho e Data (00-mesa-defaults.conf)
# Cria um arquivo de 26KB (26 * 1024 bytes) usando 'dd' para ser universal.
RUN dd if=/dev/zero of=/etc/00-mesa-defaults.conf bs=1K count=26 && touch -d "2020-04-01" /etc/00-mesa-defaults.conf

# Q4: Binary Path (xxd)
# O pacote 'xxd' já foi instalado no passo 1.

# 4. Copiar script de entrada (entrypoint.sh deve existir)
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 22
ENTRYPOINT ["/entrypoint.sh"]
