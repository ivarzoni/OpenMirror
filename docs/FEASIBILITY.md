# Viabilidade — 5 de novembro de 2026

Conclusão de engenharia: viável como experimento; compatibilidade no alvo pendente.
Há portas Android com recepção de vídeo real. Relatos dos autores não equivalem
à validação neste iPhone e Fire TV.

| Base / fonte primária | Licença e avaliação |
|---|---|
| [UxPlay](https://github.com/FDH2/UxPlay) | GPL-3.0. Núcleo C implementa negociação, criptografia e espelhamento. Aplicação Unix usa GStreamer e descoberta da plataforma; não é APK pronto. Reutilizar núcleo e substituir renderizadores. |
| [RPiPlay](https://github.com/FD-/RPiPlay) | LICENSE raiz GPL-3.0; partes herdadas LGPL/MIT/BSD. Implementa espelhamento; renderizadores Raspberry Pi precisam de substituição. Não atribuir LGPL ao conjunto só por componentes herdados. |
| [ShairPlay](https://github.com/juhovh/shairplay) | Núcleo LGPL-2.1+, demais partes MIT/BSD conforme LICENSE. Base histórica RAOP/áudio; isoladamente não resolve vídeo moderno. |
| [Shairport Sync](https://github.com/mikebrady/shairport-sync) | Projeto de áudio; licenças por componente. Não atende Fotos/slides/PDF. Não incorporado. |
| [android-airplay-server](https://github.com/jqssun/android-airplay-server) | GPL-3.0, UxPlay e dependências. Alternativa Android completa com JNI/MediaCodec/PIN. Snapshot consultado a46cca0a6a1274e9e33c0e750f0f1c1eb1d881ea usa SDK 37, Compose, Hilt, FFmpeg e submódulos; maior superfície inicial. |
| [uxplay-android](https://github.com/gzhanlei/uxplay-android) | GPL-3.0, libplist LGPL-2.1, OpenSSL Apache-2.0. Escolhida: poucos arquivos Java, SDK 34, núcleo incluído. Relato do autor em Sony Android 10 não comprova Fire TV. |
| [FirePlay](https://github.com/jimnoneill/FirePlay) | Declara GPL-3.0 e usa UxPlay; alternativa específica Fire TV. Não incorporada nem validada de forma independente. |

## mDNS não é espelhamento

_airplay._tcp e _raop._tcp anunciam endereços e capacidades. Depois vêm negociação
RTSP/HTTP, pareamento, chaves/criptografia, transporte, preparação de NALs/SPS/PPS,
decodificação e apresentação de imagem. Responder OPTIONS ou aceitar TCP também
não prova handshake completo. Conservamos esses caminhos reais na porta escolhida.
As flags TXT herdadas precisam ser confrontadas com capacidades efetivas; não
significam suporte universal a AirPlay 2 nem certificação.

## Licenças e distribuição

Adotamos GPL-3.0 para o conjunto derivado. Distribuir APK exige disponibilizar código
correspondente exato, alterações e scripts, preservando avisos. Libplist ligado
estaticamente exige preservar seu fonte e meios de reconstrução/religação conforme
LGPL. OpenSSL Apache-2.0 e llhttp MIT exigem preservar licença/avisos; playfair tem
avisos próprios incluídos. Fontes consultadas: READMEs, LICENSEs e código upstream.

Licença livre não concede certificação Apple nem resolve automaticamente patentes,
marcas e regras de lojas. Esta é triagem técnica de licenças, sem conclusão jurídica
sobre distribuição comercial. A publicação inicial é experimental e sem certificação.
