$VM_NAME = "redis-lab"

function Print-Header ($title) {
    Write-Host "`n>>> $title" -ForegroundColor Cyan
}

Write-Host "--- VALIDANDO AMBIENTE REDIS ($VM_NAME) ---" -ForegroundColor Yellow

# 1. Verifica se o Redis está rodando
Print-Header "1. Status do Servico Redis"
multipass exec $VM_NAME -- systemctl status redis-server --no-pager | Select-String "Active:"

# 2. Verifica a Memória Swap
Print-Header "2. Memoria Swap (Deve ser ~1.0G)"
multipass exec $VM_NAME -- swapon --show
multipass exec $VM_NAME -- free -h | Select-String "Swap"

# 3. Verifica Tuning de Kernel (Overcommit)
Print-Header "3. Kernel Overcommit (Deve ser 1)"
multipass exec $VM_NAME -- sysctl vm.overcommit_memory

# 4. Verifica Transparent Huge Pages (THP)
Print-Header "4. THP (Deve estar em [never])"
multipass exec $VM_NAME -- cat /sys/kernel/mm/transparent_hugepage/enabled

# 5. Verifica Configuração de Memória do Redis
Print-Header "5. Config Redis: MaxMemory (Deve ser 1gb)"
multipass exec $VM_NAME -- sudo grep "maxmemory" /etc/redis/redis.conf

# 6. Verifica Configuração de Rede (Bind)
Print-Header "6. Config Redis: Bind (Deve ser 0.0.0.0)"
multipass exec $VM_NAME -- sudo grep "^bind" /etc/redis/redis.conf

Write-Host "`n--- VALIDACAO CONCLUIDA ---" -ForegroundColor Yellow