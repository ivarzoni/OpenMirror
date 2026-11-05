# Registro de validação — 5 de novembro de 2026

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
- Instalação, descoberta no iPhone, handshake, vídeo e apresentação: NÃO TESTADOS.
- Modelo de iPhone e versão iOS ainda não informados.

Warnings do build inicial: apenas ABI 32 bits; avisos de versão de XML SDK e APIs
Android obsoletas. O protótipo é para sideload, não uma publicação Google Play.
Um APK compilado não constitui validação de compatibilidade.
