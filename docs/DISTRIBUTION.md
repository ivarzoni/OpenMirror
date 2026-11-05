# Distribuição do beta

O pacote público usa build release não depurável e assinatura própria, distinta da
assinatura debug usada nos testes iniciais. Chave e senhas foram mantidas no Mac,
fora do repositório, e nunca devem ser enviadas ao GitHub. Preserve backup privado
da pasta de assinatura e de sua senha: atualizações precisam da mesma chave.

Para reproduzir a compilação assinada, crie fora do repositório um arquivo privado
com storeFile, storePassword, keyAlias e keyPassword, apontando para a sua chave:

```bash
./gradlew -PopenmirrorSigningProperties=/caminho/privado/release.properties assembleRelease lintRelease
```

Sem essa opção, o build debug continua funcionando; assembleRelease não recebe uma
assinatura de distribuição automaticamente. Não publique o APK release sem assinatura.

A tag da versão identifica o fonte correspondente; o GitHub fornece arquivos de fonte
para download. Licenças e fontes de dependências permanecem no projeto, e o OpenSSL
é reconstruído a partir do arquivo oficial de fonte com SHA-256 fixado.

Para o público: link direto para o APK, guia em português e arquivo opcional ZIP
com APK + guia + GPL + hash. Não inclua chaves de assinatura, logs, IPs ou documentos
pessoais. O beta precisa mostrar seus limites, especialmente o modo de apresentação
do PowerPoint. APK é para Fire TV, não para instalar no iPhone.

O caminho de instalação pelo Downloader precisa de validação separada. A publicação
na Amazon Appstore é uma possibilidade futura para simplificar a instalação, sujeita
à conta de desenvolvedor e revisão; não foi submetida nem aprovada.
