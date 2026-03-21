#!/bin/sh
set -e

ARCH=$(uname -m)
POD=${POD_NAME:-unknown}
NODE=${NODE_NAME:-unknown}

case "$ARCH" in
  x86_64)  ARCH_LABEL="amd64 (x86_64)" ; COLOR="#4A90D9" ;;
  aarch64) ARCH_LABEL="arm64 (aarch64)"; COLOR="#7B68EE" ;;
  armv7l)  ARCH_LABEL="arm/v7 (armv7l)"; COLOR="#E89B3A" ;;
  *)       ARCH_LABEL="$ARCH"           ; COLOR="#888888" ;;
esac

cat > /usr/share/nginx/html/index.html <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Multi-Arch Demo</title>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: 'Courier New', monospace;
      background: #0f0f0f;
      color: #e0e0e0;
      display: flex;
      justify-content: center;
      align-items: center;
      min-height: 100vh;
    }
    .card {
      background: #1a1a1a;
      border: 2px solid ${COLOR};
      border-radius: 12px;
      padding: 40px 50px;
      max-width: 520px;
      width: 90%;
      text-align: center;
      box-shadow: 0 0 30px ${COLOR}44;
    }
    .arch {
      font-size: 2.4em;
      font-weight: bold;
      color: ${COLOR};
      margin: 16px 0;
      letter-spacing: 2px;
    }
    .label {
      font-size: 0.75em;
      color: #666;
      text-transform: uppercase;
      letter-spacing: 3px;
      margin-bottom: 4px;
    }
    .value {
      font-size: 1em;
      color: #ccc;
      margin-bottom: 20px;
      word-break: break-all;
    }
    hr { border: none; border-top: 1px solid #333; margin: 20px 0; }
    .title {
      font-size: 0.9em;
      color: #555;
      margin-bottom: 24px;
      letter-spacing: 4px;
      text-transform: uppercase;
    }
  </style>
</head>
<body>
  <div class="card">
    <div class="title">Multi-Arch K8s Demo</div>
    <div class="arch">${ARCH_LABEL}</div>
    <hr>
    <div class="label">Pod</div>
    <div class="value">${POD}</div>
    <div class="label">Node</div>
    <div class="value">${NODE}</div>
  </div>
</body>
</html>
EOF

exec nginx -g 'daemon off;'
