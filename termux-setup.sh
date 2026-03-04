#!/data/data/com.termux/files/usr/bin/sh

echo "[*] Setting up Gemini CLI for Termux..."

# Check for node
if ! command -v node > /dev/null 2>&1; then
  echo "[!] Node.js not found. Installing..."
  pkg install nodejs -y
fi

# Check for curl, install if missing
if ! command -v curl > /dev/null 2>&1 && ! command -v wget > /dev/null 2>&1; then
  echo "[!] curl not found. Installing..."
  pkg install curl -y
fi

# Create Gemini directory
GEMINI_DIR="$HOME/Gemini"
mkdir -p "$GEMINI_DIR"
cd "$GEMINI_DIR"

# Download gemini.js
echo "[*] Downloading gemini.js..."
DOWNLOAD_URL="https://raw.githubusercontent.com/Ad3n1l/gemini-cli-termux/main/gemini.js"

if command -v curl > /dev/null 2>&1; then
  curl -fsSL "$DOWNLOAD_URL" -o gemini.js
else
  wget -q "$DOWNLOAD_URL" -O gemini.js
fi

if [ ! -f gemini.js ]; then
  echo "[!] Failed to download gemini.js. Check your internet connection or the URL."
  exit 1
fi
echo "[✓] gemini.js downloaded."

# Run gemini.js so it can generate package files
echo "[*] Running gemini.js to initialize package files..."
node gemini.js 2>/dev/null || true

# Check and create package.json if missing
if [ ! -f "$GEMINI_DIR/package.json" ]; then
  echo "[!] package.json not found. Creating..."
  cat > "$GEMINI_DIR/package.json" << 'EOF'
{
  "type": "module",
  "dependencies": {
    "punycode": "^2.3.1"
  }
}
EOF
  echo "[✓] package.json created."
else
  echo "[✓] package.json already exists."
fi

# Check and create package-lock.json if missing
if [ ! -f "$GEMINI_DIR/package-lock.json" ]; then
  echo "[!] package-lock.json not found. Creating..."
  cat > "$GEMINI_DIR/package-lock.json" << 'EOF'
{
  "name": "Gemini",
  "lockfileVersion": 3,
  "requires": true,
  "packages": {
    "": {
      "dependencies": {
        "punycode": "^2.3.1"
      }
    },
    "node_modules/punycode": {
      "version": "2.3.1",
      "resolved": "https://registry.npmjs.org/punycode/-/punycode-2.3.1.tgz",
      "integrity": "sha512-vYt7UD1U9Wg6138shLtVZDnBo6V2kkMVlEKRBqpFB8kDMGlBDkCPGSP/SiRTdNMfr5YC8cRY5fO3GAkr6kbA==",
      "license": "MIT",
      "engines": {
        "node": ">=6"
      }
    }
  }
}
EOF
  echo "[✓] package-lock.json created."
else
  echo "[✓] package-lock.json already exists."
fi

# Install dependencies
echo "[*] Installing dependencies..."
npm install --prefix "$GEMINI_DIR"

# Create global wrapper
echo "[*] Creating global 'gemini' command..."
cat > $PREFIX/bin/gemini << 'WRAPPER'
#!/data/data/com.termux/files/usr/bin/sh
cd /data/data/com.termux/files/home/Gemini
exec node gemini.js "$@"
WRAPPER

chmod +x $PREFIX/bin/gemini

echo "[✓] Done! Run 'gemini' from anywhere."
