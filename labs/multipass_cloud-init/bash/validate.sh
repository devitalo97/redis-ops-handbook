#!/bin/bash

VM_NAME="redis-lab"

# Função para imprimir cabeçalhos
print_header() {
    echo -e "\n\033[1;34m>>> $1 \033[0m"
}

echo "--- VALIDANDO AMBIENTE REDIS ($VM_NAME) ---"

# 1. Verifica se o Redis está rodando
print_header "1. Status do Servico Redis"
multipass exec $VM_NAME -- systemctl status redis-server --no-pager | grep "Active:"

# 2. Verifica a Memória Swap
print_header "2. Memoria Swap (Deve ser ~1.0G)"
multipass exec $VM_NAME -- swapon --show
multipass exec $VM_NAME -- free -h | grep Swap

# 3. Verifica Tuning de Kernel (Overcommit)
print_header "3. Kernel Overcommit (Deve ser 1)"
multipass exec $VM_NAME -- sysctl vm.overcommit_memory

# 4. Verifica Transparent Huge Pages (THP)
print_header "4. THP (Deve estar em [never])"
multipass exec $VM_NAME -- cat /sys/kernel/mm/transparent_hugepage/enabled

# 5. Verifica Configuração de Memória do Redis
print_header "5. Config Redis: MaxMemory (Deve ser 1gb)"
multipass exec $VM_NAME -- sudo grep "maxmemory" /etc/redis/redis.conf

# 6. Verifica Configuração de Rede (Bind)
print_header "6. Config Redis: Bind (Deve ser 0.0.0.0)"
multipass exec $VM_NAME -- sudo grep "^bind" /etc/redis/redis.conf

print_header "--- VALIDACAO CONCLUIDA ---"