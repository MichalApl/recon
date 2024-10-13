#!/bin/bash

target=$1
BLUE="\033[1;34m"
GREEN="\033[1;32m"
RED="\033[1;31m"
RESET="\033[0m"

# Function to handle Ctrl+C for default sections
function default_ctrl_c() {
    echo -e "${RED}Script interrupted.${RESET}"
    exit 1
}

# Ctrl+C handler for ffuf scan
function ffuf_ctrl_c() {
    echo -e "${RED}Scan interrupted by user.${RESET}"
    echo -e "${BLUE}Would you like to filter by size before stopping the scan? [y/n]${RESET}"
    read filter_input

    if [[ "$filter_input" == "y" || "$filter_input" == "Y" ]]; then
        echo -e "${BLUE}Please specify the file size you would like to filter out: ${RESET}"
        read filter_size

        # Relaunch ffuf excluding the specified size
        echo -e "${BLUE}Relaunching ffuf excluding Size: $filter_size ${RESET}"
        ffuf -u https://$target/FUZZ -w $wordlist -fs $filter_size -o $directories_path/filtered_ffuf.txt
    else
        echo -e "${RED}Continuing with the next part of the script...${RESET}"
    fi

    # Reset Ctrl+C to default behavior
    trap default_ctrl_c INT
    continue_script
}

function continue_script() {
    echo -e "${GREEN}
╭────────────────────────────────────────────────────────╮
│           🕵️ Enumerating Subdomains... 🕵️             | 
╰────────────────────────────────────────────────────────╯
${RESET}"

    echo -e "${BLUE} 🔎 Launching subfinder... ${RESET}" 
    subfinder -v -d $target -o $subdomain_path/found_subdomains.txt

    echo -e "${GREEN}\n 🔎 Detecting alive subdomains... ${RESET}" 
    cat $subdomain_path/found_subdomains.txt | sort -u | httprobe -prefer-https | grep https | sed 's/https\?:\/\///' | tee -a $subdomain_path/alive_subdomains.txt

    echo -e "${GREEN} Subdomain enumeration completed. Results saved to $subdomain_path/alive_subdomains.txt ${RESET}"
}

if [ "$1" == "" ]; then
    echo -e "${RED} Invalid syntax!${RESET}"
    echo -e "${BLUE} Please provide a valid target.${RESET}"
    echo -e "${RED}
╭────────────────────────────────────────────────────────╮
│         ⚠️  Example: ./recon.sh target.com  ⚠️         │
╰────────────────────────────────────────────────────────╯
${RESET}"
    exit 1
else
    echo -e "${GREEN}   
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠁⠈⠻⢿⠿⠋⠀⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠈⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣶⣶⣶⣶⣶⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⠿⠿⠿⠿⠿⠟⠛⠉⠁⠀⠀⠉⠙⠛⠛⠛⠛⢛⣛⣉⣁⣀⣈⣉⣙⣛⣿⣿⣿⣿⣿⣿
⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⠀⠀⠀⠼⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿
⣿⣿⣿⣿⣿⣿⠿⠶⠶⣶⡶⣶⣴⣤⣤⣤⣤⣤⣤⣶⣶⣶⡶⠶⠿⢿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⡿⠋⠁⠀⠀⠀⠹⣆⡀⠀⠀⣠⣶⣶⣄⠀⠀⢀⣾⡇⠀⠀⠀⠈⠻⣿⣿⣿⣿
⣿⣿⣯⣤⣄⣀⣀⠀⠀⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠀⠀⢀⣀⣀⣤⣤⣽⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⠟⠃⠀⠙⢿⣿⣿⣿⣿⣿⡿⠋⠁⠀⠛⢿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣥⣀⡀⠀⠀⠀⠙⢿⣿⣿⠏⠀⠀⠀⠀⣀⣠⣽⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣄⡀⠀⣸⠃⠀⢀⣤⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡏⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
╭──────────────────────────────╮
│    🔎  Recon has begun 🔎    │   
╰──────────────────────────────╯ 
${RESET}"

    subdomain_path=$target/subdomains
    scan_path=$target/scans
    directories_path=$target/directories
    pocs_path=$target/PoCs

    if [ ! -d "$target" ]; then
        mkdir $target
    fi

    if [ ! -d "$subdomain_path" ]; then
        mkdir $subdomain_path
    fi

    if [ ! -d "$scan_path" ]; then
        mkdir $scan_path
    fi

    if [ ! -d "$directories_path" ]; then
        mkdir $directories_path
    fi

    if [ ! -d "$pocs_path" ]; then
        mkdir $pocs_path
    fi

    echo -e "${GREEN}
╭────────────────────────────────────────────────────────╮
│      🕵️ Investigating the SSL Certificate... 🕵️        │
╰────────────────────────────────────────────────────────╯
${RESET}"

    echo -e "${BLUE} 🔎 Launching sslscan... ${RESET}"
    sslscan $target | tee -a $scan_path/sslscan.txt

    echo -e "${GREEN}
╭────────────────────────────────────────────────────────╮
│            🕵️ Detecting Technologies... 🕵️             │
╰────────────────────────────────────────────────────────╯
${RESET}"

    echo -e "${BLUE} 🔎 Launching whatweb... ${RESET}"
    whatweb -a 3 https://$target | tee -a $scan_path/whatweb.txt

    echo -e "${GREEN}
╭────────────────────────────────────────────────────────╮
│               🕵️ Detecting Firewall... 🕵️              │
╰────────────────────────────────────────────────────────╯
${RESET}"

    echo -e "${BLUE} 🔎 Launching wafw00f... ${RESET}"
    wafw00f $target -o $scan_path/wafw00f.txt    

    echo -e "${GREEN}
╭────────────────────────────────────────────────────────╮
│          🕵️ Investigating open ports... 🕵️             │
╰────────────────────────────────────────────────────────╯
${RESET}"

    echo -e "${BLUE} 🔎 Launching nmap... ${RESET}"
    sudo nmap $target -sSVC -Pn -p- -v -oN $scan_path/nmap.txt

    echo -e "${GREEN}
╭────────────────────────────────────────────────────────╮
│ 🕵️ Fetching known URLs from the Wayback Machine... 🕵️  │
╰────────────────────────────────────────────────────────╯
${RESET}"

    echo -e "${BLUE} 🔎 Launching gau... ${RESET}"
    gau $target --o $scan_path/gau.txt

    echo -e "${GREEN}
╭────────────────────────────────────────────────────────╮
│         🕵️ Looking for vulnerabilities... 🕵️           |
╰────────────────────────────────────────────────────────╯
${RESET}"

    echo -e "${BLUE} 🔎 Launching nuclei... ${RESET}"
    nuclei -target $target -o $scan_path/nuclei.txt

    echo -e "${GREEN}
╭────────────────────────────────────────────────────────╮
│           🕵️ Enumerating Directories... 🕵️             |
╰────────────────────────────────────────────────────────╯
${RESET}"

    echo -e "${BLUE} ⚠️ The default wordlist being used is 'directory-list-lowercase-2.3-medium.txt', located at '/usr/share/seclists/Discovery/Web-Content/'. ${RESET}"
    echo -e "${BLUE} ⚠️ If you encounter any errors, ensure that the wordlist exists at the specified path. If not, install Seclists or update the path accordingly. You can also choose to use a different wordlist. ${RESET}"
    echo -e "${BLUE} ⚠️ Would you like to use a different wordlist? [y/n] ${RESET}"
    read user_input

    if [[ "$user_input" == "y" || "$user_input" == "Y" ]]; then
        while true; do
            echo -e "${BLUE} Please specify the wordlist's name including the full path: ${RESET}"
            read custom_wordlist

            if [ -f "$custom_wordlist" ]; then
                wordlist=$custom_wordlist
                echo -e "${BLUE} 🔎 Launching ffuf with your custom wordlist... ${RESET}"
                trap ffuf_ctrl_c INT  # Set the Ctrl+C handler for the ffuf part
                ffuf -u https://$target/FUZZ -w $custom_wordlist -o $directories_path/ffuf.txt
                break
            else
                echo -e "${RED} The specified wordlist does not exist. Please try again. ${RESET}"
            fi
        done

    elif [[ "$user_input" == "n" || "$user_input" == "N" ]]; then
        wordlist="/usr/share/seclists/Discovery/Web-Content/directory-list-lowercase-2.3-medium.txt"
        echo -e "${BLUE} 🔎 Launching ffuf with the default wordlist... ${RESET}"
        trap ffuf_ctrl_c INT  # Set the Ctrl+C handler for the ffuf part
        ffuf -u https://$target/FUZZ -w $wordlist -o $directories_path/ffuf.txt

    else
        echo -e "${RED} Invalid input. Please type 'y' / 'n'. ${RESET}"
        exit 1
    fi

    # Reset Ctrl+C to default after ffuf scan
    trap default_ctrl_c INT

    # Continue the rest of the script
    continue_script
fi
