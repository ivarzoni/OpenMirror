# Créditos e licenças

Versão modificada de [gzhanlei/uxplay-android](https://github.com/gzhanlei/uxplay-android),
commit d9646d76cd416a79c5d800d7f306f1b11c7e4b2d. README original: README.upstream.md.

| Componente | Fonte e avisos preservados |
|---|---|
| Porta Java/JNI/C | Upstream acima; GPL-3.0, LICENSE raiz |
| UxPlay | Fonte incluído em uxplay/; GPL-3.0, uxplay/LICENSE e cabeçalhos. Commit independente não informado pelo vendoring upstream. |
| libplist 2.4.0 | deps/libplist/; LGPL-2.1, COPYING e COPYING.LESSER; avisos específicos libcnary preservados |
| OpenSSL 3.3.2 | Reconstruído de fonte oficial por deps/build_openssl.sh; Apache-2.0, licenses/OpenSSL-Apache-2.0.txt |
| llhttp | uxplay/lib/llhttp/; MIT, LICENSE-MIT |
| playfair | uxplay/lib/playfair/; LICENSE.md e cabeçalhos próprios |
| Gradle wrapper | Herdado; distribuição 8.7, scripts com avisos Apache-2.0 |

Código binário OpenSSL recebido do upstream não é fonte de verdade: o build
reconstrói a biblioteca de arquivo-fonte oficial com SHA-256 fixado. Código e
scripts correspondentes devem acompanhar distribuições de APK.

Modificações OpenMirror (2026): identificação, UI em português, instrumentação de
quadros exibidos, separação de evidências, remoção de gravação PCM, boot e sobreposição,
fixação de ferramentas, scripts, testes e documentação. Código derivado GPL-3.0.


Identidade visual OpenMirror (2026): desenho original em branding/mark.json e SVG,
exportadores nativos em scripts/render_branding.py e render_branding.swift, ícones,
banners e traduções da interface. Esses arquivos permanecem sob a licença GPL-3.0
do projeto. Fontes do sistema são usadas apenas na exportação; não são distribuídos
arquivos de fontes nem há dependências gráficas externas no aplicativo.
