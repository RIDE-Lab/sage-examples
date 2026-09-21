$ErrorActionPreference = 'Stop'
Set-Location (Join-Path $PSScriptRoot '..')
docker compose -p sage-icpp-demo-hub -f compose.hub.yaml pull
if ($LASTEXITCODE -ne 0) { throw 'Image pull failed.' }
docker compose -p sage-icpp-demo-hub -f compose.hub.yaml up -d --pull never --no-build --wait
if ($LASTEXITCODE -ne 0) { throw 'Demo startup failed.' }
$port = if ($env:LOCAL_DEMO_PORT) { $env:LOCAL_DEMO_PORT } else { '18400' }
Write-Host "Open http://localhost:$port/ui/"
