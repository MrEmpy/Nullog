#!/bin/sh

SHRED_ARGS="-n 7 -z --force"

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

shred_check() {
    if ! command -v shred &> /dev/null; then
        echo "[-] The 'shred' command was not found. Installing..."
        sudo apt-get update
        sudo apt-get install shred -y
        if [ $? -eq 0 ]; then
            echo "[+] The 'shred' command was installed successfully."
        else
            echo "[-] Error installing 'shred' command. Please check permissions or internet connection."
            exit 1
        fi
    else
        echo "[+] The 'shred' command is already installed."
    fi
}

remove_login() {
    shred $SHRED_ARGS /var/log/wtmp 2>/dev/null
    shred $SHRED_ARGS /var/log/btmp 2>/dev/null
    shred $SHRED_ARGS /var/log/lastlog 2>/dev/null
}

other_logs() {
    shred $SHRED_ARGS /var/log/messages 2>/dev/null
    shred $SHRED_ARGS /var/log/maillog 2>/dev/null
    shred $SHRED_ARGS /var/log/secure 2>/dev/null
    shred $SHRED_ARGS /var/log/syslog 2>/dev/null
    shred $SHRED_ARGS /var/log/dmesg 2>/dev/null

    for mail_f in $(find /var/log/ -name "mail\.*" 2>/dev/null)
        do
            shred $SHRED_ARGS $mail_f 2>/dev/null
    done
}

bash_history() {
    for bash_history in $(find / -name ".bash_history" 2>/dev/null)
        do
            shred $SHRED_ARGS $bash_history 2>/dev/null
    done
}

zsh_history() {
    for zsh_history in $(find / -name ".zsh_history" 2>/dev/null)
        do
            shred $SHRED_ARGS $zsh_history 2>/dev/null
    done
}

mac_root_logs() {

    for mac_root_logs in $(find ~/Library  -name "*.log" 2>/dev/null)
        do
            shred $SHRED_ARGS $mac_root_logs 2>/dev/null
    done
}

mac_normal_logs() {
    
    for mac_normal_logs in $(find /Library  -name "*.log" 2>/dev/null)
        do
            shred $SHRED_ARGS $mac_normal_logs 2>/dev/null
    done
    
}

logs_f() {
    find / -name "*\.log\.*" 2>/dev/null >> .logs
    find / -name "*\.log\.*\.*" 2>/dev/null >> .logs
    find / -name "*\.*\.log\.*" 2>/dev/null >> .logs

    while read log_f
        do
            shred $SHRED_ARGS $log_f 2>/dev/null
            printf "\n\033[0;32m[+] \033[0;37mLog deleted: $log_f"
    done < .logs
    rm -f .logs
}

main() {
    banner
    sleep 1
    shred_check
    printf '\n\033[0;34m[*] \033[0;37mClearing system login logs\n'
    remove_login
    printf '\033[0;32m[+] \033[0;37mLogin logs successfully deleted!\n'
    sleep 1
    printf '\n\033[0;34m[*] \033[0;37mClearing other logs\n'
    other_logs
    printf '\033[0;32m[+] \033[0;37mOther logs successfully deleted!\n'
    sleep 1
    printf '\n\033[0;34m[*] \033[0;37mClearing Bash histories\n'
    bash_history
    printf '\n\033[0;34m[*] \033[0;37mClearing Zsh histories\n'
    zsh_history
    sleep 1
    printf '\n\033[0;34m[*] \033[0;37mClearing Mac root logs\n'
    mac_root_logs()
    sleep 1
    printf '\n\033[0;34m[*] \033[0;37mClearing Mac normal logs\n'
    mac_normal_logs()
    printf '\n\n\033[0;32m[+] \033[0;37mSystem history deleted successfully!\n'
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
