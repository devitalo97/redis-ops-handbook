# Configurações
$VM_NAME = "redis-lab"
$CONFIG_FILE = "cloud-init.yaml"

Write-Host "--- Iniciando Provisionamento do Redis Lab ---" -ForegroundColor Yellow

# 1. Verifica se o cloud-init existe
if (-not (Test-Path $CONFIG_FILE)) {
    Write-Error "Erro: Arquivo $CONFIG_FILE não encontrado!"
    exit 1
}

# 2. Limpeza de ambiente anterior
# Captura a lista e verifica se o nome existe nela
$running_vms = multipass list | Out-String
if ($running_vms -match $VM_NAME) {
    Write-Host "Detectada VM antiga '$VM_NAME'. Deletando..." -ForegroundColor Yellow
    multipass delete $VM_NAME --purge
}

# 3. Criação da VM
Write-Host "Criando nova VM '$VM_NAME' (2CPUs, 2GB RAM, 10GB Disk)..." -ForegroundColor Green
multipass launch --name $VM_NAME `
    --cpus 2 `
    --memory 2G `
    --disk 10G `
    --cloud-init $CONFIG_FILE

if ($?) {
    Write-Host "VM Criada com sucesso!" -ForegroundColor Green
    Write-Host "Aguarde alguns segundos para o cloud-init terminar as configuracoes internas..." -ForegroundColor Cyan
    Write-Host "Use '.\validate.ps1' para conferir o status."
} else {
    Write-Error "Falha ao criar a VM."
}