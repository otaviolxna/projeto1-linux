#!/bin/bash

URL="http://localhost"
LOGFILE="/home/tata/monitoramento.log"
WEBHOOK_URL="SUA_URL"
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
