# Gemini CLI for Termux

Run Google's Gemini CLI directly in your Android terminal via [Termux](https://termux.dev).

---

## Requirements

- [Termux](https://f-droid.org/packages/com.termux/) installed on Android
- Internet connection

---

## Installation

Open Termux and run **one** of the following commands:

### Using curl
```sh
curl -fsSL https://raw.githubusercontent.com/Ad3n1l/gemini-cli-termux/main/termux-setup.sh | sh
```

### Using wget
```sh
wget -qO- https://raw.githubusercontent.com/Ad3n1l/gemini-cli-termux/main/termux-setup.sh | sh
```

The script will automatically:
- Install Node.js if not already present
- Download `gemini.js` from the official Google Gemini CLI release
- Set up `package.json` and `package-lock.json` if needed
- Install dependencies via `npm`
- Create a global `gemini` command you can run from anywhere

---

## Usage

Once installed, simply run:

```sh
gemini
```

From any directory in Termux.

---

## Updating

To update to a newer version of Gemini CLI, just re-run the install command. It will overwrite the existing `gemini.js` with the latest configured release.

---

## Uninstall

To completely remove Gemini CLI from Termux:

```sh
rm -f $PREFIX/bin/gemini
rm -rf $HOME/Gemini
echo "Gemini CLI removed."
```

---

## Troubleshooting

**`gemini: command not found`**
> Re-run the install script. The wrapper may not have been created correctly.

**`Failed to download gemini.js`**
> Check your internet connection. Make sure Termux has network access.

**`node: command not found`**
> Run `pkg install nodejs -y` manually, then re-run the install script.

**npm errors during install**
> Try running `npm install` manually inside `~/Gemini/`.

---

## File Structure

After installation, your setup will look like this:

```
~/Gemini/
├── gemini.js          # Main CLI script from Google
├── package.json       # Project metadata & dependencies
├── package-lock.json  # Locked dependency versions
└── node_modules/      # Installed packages

$PREFIX/bin/gemini     # Global command wrapper
```

---

## Credits

- [Google Gemini CLI](https://github.com/google-gemini/gemini-cli) — official CLI by Google
- Termux setup script by [Ad3n1l](https://github.com/Ad3n1l)
