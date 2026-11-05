# Registro de validação — 5 de novembro de 2026

## Resultado atual

Primeiro espelhamento de tela confirmado visualmente pelo usuário no iPhone 15 Pro Max
com iOS 27.2 (modelo/versão informados pelo usuário), para Fire TV Stick 4K de 2ª geração,
modelo AFTKM, Fire OS 8.1.8.5 / Android 11 (confirmados por ADB). Logs do receptor
registraram negociação, vídeo H.264 recebido e callback de quadro exibido. Instalação
concluída e integridade do APK conferida. Conteúdo correto confirmado pelo relato do usuário.

PowerPoint espelhado e áudio do YouTube na TV foram confirmados pelo usuário;
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
