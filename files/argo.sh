#!/usr/bin/env bash

argo_type() {
  if [[ -n "${ARGO_AUTH}" && -n "${ARGO_DOMAIN}" ]]; then
    [[ $ARGO_AUTH =~ TunnelSecret ]] && echo $ARGO_AUTH > tunnel.json && echo -e "tunnel: $(cut -d\" -f12 <<< $ARGO_AUTH)\ncredentials-file: /app/tunnel.json" > tunnel.yml
  else
    ARGO_DOMAIN=$(cat argo.log | grep -o "info.*https://.*trycloudflare.com" | sed "s@.*https://@@g" | tail -n 1)
  fi
}

export_list() {
  VMESS="{ \"v\": \"2\", \"ps\": \"Argo-Vmess\", \"add\": \"icook.hk\", \"port\": \"443\", \"id\": \"de04add9-5c68-8bab-950c-08cd5320df18\", \"aid\": \"0\", \"scy\": \"none\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"${ARGO_DOMAIN}\", \"path\": \"/argo-vmess?ed=2048\", \"tls\": \"tls\", \"sni\": \"${ARGO_DOMAIN}\", \"alpn\": \"\" }"

  cat > list << EOF
*******************************************
V2-rayN:
----------------------------
vless://de04add9-5c68-8bab-950c-08cd5320df18@icook.hk:443?encryption=none&security=tls&sni=${ARGO_DOMAIN}&type=ws&host=${ARGO_DOMAIN}&path=%2Fargo-vless?ed=2048#Argo-Vless
----------------------------
vmess://$(echo $VMESS | base64 -w0)
----------------------------
trojan://de04add9-5c68-8bab-950c-08cd5320df18@icook.hk:443?security=tls&sni=${ARGO_DOMAIN}&type=ws&host=${ARGO_DOMAIN}&path=%2Fargo-trojan?ed=2048#Argo-Trojan
----------------------------
ss://Y2hhY2hhMjAtaWV0Zi1wb2x5MTMwNTpkZTA0YWRkOS01YzY4LThiYWItOTUwYy0wOGNkNTMyMGRmMThAaWNvb2suaGs6NDQzCg==@icook.hk:443#Argo-Shadowsocks
由于该软件导出的链接不全，请自行处理如下: 传输协议: WS ， 伪装域名: ${ARGO_DOMAIN} ，路径: /argo-shadowsocks?ed=2048 ， 传输层安全: tls ， sni: ${ARGO_DOMAIN}
*******************************************
小火箭:
----------------------------
vless://de04add9-5c68-8bab-950c-08cd5320df18@icook.hk:443?encryption=none&security=tls&type=ws&host=${ARGO_DOMAIN}&path=/argo-vless?ed=2048&sni=${ARGO_DOMAIN}#Argo-Vless
----------------------------
vmess://bm9uZTpkZTA0YWRkOS01YzY4LThiYWItOTUwYy0wOGNkNTMyMGRmMThAaWNvb2suaGs6NDQzCg==?remarks=Argo-Vmess&obfsParam=${ARGO_DOMAIN}&path=/argo-vmess?ed=2048&obfs=websocket&tls=1&peer=${ARGO_DOMAIN}&alterId=0
----------------------------
trojan://de04add9-5c68-8bab-950c-08cd5320df18@icook.hk:443?peer=${ARGO_DOMAIN}&plugin=obfs-local;obfs=websocket;obfs-host=${ARGO_DOMAIN};obfs-uri=/argo-trojan?ed=2048#Argo-Trojan
----------------------------
ss://Y2hhY2hhMjAtaWV0Zi1wb2x5MTMwNTpkZTA0YWRkOS01YzY4LThiYWItOTUwYy0wOGNkNTMyMGRmMThAaWNvb2suaGs6NDQzCg==?obfs=wss&obfsParam=${ARGO_DOMAIN}&path=/argo-shadowsocks?ed=2048#Argo-Shadowsocks
*******************************************
Clash:
----------------------------
- {name: Argo-Vless, type: vless, server: icook.hk, port: 443, uuid: de04add9-5c68-8bab-950c-08cd5320df18, tls: true, servername: ${ARGO_DOMAIN}, skip-cert-verify: false, network: ws, ws-opts: {path: /argo-vless?ed=2048, headers: { Host: ${ARGO_DOMAIN}}}, udp: true}
----------------------------
- {name: Argo-Vmess, type: vmess, server: icook.hk, port: 443, uuid: de04add9-5c68-8bab-950c-08cd5320df18, alterId: 0, cipher: none, tls: true, skip-cert-verify: true, network: ws, ws-opts: {path: /argo-vmess?ed=2048, headers: {Host: ${ARGO_DOMAIN}}}, udp: true}
----------------------------
- {name: Argo-Trojan, type: trojan, server: icook.hk, port: 443, password: de04add9-5c68-8bab-950c-08cd5320df18, udp: true, tls: true, sni: ${ARGO_DOMAIN}, skip-cert-verify: false, network: ws, ws-opts: { path: /argo-trojan?ed=2048, headers: { Host: ${ARGO_DOMAIN} } } }
----------------------------
- {name: Argo-Shadowsocks, type: ss, server: icook.hk, port: 443, cipher: chacha20-ietf-poly1305, password: de04add9-5c68-8bab-950c-08cd5320df18, plugin: v2ray-plugin, plugin-opts: { mode: websocket, host: ${ARGO_DOMAIN}, path: /argo-shadowsocks?ed=2048, tls: true, skip-cert-verify: false, mux: false } }
*******************************************
EOF
  cat list
}

argo_type
export_list
