
# Penetration Testing Recon Automation Script

This script automates the reconnaissance process for penetration testing by leveraging multiple tools to gather information about the target, including subdomain enumeration, SSL certificate scanning, technology detection, firewall detection, port scanning, and directory brute-forcing. The script also includes handling for interruptions and filtering options during directory enumeration.

## Features
- **Subdomain Enumeration** using `subfinder` and `httprobe`
- **SSL Certificate Investigation** using `sslscan`
- **Technology Detection** using `whatweb`
- **Firewall Detection** using `wafw00f`
- **Port Scanning** using `nmap`
- **URL Gathering** from the Wayback Machine with `gau`
- **Vulnerability Detection** using `nuclei`
- **Directory Enumeration** with `ffuf`, including custom wordlist options

## Installation

To run this script, ensure you have the following tools installed:

### Prerequisites
1. **Operating System**: This script is intended for Linux-based systems. Kali Linux is recommended.
2. **Bash**: The script is written in Bash and requires a Bash shell to execute.

### Required Tools
Install the following tools before running the script:

```bash
sudo apt update && sudo apt install -y subfinder httprobe sslscan whatweb wafw00f nmap gau nuclei ffuf
```

Additionally, ensure you have the **SecLists** wordlists for directory brute-forcing. You can install them as follows:

```bash
sudo apt install seclists
```

### Clone the Repository
Clone this repository to your local machine:

```bash
git clone https://github.com/MichalApl/recon.git
cd recon
```

## Usage

### Syntax

```bash
./recon.sh <target>
```

### Example

```bash
./recon.sh example.com
```

This will begin the recon process on `example.com`.

### Directory Structure

The results are saved in organized directories under the target's name:

```text
<target>/
├── subdomains/
│   ├── found_subdomains.txt
│   └── alive_subdomains.txt
├── scans/
│   ├── sslscan.txt
│   ├── whatweb.txt
│   ├── wafw00f.txt
│   ├── nmap.txt
│   └── nuclei.txt
└── directories/
    ├── ffuf.txt
    └── filtered_ffuf.txt
```

### Custom Wordlist for Directory Brute-Forcing

You can specify a custom wordlist for the `ffuf` directory enumeration step. If you choose not to specify a wordlist, the default wordlist (`/usr/share/seclists/Discovery/Web-Content/directory-list-lowercase-2.3-medium.txt`) will be used.

### Interrupt Handling

The script handles interruptions during scans. For example, during a `ffuf` scan, if you press `Ctrl+C`, you will have the option to filter the results by file size before stopping the scan.
