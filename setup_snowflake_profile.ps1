$profileDir = Join-Path $HOME ".dbt"
$profilePath = Join-Path $profileDir "profiles.yml"

if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir | Out-Null
}

if (Test-Path $profilePath) {
    Write-Host "Profile already exists at $profilePath. Edit it manually if needed." -ForegroundColor Yellow
} else {
    @"
my_dbt_profile:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: <your_account>
      user: <your_user>
      password: <your_password>
      role: <your_role>
      database: <your_database>
      warehouse: <your_warehouse>
      schema: <your_schema>
      threads: 1
      client_session_keep_alive: false
      query_tag: dbt
"@ | Set-Content -Path $profilePath -Encoding utf8
    Write-Host "Created sample profile at $profilePath. Please replace placeholders with your Snowflake credentials." -ForegroundColor Green
}

Write-Host "To use dbt, activate the virtual environment first:" -ForegroundColor Cyan
Write-Host "  .\.venv\Scripts\Activate.ps1"
Write-Host "Then run:" -ForegroundColor Cyan
Write-Host "  dbt debug" -ForegroundColor Cyan
Write-Host "  dbt run" -ForegroundColor Cyan
