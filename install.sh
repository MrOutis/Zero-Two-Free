#!/bin/bash
# CRÉDITOS: 𖧄 𝐋𝐔𝐂𝐀𝐒 𝐌𝐎𝐃 𝐃𝐎𝐌𝐈𝐍𝐀 𖧄
# Github: https://github.com/Otakump4

# Definindo as cores (ANSI padrão para Termux)
RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
BRIGHTWHITE='\033[1;97m'
NOCOLOR='\033[0m'

enable_colors() {
if [[ -t 1 ]]; then
export TERM="xterm-256color"
fi
}

progress_bar() {
local duration=$1
printf ""
for i in $(seq 1 "$duration"); do
sleep 0.1
printf "."
done
printf "\n"
}

print_banner() {
clear
echo "${YELLOW}"
cat << "EOF"
░██████╗████████╗░█████╗░░░░░░░░████████╗░█████╗░░█████╗░
██╔════╝╚══██╔══╝██╔══██╗░░░░░░░╚══██╔══╝██╔══██╗██╔══██╗
╚█████╗░░░░██║░░░██║░░██║█████╗░░░░██║░░░██║░░██║██║░░██║
░╚═══██╗░░░██║░░░██║░░██║╚════╝░░░░██║░░░██║░░██║██║░░██║
██████╔╝░░░██║░░░╚█████╔╝░░░░░░░░░░██║░░░╚█████╔╝╚█████╔╝
╚═════╝░░░░╚═╝░░░░╚════╝░░░░░░░░░░░╚═╝░░░░╚════╝░░╚════╝░
EOF
echo "${NOCOLOR}\n"
echo "${CYAN}Zero Two Free - Instalação Avançada${NOCOLOR}\n\n"
}

print_msg() {
echo "$1$2$NOCOLOR"
sleep 0.3
}

check_nodejs() {
if command -v node &> /dev/null; then
NODE_VERSION=$(node -v | sed 's/v//g' | cut -d. -f1)
if [ "$NODE_VERSION" -lt 22 ]; then
print_msg "$RED" "⚠️ Atualizando Node.js para v22+..."
pkg install -y nodejs-lts
fi
else
print_msg "$RED" "⚠️ Instalando Node.js..."
pkg install -y nodejs-lts
fi
}

update_packages() {
print_msg "$CYAN" "🔄 Atualizando pacotes do sistema..."
progress_bar 10
pkg update -y && pkg upgrade -y
}

install_dependencies() {
print_msg "$CYAN" "📦 Instalando pacotes essenciais..."

packages="nodejs npm ffmpeg wget git curl python clang make sqlite libwebp imagemagick zip tmux openssl-tools tesseract"

for package in $packages; do
print_msg "$YELLOW" "📌 Instalando: ${package}..."
if pkg install -y "$package" > /dev/null 2>&1; then
print_msg "$GREEN" "✅ ${package} instalado com sucesso!"
else
print_msg "$RED" "❌ Erro ao instalar ${package}!"
fi
sleep 0.3
done
}

update_github() {
print_msg "$YELLOW" "🔄 Atualizando código-fonte..."
if [ -d ".git" ]; then
git pull
else
print_msg "$RED" "⚠️ Repositório não encontrado! Clonando..."
git clone "https://github.com/Otakump4/Zero-Two-Free.git" .
fi
}

main_menu() {
enable_colors
print_banner
echo "${BRIGHTWHITE}📌 Escolha uma opção:${NOCOLOR}\n"

echo "${YELLOW}1${NOCOLOR} - Iniciar com QR Code"
echo "${YELLOW}2${NOCOLOR} - Iniciar diretamente com código"
echo "${YELLOW}3${NOCOLOR} - Atualizar bot do GitHub"
echo "${YELLOW}4${NOCOLOR} - Instalar Dependências"
echo "${YELLOW}5${NOCOLOR} - Sair"

while true; do
read -r -p "$(echo "${YELLOW}Opção: ${NOCOLOR}")" choice
case "$choice" in
1) 
print_msg "$GREEN" "🔑 Abrindo QR Code..."
sleep 1
bash start.sh
break 
;;
2) 
print_msg "$GREEN" "🔑 Iniciando sem QR Code..."
sleep 1
bash start.sh sim
break 
;;
3) 
update_github
main_menu
break 
;;
4) 
check_nodejs
update_packages
install_dependencies
print_msg "$GREEN" "✅ Instalação concluída!"
sleep 1
main_menu
break 
;;
5) 
print_msg "$RED" "👋 Saindo... Obrigado por usar Zero Two Free!"
exit 0
;;
*) 
print_msg "$RED" "❌ Opção inválida! Tente novamente."
;;
esac
done
}

main_menu