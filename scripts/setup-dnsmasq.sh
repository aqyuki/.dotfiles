#!/bin/bash
set -euo pipefail

if ! command -v brew >/dev/null 2>&1; then
  echo "setup-dnsmasq.sh requires Homebrew to be installed. Please install Homebrew first." >&2
  exit 1
fi

if ! command -v mkcert >/dev/null 2>&1; then
  echo "setup-dnsmasq.sh requires mkcert to be installed. Please install mkcert first." >&2
  exit 1
fi

BREW_BIN="$(command -v brew)"
BREW_PREFIX="$("$BREW_BIN" --prefix)"
DNSMASQ_BIN="$BREW_PREFIX/sbin/dnsmasq"
DNSMASQ_CONF="$BREW_PREFIX/etc/dnsmasq.conf"
DNSMASQ_CONF_DIR="$BREW_PREFIX/etc/dnsmasq.d"

LAUNCHD_LABEL="local.dnsmasq"
LAUNCHD_PLIST="/Library/LaunchDaemons/$LAUNCHD_LABEL.plist"

if [[ ! -x "$DNSMASQ_BIN" || ! -f "$DNSMASQ_CONF" ]]; then
  echo "setup-dnsmasq.sh requires dnsmasq to be installed. Run: brew install dnsmasq" >&2
  exit 1
fi

# Preserve the original configuration only once.
if [[ ! -e "$DNSMASQ_CONF.setup-backup" ]]; then
  cp -p "$DNSMASQ_CONF" "$DNSMASQ_CONF.setup-backup"
fi

mkdir -p "$DNSMASQ_CONF_DIR"

# Enable the required dnsmasq settings.
sed -i '' \
  -e 's|^#listen-address=$|listen-address=127.0.0.1|' \
  -e 's|^#bind-interfaces$|bind-interfaces|' \
  -e "s|^#conf-dir=${BREW_PREFIX}/etc/dnsmasq\\.d/,\\*\\.conf\$|conf-dir=${DNSMASQ_CONF_DIR}/,*.conf|" \
  "$DNSMASQ_CONF"

# Verify the exact resulting lines.
grep -Fqx 'listen-address=127.0.0.1' "$DNSMASQ_CONF"
grep -Fqx 'bind-interfaces' "$DNSMASQ_CONF"
grep -Fqx "conf-dir=$DNSMASQ_CONF_DIR/,*.conf" "$DNSMASQ_CONF"

# Validate the complete configuration before touching the service.
"$DNSMASQ_BIN" --test --conf-file="$DNSMASQ_CONF"

# Obtain sudo credentials before system-wide changes.
sudo -v

# Stop an existing manually managed instance before replacing its plist.
if sudo launchctl print "system/$LAUNCHD_LABEL" >/dev/null 2>&1; then
  sudo launchctl bootout "system/$LAUNCHD_LABEL"
fi

# Create our own LaunchDaemon definition.
sudo tee "$LAUNCHD_PLIST" >/dev/null <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>$LAUNCHD_LABEL</string>

  <key>ProgramArguments</key>
  <array>
    <string>$DNSMASQ_BIN</string>
    <string>--keep-in-foreground</string>
    <string>--conf-file=$DNSMASQ_CONF</string>
  </array>

  <key>RunAtLoad</key>
  <true/>

  <key>KeepAlive</key>
  <true/>

  <key>ProcessType</key>
  <string>Background</string>

  <key>ThrottleInterval</key>
  <integer>5</integer>
</dict>
</plist>
PLIST

sudo chown root:wheel "$LAUNCHD_PLIST"
sudo chmod 644 "$LAUNCHD_PLIST"
plutil -lint "$LAUNCHD_PLIST"

# Register and start the system LaunchDaemon.
sudo launchctl bootstrap system "$LAUNCHD_PLIST"

# Verify that launchd knows about the service.
sudo launchctl print "system/$LAUNCHD_LABEL" >/dev/null

# Configure macOS to send *.internal queries to dnsmasq.
sudo mkdir -p /etc/resolver
printf '%s\n' 'nameserver 127.0.0.1' |
  sudo tee /etc/resolver/internal >/dev/null

# Install the local mkcert CA in the trust store.
mkcert -install

echo "dnsmasq and mkcert setup completed successfully."
