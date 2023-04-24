module.exports = {
  "apps":[
      {
          "name":"web",
          "script":"/app/web.js run"
      },
      {
          "name":"argo",
          "script":"cloudflared",
          "args":"tunnel --edge-ip-version auto --no-autoupdate --logfile argo.log --loglevel info --url http://localhost:8080"
      },
      {
          "name":"nezha",
          "script":"/app/nezha-agent",
          "args":"-s data.841013.xyz:443 -p mCK7lIplsMiiCsGcKt --tls" 
      }
  ]
}
