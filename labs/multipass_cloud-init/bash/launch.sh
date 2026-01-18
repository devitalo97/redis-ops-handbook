#!/bin/bash

VM_NAME="redis-lab"
CONFIG_FILE="cloud-init.yaml"

# Cores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}--- Iniciando Provisionamento do Redis Lab ---${NC}"

# 1. Verifica se o cloud-init existe
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Erro: Arquivo $CONFIG_FILE nao encontrado!"
    exit 1
fi

# 2. Limpeza de ambiente anterior
if multipass list | grep -q "$VM_NAME"; then
    echo -e "${YELLOW}Detecada VM antiga '$VM_NAME'. Deletando...${NC}"
    multipass delete $VM_NAME --purge
fi

# 3. Criação da VM
echo -e "${GREEN}Criando nova VM '$VM_NAME' (2CPUs, 2GB RAM, 10GB Disk)...${NC}"
multipass launch --name $VM_NAME \
    --cpus 2 \
    --memory 2G \
    --disk 10G \
    --cloud-init $CONFIG_FILE

echo -e "${GREEN}VM Criada com sucesso!${NC}"
echo -e "${YELLOW}Aguarde alguns segundos para o cloud-init terminar as configuracoes internas...${NC}"
echo "Use './validate.sh' para conferir o status."