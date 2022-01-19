#!/usr/bin/sh

banner() {
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

            \033[0;31m[\033[0;37mVersion 2.0\033[0;31m]

'
}

remove_login() {
    echo > /var/log/wtmp
    echo > /var/log/btmp
    echo > /var/log/lastlog
}

bash_history() {
    for bash_history in $(find / -name ".bash_history" 2>/dev/null)
        do
            echo > $bash_history
    done
}

logs_f() {
    for log_f in $(find / -name "*\.log\.*" 2>/dev/null;find / -name "*\.log\.*\.*" 2>/dev/null;find / -name "*\.*\.log\.*" 2>/dev/null)
        do
            echo > $log_f
    done
}

main() {
    banner
    sleep 1
    printf '\n\033[0;34m[*] \033[0;37mClearing system login logs\n'
    sleep 1
    remove_login
    printf '\033[0;32m[+] \033[0;37mLogin logs successfully deleted!\n'
    sleep 1
    printf '\n\033[0;34m[*] \033[0;37mClearing system histories\n'
    bash_history
    printf '\n\n\033[0;32m[+] \033[0;37mSystem history deleted successfully!\n'
    sleep 1
    printf '\n\033[0;34m[*] \033[0;37mDeleting content inside log files'
    logs_f
    printf '\n\n\033[0;32m[+] \033[0;37mLog files cleared successfully!\n'
    printf '\n\033[0;34m[*] \033[0;37mClear command history "history -c"\n'
}

if [[ $EUID -ne 0 ]]; then
   printf "\033[0;34m[*] \033[0;37mYou are not running Nullog as root, for that reason only some logs that you have permission will be deleted. Do you really want to continue? [Press ENTER]" 
   read
   main
fi
