$ErrorActionPreference = 'Stop'
Set-Location (Join-Path $PSScriptRoot '..')
docker load -i artifacts/sage-icpp-demo-20260921.tar
if ($LASTEXITCODE -ne 0) { throw 'Docker image import failed.' }
docker compose -p sage-icpp-demo-local -f compose.local.yaml up -d --pull never --no-build --wait
if ($LASTEXITCODE -ne 0) { throw 'Demo startup failed.' }
$port = if ($env:LOCAL_DEMO_PORT) { $env:LOCAL_DEMO_PORT } else { '18400' }
Write-Host "Open http://localhost:$port/ui/"
