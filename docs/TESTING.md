# Testes no aparelho

Registre modelo do iPhone, iOS exato, Fire OS, ABI, data, commit e rede.

```bash
ADB="$ANDROID_HOME/platform-tools/adb"
TV=192.168.1.50:5555
"$ADB" -s "$TV" shell getprop ro.build.version.release
"$ADB" -s "$TV" shell getprop ro.build.version.sdk
"$ADB" -s "$TV" shell getprop ro.product.cpu.abilist
"$ADB" -s "$TV" shell dumpsys media.codec
```

Abra a atividade e capture logs novos com scripts/capture.sh. Mesma rede/sub-rede,
sem isolamento. VPN e redes de convidados podem bloquear descoberta. Não abra
portas no roteador. dns-sd -B _airplay._tcp local. no Mac testa apenas descoberta.

| Etapa | Evidência necessária |
|---|---|
| Instalação | App abre sem crash, controle remoto funciona |
| Registro | MDNS_REGISTERED; apenas registro local |
| Descoberta | Nome visível no seletor do iPhone |
| Transporte | Logs de negociação; CLIENT_CONNECTED sozinho não basta |
| Fluxo | VIDEO_PACKET_RECEIVED ao espelhar |
| Decodificação | VIDEO_FRAME_RENDERED e conteúdo correto observado na TV |
| Fotos | Avançar 10 fotos e girar tela; proporção correta |
| PDF | Abrir, avançar e ampliar; texto pequeno legível |
| PowerPoint | 10 slides por 10 minutos; anotar comportamento da segunda tela e travamentos |
| Slide parado | Esperar 60 segundos; slide permanece visível |
| Reconexão | Encerrar/reconectar 3 vezes sem tela antiga ou travamento |
| Encerramento | Voltar duas vezes; serviço para e anúncios expiram |
| Sem internet | Remover WAN mantendo LAN; conteúdo local continua espelhando |

Use conteúdo já baixado para o teste sem WAN; aplicativos do iPhone podem exigir
internet para login/download por conta própria. Não publique documentos privados.
Logs podem conter nomes/IPs/identificadores: revisar antes de anexar em issues públicas.
