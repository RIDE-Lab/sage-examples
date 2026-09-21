param([switch]$InitEnvOnly)
$ErrorActionPreference = 'Stop'
Set-Location (Join-Path $PSScriptRoot '..')
if (-not (Test-Path -LiteralPath '.env')) {
    Copy-Item -LiteralPath '.env.example' -Destination '.env'
    Write-Host 'Created .env from .env.example; offline archive mode keeps models disabled.'
}
if ($InitEnvOnly) { return }
docker load -i artifacts/sage-icpp-demo-20260921.tar
if ($LASTEXITCODE -ne 0) { throw 'Docker image import failed.' }
docker compose -p sage-icpp-demo-local -f compose.local.yaml up -d --pull never --no-build --wait
if ($LASTEXITCODE -ne 0) { throw 'Demo startup failed.' }
$address = docker compose -p sage-icpp-demo-local -f compose.local.yaml port demo 18400
if ($LASTEXITCODE -ne 0) { throw 'Could not determine the published port.' }
Write-Host "Open http://$address/ui/"
