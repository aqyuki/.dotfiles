# dnsmasq

## 再起動

```bash
sudo launchctl kickstart -k system/local.dnsmasq
```

## 停止・登録解除

```bash
sudo launchctl bootout system/local.dnsmasq
```

## 再登録

```bash
sudo launchctl bootstrap system /Library/LaunchDaemons/local.dnsmasq.plist
```
