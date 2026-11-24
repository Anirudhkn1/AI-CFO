# Tiny local web server for the Obsid-finance demo (PowerShell ships with Windows; nothing to install).
# Listens on localhost only, so it is reachable from this computer and nowhere else.
param(
  [int]$StartPort = 8765,
  [switch]$NoOpen
)
$ErrorActionPreference = 'Stop'

$root = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..\app'))
if (-not (Test-Path (Join-Path $root 'index.html'))) {
  Write-Host 'The "app" folder is missing or incomplete. Please unzip the whole package and try again.' -ForegroundColor Red
  exit 1
}

$mime = @{
  '.html' = 'text/html; charset=utf-8'; '.js' = 'text/javascript; charset=utf-8'; '.mjs' = 'text/javascript; charset=utf-8'
  '.css' = 'text/css; charset=utf-8'; '.json' = 'application/json'; '.map' = 'application/json'
  '.wasm' = 'application/wasm'; '.png' = 'image/png'; '.jpg' = 'image/jpeg'; '.jpeg' = 'image/jpeg'
  '.gif' = 'image/gif'; '.svg' = 'image/svg+xml'; '.ico' = 'image/x-icon'; '.webp' = 'image/webp'
  '.otf' = 'font/otf'; '.ttf' = 'font/ttf'; '.woff' = 'font/woff'; '.woff2' = 'font/woff2'
  '.txt' = 'text/plain; charset=utf-8'; '.symbols' = 'text/plain; charset=utf-8'; '.bin' = 'application/octet-stream'
}

$listener = $null
$port = 0
for ($p = $StartPort; $p -le $StartPort + 20; $p++) {
  $l = New-Object System.Net.HttpListener
  $l.Prefixes.Add("http://localhost:$p/")
  try { $l.Start(); $listener = $l; $port = $p; break } catch { $l.Close() }
}
if (-not $listener) {
  Write-Host "Could not find a free port between $StartPort and $($StartPort + 20)." -ForegroundColor Red
  exit 1
}

$url = "http://localhost:$port/"
Write-Host "Obsid-finance is running at $url" -ForegroundColor Green
Write-Host 'Leave this window open while you look around. Close it (or press Ctrl+C) to stop.'
if (-not $NoOpen) { Start-Process $url }

while ($listener.IsListening) {
  $ctx = $listener.GetContext()
  $res = $ctx.Response
  try {
    $rel = [Uri]::UnescapeDataString($ctx.Request.Url.AbsolutePath).TrimStart('/')
    if ($rel -eq '' -or $rel.EndsWith('/')) { $rel += 'index.html' }
    $full = [System.IO.Path]::GetFullPath((Join-Path $root $rel))
    if ($ctx.Request.HttpMethod -notin @('GET', 'HEAD')) {
      $res.StatusCode = 405
    } elseif (-not $full.StartsWith($root, [StringComparison]::OrdinalIgnoreCase)) {
      $res.StatusCode = 403
    } elseif (-not (Test-Path -LiteralPath $full -PathType Leaf)) {
      $res.StatusCode = 404
    } else {
      $ext = [System.IO.Path]::GetExtension($full).ToLower()
      $res.ContentType = if ($mime.ContainsKey($ext)) { $mime[$ext] } else { 'application/octet-stream' }
      $res.Headers.Add('Cache-Control', 'no-cache')
      $bytes = [System.IO.File]::ReadAllBytes($full)
      $res.ContentLength64 = $bytes.Length
      if ($ctx.Request.HttpMethod -eq 'GET') { $res.OutputStream.Write($bytes, 0, $bytes.Length) }
    }
  } catch {
    try { $res.StatusCode = 500 } catch { }
  } finally {
    try { $res.Close() } catch { }
  }
}
