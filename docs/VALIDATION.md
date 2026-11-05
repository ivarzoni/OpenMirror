# Registro de validação — 5 de novembro de 2026

## Resultado atual

Primeiro espelhamento de tela confirmado visualmente pelo usuário no iPhone 15 Pro Max
com iOS 27.2 (modelo/versão informados pelo usuário), para Fire TV Stick 4K de 2ª geração,
modelo AFTKM, Fire OS 8.1.8.5 / Android 11 (confirmados por ADB). Logs do receptor
registraram negociação, vídeo H.264 recebido e callback de quadro exibido. Instalação
concluída e integridade do APK conferida. Conteúdo correto confirmado pelo relato do usuário.

Keynote com slide em tela cheia na TV e notas/controles separados no iPhone foi
confirmado pelo usuário. PowerPoint espelhado e áudio do YouTube na TV foram confirmados;
modo com notas privadas no celular e slides separados na TV não funcionou no teste.
Fotos: apresentação e vídeos com áudio na TV confirmados pelo usuário. PDFs: tela
espelhada idêntica ao iPhone, sem modo próprio de apresentação, confirmado pelo usuário.
Ainda não validados: nitidez medida de texto, rotação, slide parado, reconexões repetidas,
sessão de 10 minutos, sincronismo/estabilidade prolongada de áudio e uso sem WAN.
Os registros a seguir mostram a sequência dos testes, incluindo tentativas anteriores.

## Ambiente e inspeção inicial

- Mac Apple Silicon arm64, macOS 27.0.1. Inspeção inicial: apenas Java 8 x86_64;
  sem SDK Android, NDK, CMake, Gradle ou ADB no PATH.
- Ferramentas baixadas para a pasta de trabalho, fora do repositório: Temurin
  17.0.21+9 arm64, SDK Platform 34, Build Tools 34.0.0, NDK 26.3.11579264,
  CMake 3.22.1 e platform-tools. Gradle 8.7 pelo wrapper.
- SHA-256 do pacote oficial Android commandlinetools-mac_arm64-15859902_latest.zip:
  835b62a26162b229b441d1f6d4680383815a270809eb33522c0d480fa5002c4e.
- Primeiro assembleDebug: BUILD SUCCESSFUL, 37 tarefas, 5m26s, com dependências
  binárias da base.
- OpenSSL 3.3.2: libcrypto.a e libssl.a reconstruídas do fonte oficial com SHA-256
  fixado. Fontes libplist não usados no build (fuzz/tests/autotools) foram removidos;
  fontes da biblioteca, cabeçalhos e licenças preservados.
- Build final assembleDebug + lintDebug: BUILD SUCCESSFUL, 48 tarefas, 17s.
  Lint: zero erros; avisos ChromeOsAbiSupport, DataExtractionRules, IconMissingDensityFolder.
- Conexão ADB ao aparelho informado: porta 5555 recusou conexão; instalação pendente.
- Quatro testes de classificação de evidências: passaram. Não são testes de AirPlay.
- ADB: nenhum dispositivo conectado na primeira inspeção.
- Na inspeção inicial, instalação e sessão AirPlay não haviam sido testadas;
  resultados posteriores abaixo.
- Modelo e iOS não haviam sido informados na inspeção inicial; confirmação abaixo.

Warnings do build inicial: apenas ABI 32 bits; avisos de versão de XML SDK e APIs
Android obsoletas. O protótipo é para sideload, não uma publicação Google Play.
Um APK compilado não constitui validação de compatibilidade.

## Primeiro contato com o aparelho

- ADB autorizado: produto/device `karat`, modelo `AFTKM`.
- Sistema confirmado por ADB: Android 11, API 30,
  Fire OS 8.1.8.5 (RS8185/3898).
- ABIs confirmadas: `armeabi-v7a,armeabi`; o APK ARMv7 corresponde ao sistema.
- Instalação iniciada, ainda sem confirmação de sucesso. Transferência direta ficou
  sem resposta. A tentativa em duas etapas informou envio de 6.881.027 bytes, mas
  terminou com EOF antes da confirmação; integridade remota não confirmada.
- A reconexão posterior excedeu 15 segundos sem resposta. Instalação não confirmada.
- A conexão de rede ficou intermitente durante o envio. Nenhuma sessão AirPlay
  foi testada nesse contato. Não há evidência de descoberta ou vídeo no iPhone.

## Instalação após reconectar o Fire TV à rede

- APK enviado novamente, com integridade confirmada por SHA-256 nos dois lados:
  `1189e0836d7e3ea7914de82786d3b4fafba64ec32e7377394db7dd85a6931fad`.
- `pm install -r`: Success. Atividade OpenMirror aberta e confirmada em primeiro plano.
- Processo permaneceu ativo; captura da tela de espera confirmada.
- Núcleo UxPlay iniciou o servidor; ambas as inscrições NSD concluíram.
  Marcador `MDNS_REGISTERED` observado. Isso comprova registro local, não descoberta
  pelo iPhone nem recepção de vídeo.
- Decodificador AVC MediaTek inicializado, sem comprovação de quadros recebidos.
- Teste de conexão/visualização pelo iPhone: aguardando execução pelo usuário.

## Primeira sessão AirPlay observada

- Conexão de transporte seguida de negociação `/fp-setup`, `SETUP`, `/info`,
  `RECORD` e início de `raop_rtp_mirror`.
- Parâmetros H.264 SPS/PPS recebidos e decodificador reconfigurado.
- Marcadores `VIDEO_PACKET_RECEIVED` e `VIDEO_FRAME_RENDERED` observados.
- Formato de saída inicial: área visível de 498 × 1080; callback do decodificador
  confirma apresentação de quadro. Não foi usada captura de tela do conteúdo do usuário.
- Confirmação visual recebida do usuário: a tela do iPhone apareceu na TV.
- Origem informada pelo usuário: iPhone 15 Pro Max, iOS 27.2. Versão iOS não
  inspecionada diretamente por ferramenta.
- Legibilidade de documentos e matriz de apresentações ainda pendentes. Uma sessão
  não comprova compatibilidade geral com iOS/Fire OS.

## PowerPoint e YouTube — relato adicional do usuário

- Mesma configuração: iPhone 15 Pro Max, iOS 27.2, Fire OS 8.1.8.5.
- PowerPoint exibiu na TV exatamente a mesma tela do iPhone. A experiência desejada
  (notas privadas no celular e apenas slide grande na TV) não foi obtida.
- Não atribuímos a causa exclusivamente ao receptor nem ao PowerPoint sem teste
  comparativo. Versão/build do PowerPoint ainda não informados.
- Vídeo do YouTube foi testado e o usuário confirmou som diretamente na TV. Não
  foram medidos sincronismo, duração ou perdas. Caminho de transporte não identificado;
  esse relato não valida o endpoint de envio direto de vídeo do protocolo AirPlay.
- Fonte das confirmações: relato do usuário, sem nova captura de tela ou áudio.

### Distinção entre espelhamento e apresentação em duas telas

O receptor decodifica o fluxo de vídeo que o emissor envia. Não lê PPTX ou notas,
nem decide qual interface do PowerPoint substituir pelo slide. Conteúdo diferente
nas duas telas exige que o aplicativo/iOS produza uma saída externa separada e
que a sessão com o receptor suporte o caminho necessário.

A [matriz oficial Microsoft](https://support.microsoft.com/en-us/powerpoint/compare-powerpoint-features-on-different-platforms)
marca Presenter View como indisponível no PowerPoint para iOS, embora notas e
apresentação de slides sejam recursos separados. A Microsoft também documenta
[apresentação via AirPlay no iPhone](https://support.microsoft.com/en-us/powerpoint/present-a-slide-show-from-a-smartphone-and-use-a-laser-pointer-for-emphasis).
Isso não permite concluir, apenas pelo relato, que uma alteração de flags do receptor
resolverá a separação das telas, nem que toda projeção externa do PowerPoint é impossível.

Próxima investigação, caso se priorize esse recurso: registrar versão/build do
PowerPoint e testar a saída de apresentação iniciada no aplicativo. Comparar com
um emissor que documente notas e saída externa separadas antes de modificar a
negociação do receptor. O [Keynote no iPhone documenta esse uso](https://support.apple.com/guide/keynote-iphone/present-on-a-separate-display-tana4da2681/ios),
mas não foi testado com OpenMirror. Nenhuma promessa de compatibilidade adicional.

## Fotos e PDFs — relato adicional do usuário

- Fotos funcionou sem problemas percebidos e entrou em modo de apresentação.
- Vídeos em Fotos reproduziram áudio pela TV.
- PDF repetiu exatamente a tela do iPhone, sem interface ou modo de apresentação
  específico. Esse comportamento corresponde ao espelhamento recebido; não há
  leitor PDF nem processamento de páginas no APK.
- Confirmações por relato do usuário na mesma configuração de hardware/iOS.
  Aplicativo leitor de PDF, duração e quantidade de itens não informados.

## Interface 0.1.1 — tela de conexão

- Novo painel de espera com ilustração vetorial local, três passos para conectar,
  nome do receptor compartilhado com o anúncio e indicador de estado do serviço.
- O painel inteiro é ocultado ao receber callback de quadro exibido e reaparece
  quando a sessão é encerrada; não depende apenas de chegada de pacotes.
- Gradle assembleDebug + lintDebug: BUILD SUCCESSFUL, 48 tarefas, 13s. Sem erros
  de lint; avisos de desenho vetorial/layout, tamanho do rodapé, números nos passos,
  ABI ChromeOS, backup e densidades de ícones.
- Versão 0.1.1-experimental, versionCode 2; APK conferido por SHA-256 antes da instalação:
  `f8ea31f042b6cba0648e97c15ccca176a5a8ec5da44ef1556bdc9c0b5bbd49f5`.
- Instalação e abertura confirmadas no Fire TV AFTKM. Processo ativo, registro mDNS
  concluído e nenhum FATAL EXCEPTION no registro de inicialização inspecionado.
- Captura visual da tela de espera em 1920 × 1080 revisada: textos e ilustração
  íntegros, sem sobreposição ou cortes. Imagem em docs/images/waiting-screen.png.
- Reconexão do iPhone após a alteração de interface confirmada pelo usuário:
  o painel de instruções desaparece e o espelhamento continua funcionando normalmente.
  Isso verifica a transição da nova tela de espera para o vídeo na configuração testada.

## Keynote e PowerPoint 2.115.2 — teste comparativo

- Usuário confirmou Keynote funcionando com próximo slide, notas e atual + próximo
  no celular; a TV mostra apenas o slide em tela cheia e o controle fica no iPhone.
- Versão do Keynote não informada. Não foi confirmada a extensão/formato do arquivo.
- PowerPoint informado pelo usuário: 2.115.2. A apresentação havia sido iniciada
  pelo botão de reproduzir, e não apenas deixada na edição.
- Há relatos de usuários da mesma versão com falha de saída externa em Apple TV
  e HDMI no [Microsoft Q&A](https://learn.microsoft.com/en-us/answers/questions/6059889/ios-powerpoint-update-broke-native-airplay-full-sc),
  publicados em 3–4 de novembro de 2026. São relatos de usuários, sem confirmação
  oficial de causa ou correção pela Microsoft. Não tratamos respostas do fórum
  como diagnóstico oficial.
- Inferência de engenharia: regressão/interação do PowerPoint com iOS é uma hipótese
  forte; o fluxo com conteúdo diferente nas duas telas funciona com Keynote neste
  receptor. Isso não demonstra que todo caminho de negociação do PowerPoint esteja
  correto nem fornece uma correção no APK para o aplicativo Microsoft.
- PowerPoint nativo com notas separadas continua pendente. O código de protocolo
  não foi alterado com base apenas nessa hipótese.

## Versão 0.1.2 — ícone, banner e idiomas

- Ícone original com telefone + TV, versões PNG por densidade, adaptativo (API 26+)
  e monocromático (API 33+). Banner Fire TV traduzido nas cinco línguas.
- Interface e mensagens em inglês (padrão/alternativa), português, espanhol, francês
  e italiano. Escolha pelos recursos nativos do Fire TV, não pelo idioma do iPhone.
- Integridade dos conjuntos de textos e do marcador de versão conferida para todos
  os idiomas; configurações de recursos confirmadas no APK com aapt. Lint: zero
  erros e zero MissingTranslation. Build assembleDebug + lintDebug: sucesso, 5s.
- APK instalado após conferir SHA-256 na TV:
  `d2f3942eb7d8804fd256233b2a50fcb62d0903b58c1cadde237f246f57e04398`.
- Sistema de teste informa pt-BR: interface selecionou português sem intervenção
  manual no aplicativo. Processo ativo, anúncios registrados e sem falha fatal
  no trecho de inicialização examinado. Tela em primeiro plano conferida em 1920 × 1080.
- Outros quatro idiomas foram conferidos nos recursos e na compilação, mas não
  visualmente no Fire TV. Não alteramos o idioma global da TV durante o teste.
- Protocolo AirPlay e decodificação não foram alterados nesta versão. Os testes de
  conteúdo/Keynote relatados anteriormente correspondem às versões anteriores.

## Pacote de distribuição 0.1.2

- Build release com chave própria, distinta da assinatura debug. Chave e senhas
  privadas fora do repositório. Identidade pública: CN=OpenMirror, OU=Personal Project.
- assembleRelease + lintRelease: BUILD SUCCESSFUL, 11s. APK não depurável,
  pacote org.openmirror.presentation, versionCode 3, minSdk 24, targetSdk 34, ARMv7.
- apksigner verify confirmou assinatura v2 válida. SHA-256 do certificado:
  `9d82f8d39b118a8ca066fbbe12db7a62fc0c42ec40aab4e2a3429702cb06b7ee`.
- SHA-256 do APK de distribuição:
  `9bfa6a8fbc7d219127d3a587c9b667e54fc0d66c935fc9fc038c073872946415`.
- Kit preparado com APK, guia, GPL e hash. Guia distingue a instalação por
  Downloader sugerida da instalação ADB já testada.
- Após autorização expressa do usuário, versão debug removida e APK público exato
  instalado: uninstall e pm install retornaram Success. Atividade aberta, servidor
  iniciado e anúncios registrados. Chaves locais do receptor foram recriadas.
- Teste do binário público exato confirmado: recepção e quadro exibido, seguido de
  vídeo em 1920 × 1080. O usuário confirmou que o Keynote continuou funcionando
  perfeitamente, com apenas o slide na TV e notas/controles no iPhone.

## Repetição do teste PowerPoint 2.115.2

- Usuário repetiu a apresentação pelo botão de reproduzir e confirmou que a TV
  continuou mostrando a mesma tela do iPhone.
- Vídeo chegou e foi apresentado; formatos visíveis registrados pelo decodificador:
  498 × 1080, depois 1920 × 886, retornando a 498 × 1080. Proporções compatíveis
  com a tela do iPhone nas orientações retrato e paisagem, em vez de slide 16:9.
- Não houve correção de PowerPoint nem alteração experimental de capacidades nesta
  etapa. A causa exata ainda exige comparação com a sessão de apresentação do Keynote;
  logs não revelam por si só qual tela o aplicativo decidiu renderizar.

## Comparação concluída e liberação do beta

- No binário público assinado, a sessão de apresentação do Keynote produziu área
  visível de 1920 × 1080. Usuário confirmou funcionamento e separação das telas.
- No teste PowerPoint 2.115.2, as áreas recebidas seguiram as proporções do iPhone
  (498 × 1080 / 1920 × 886), com relato de tela idêntica na TV. O fluxo chegou ao
  decodificador; não há evidência de que um slide separado tenha sido enviado nesse teste.
- Não há correção validada de PowerPoint no OpenMirror. A hipótese de regressão do
  aplicativo/iOS permanece; não afirmamos impossibilidade técnica nem diagnóstico
  oficial da Microsoft. Não modificamos o protocolo por tentativa sem validação.
- APK público testado por ADB e confirmado visualmente com Keynote. Caminho pelo
  Downloader ainda não executado, apesar de documentado como sugestão de instalação.

## Versão 0.1.3 — revisão do cartão horizontal

- A pedido do usuário, cartão Fire TV redesenhado em 640 × 360 com fundo claro,
  telefone/TV e nome ampliados, ocupando quase toda a área. Cinco banners traduzidos.
- Ícones menores também receberam cores claras e símbolo maior. A área segura do
  ícone adaptativo foi mantida; o cartão horizontal não usa a máscara quadrada.
- Build assinado assembleRelease + lintRelease: sucesso em 9s. Atualização instalada
  por pm install -r, com a mesma chave pública, preservando dados e sem desinstalação.
- SHA-256 do APK: `8dda1953bedafbc31168409779b7329c280796735032af991c7a4a2942079d72`.
- Protocolo e decodificação não alterados. Arte horizontal clara revisada no arquivo
  em 640 × 360, sem cortes no nome ou símbolo. A captura da biblioteca do Fire TV
  não foi concluída; confirmação da aparência nessa lista solicitada ao usuário.

### Aparência no launcher Fire TV

A arte horizontal está incluída no pacote e os ícones menores foram clareados e
ampliados. A forma exata como o launcher do Fire TV exibe um APK não foi confirmada
nesta etapa. Há [relato primário de outro projeto](https://github.com/NuvioMedia/NuvioTV/issues/2347)
em Fire OS 8 de uso do ícone quadrado com margens e desconsideração do banner.
Esse relato não prova o comportamento desta versão do OpenMirror no aparelho alvo.
Não prometemos que a inclusão da arte 16:9 remova uma margem imposta pelo launcher.

### Experimento local 0.1.4 — cache e escolha do ícone

- A captura real confirmou que o cartão continuava usando a arte escura antiga
  depois de atualizar o APK e reiniciar o Fire TV.
- Um alias de launcher com banner explícito também não atualizou essa imagem.
- Após desinstalação autorizada e instalação limpa do APK assinado, a captura
  confirmou o símbolo claro novo, ainda quadrado, com faixas cinzas laterais.
  Portanto, a instalação limpa resolveu a imagem antiga, mas não o formato.
- Fornecer a arte horizontal também em application icon e roundIcon foi testado:
  a captura mostrou o banner comprimido horizontalmente em um quadrado, mantendo
  as faixas cinzas laterais. O campo banner e o alias não contornaram esse
  comportamento neste aparelho. Não é uma correção válida para o formato 16:9.
- O APK experimental foi compilado e passou no lint. Devido a arquivos locais
  descarregados pelo iCloud, o teste visual reutilizou o receptor nativo do APK
  anterior; foi verificado que libairplay-jni.so permaneceu idêntica byte a byte.
- O experimento não foi publicado. Manifesto e versão foram restaurados ao código
  público 0.1.3, com ícone claro quadrado sem distorção. Uma instalação limpa da
  versão pública foi escolhida como resultado final. Após essa reinstalação,
  o usuário confirmou no mesmo iPhone/aparelho: conectou e o espelhamento
  funciona normalmente. Essa confirmação não constitui um novo teste separado
  de áudio ou dos modos de apresentação de cada aplicativo.

### Confirmação posterior — cartão e YouTube

- Usuário confirmou a imagem nova do cartão, ainda com faixas cinzas laterais.
- YouTube: som na TV, mas vídeo espelhado com a mesma interface do iPhone, sem
  controles exclusivos no celular. Conexão iniciada pela Central de Controle →
  Espelhamento de Tela, conforme esclarecido pelo usuário.
- Esse teste confirma espelhamento com áudio. Não valida nem refuta transmissão
  independente iniciada no botão AirPlay/transmissão do YouTube. O modo e o destino
  escolhidos pelo emissor precisam ser diferenciados antes de atribuir a causa
  ao receptor. Nenhum teste de envio direto foi realizado nesta confirmação.
