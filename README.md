# 🌐 Projeto Linux – Servidor Web com Monitoramento e Alerta no Discord

Este projeto ensina **passo a passo**, de forma simples, como criar um servidor web no **Ubuntu** usando o **Nginx**, configurar uma página HTML e montar um sistema de **monitoramento automatizado** que envia alertas para o **Discord** e reinicia o servidor caso ele pare de funcionar.

> 🧑‍💻 Mesmo que você nunca tenha usado Linux, este guia foi feito para ser seguido sem conhecimento prévio.

---

## 📌 O que vamos aprender
- Instalar e configurar um servidor Nginx no Linux.
- Criar e editar uma página HTML simples.
- Configurar um Webhook no Discord para receber alertas.
- Criar um script em Bash para monitorar o servidor.
- Automatizar o script para rodar a cada 1 minuto com o **crontab**.
- Testar o sistema e ver o servidor se recuperar sozinho.

---

## 🛠 Pré-requisitos
- Ter o **Ubuntu** instalado (Desktop ou Server).
- Conexão com a internet.
- Uma conta no Discord.
- Máquina virtual ou computador real rodando Linux.

---

## 🚀 Passo a Passo

### 1️⃣ Alterar layout do teclado para ABNT2 (opcional)
Entre nas opções, vá até teclado e mude para Português (Isso irá facilitar a digitação de comandos no futuro.)
![Mudar layout do teclado](/images/Mudar%20layout%20do%20teclado%20.png)

---

### 2️⃣ Verificar o IP para acessar o servidor
Este IP será usado para acessar o site localmente pelo navegador.
```bash
ip a
```
![Verificar o IP](/images/Verificar%20o%20IP%20para%20entrar%20no%20site%20local.png)

---

### 3️⃣ Instalar o Nginx
Atualize os pacotes e instale o Nginx:
```bash
sudo apt update
sudo apt install nginx
```
![Instalar NGINX](/images/Instalar%20NGINX.png)

---

### 4️⃣ Iniciar o Nginx e verificar se está rodando
```bash
sudo systemctl enable nginx
sudo systemctl start nginx
sudo systemctl status nginx
```
![Iniciar e verificar NGINX](/images/Iniciar%20NGINX%20e%20Ver%20se%20est%C3%A1%20rodando.png)

---

### 5️⃣ Instalar o curl (para o script funcionar)
```bash
sudo apt install curl -y
```
![Instalar o curl](/images/Instalar%20o%20curl.png)

---

### 6️⃣ Editar a página inicial do Nginx
```bash
sudo nano /var/www/html/index.nginx-debian.html
```
![Editar Site NGINX](/images/Editar%20Site%20NGINX.png)

---

### 7️⃣ Criar HTML e CSS personalizados (opcional)
Você pode adicionar HTML e CSS do jeito que você preferir, para deixar a página mais bonita.  
![HTML e CSS do site](/images/HTML%20e%20CSS%20do%20site%20.png)

---

### 8️⃣ Visualizar seu site no navegador
Acesse pelo IP da máquina:
```
http://SEU_IP
```
![Meu site](/images/Meu%20site.png)

---

### 9️⃣ Criar Webhook no Discord
- Vá até o canal desejado → **Configurações do Canal** → **Integrações** → **Webhooks** → **Novo Webhook**.
- Copie a **URL**.  
![Discord](/images/webhook.png)

---

### 🔟 Criar o Script de Monitoramento e Alertas no Discord
```bash
sudo nano /home/SeuUsuário/monitor_nginx.sh
```
Cole:
```bash
#!/bin/bash

URL="http://localhost"
LOGFILE="/home/tata/monitoramento.log"
WEBHOOK_URL="url do webhook"

if /usr/bin/curl -s --head --request GET "$URL" | /bin/grep "200 OK" > /dev/null
then
    echo "$(date): O site está no ar" >> $LOGFILE
else
    echo "$(date): O site está fora do ar, tentando restabelecer..." >> $LOGFILE

    # Alerta no Discord
   curl  -H "Content-Type: application/json" \
         -X POST \
         -d '{"content": "O servidor está fora do ar! Tentando restabelecer..."}' \
        "$WEBHOOK_URL"

    # Reinicia o servidor Nginx
    sudo systemctl restart nginx
   curl  -H "Content-Type: application/json" \
         -X POST \
         -d '{"content": "O servidor já foi restabelecido!"}' \
         "$WEBHOOK_URL"

    echo "$(date): Nginx estabilizado com sucesso" >> $LOGFILE
fi
```
Dar permissão de execução:
```bash
sudo chmod +x /usr/local/bin/monitor_nginx.sh
```
![Criação do Script](/images/Cria%C3%A7%C3%A3o%20do%20Script.png)

---


### 1️⃣2️⃣ Configurar o script para rodar a cada 1 minuto
```bash
sudo crontab -e
```
Adicione:
```
* * * * * /usr/local/bin/monitor_nginx.sh
```
![Chamando o Crontab](/images/Chamando%20o%20Crontab%20.png)  
![Crontab Automatização](/images/crontab%20(Automatiza%C3%A7%C3%A3o%20de%20Script).png)

---

### 1️⃣3️⃣ Testar a falha no servidor
Pare o Nginx:
```bash
sudo systemctl stop nginx
```
Aguarde 1 minuto e veja:
- Alerta no Discord.
- Nginx reiniciado automaticamente.  
![Site OFF](/images/Site%20OFF.png)  
![Alerta no Discord](/images/Discord.png)

---

## 📜 Logs do Monitoramento
Todos os eventos ficam registrados em:
```bash
cat /var/log/monitoramento.log
```
![Script NGINX](/images/??.png)

---
