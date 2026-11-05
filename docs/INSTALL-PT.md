# Instalar o OpenMirror no Fire TV

**O APK é instalado no Fire TV. No iPhone, use o Espelhamento de Tela nativo.**
Esta é uma versão experimental. Veja o pacote e as limitações em [Releases](https://github.com/ivarzoni/OpenMirror/releases).

ANTES DE INSTALAR

Testado com Fire TV Stick 4K de 2ª geração, Fire OS 8.1.8.5,
e iPhone 15 Pro Max com iOS 27.2. Outros modelos ainda não foram validados.
É um APK ARM de 32 bits, para Fire OS baseado em Android.

INSTALAÇÃO SEM COMPUTADOR — CAMINHO SUGERIDO

1. No Fire TV, procure Downloader by AFTVnews na Amazon Appstore.
   Instale o aplicativo oficial desse desenvolvedor, se disponível na sua região.
2. Abra o Downloader e acesse:
   https://github.com/ivarzoni/OpenMirror
   Na página, procure a seção de download/versões e selecione o arquivo
   OpenMirror-0.1.3.apk. Não baixe Source code: isso é o código para desenvolvedores.
3. Se a TV pedir permissão de instalação, abra Configurações > Meu Fire TV >
   Opções do desenvolvedor > Instalar aplicativos desconhecidos e permita o Downloader.
   Se as opções de desenvolvedor não aparecerem, entre em Sobre, pressione sete
   vezes o nome do Fire TV e volte um nível.
4. Volte ao Downloader e confirme Instalar. Depois, abra OpenMirror.

Esse caminho pelo Downloader é sugerido com base no funcionamento documentado
pelo seu desenvolvedor; ainda não foi testado por nós nesta versão. Algumas versões
Fire OS têm diferenças no menu. Se não aparecer a permissão, consulte o guia no GitHub.
Para esse caminho não é necessário ativar ADB. Não abra portas no roteador.
O APK público assinado foi instalado por ADB e validado com Keynote. O caminho
pelo Downloader ainda precisa de teste separado.

COMO CONECTAR

1. Conecte iPhone e Fire TV à mesma rede Wi-Fi.
2. Abra o OpenMirror e mantenha a tela de instruções aberta na TV.
3. No iPhone, abra a Central de Controle e toque em Espelhamento de Tela.
4. Selecione OpenMirror (experimental).
5. Abra Fotos, seu leitor PDF ou o aplicativo que deseja mostrar.
   Para notas no celular e apenas o slide na TV, o Keynote foi validado.

Idioma da tela: segue o Fire TV. Português, inglês, espanhol, francês e italiano.

O QUE JÁ TESTAMOS

- Tela do iPhone aparecendo na TV.
- Fotos com apresentação e vídeos com áudio na TV.
- YouTube com som na TV.
- PDF espelhado igual ao iPhone, sem modo especial do receptor.
- Keynote com slide em tela cheia na TV e notas/próximo slide/controles no iPhone.
- Tela de conexão ocultando corretamente ao iniciar o espelhamento.

LIMITES IMPORTANTES DO BETA

PowerPoint 2.115.2 espelhou a tela, mas não separou notas e slides no teste.
Ainda não há correção confirmada para esse comportamento.
Vídeo protegido por DRM não faz parte do escopo. Não há promessa de 4K ou 60 fps.
Estabilidade em sessões longas e funcionamento sem internet externa ainda não
foram medidos. YouTube e aplicativos de terceiros podem precisar de internet.
O receptor aceita conexões da rede local sem PIN; use sua rede de confiança.
Apenas o app é gratuito e sem assinatura; serviços de terceiros têm regras próprias.

ATUALIZAÇÕES

Os APKs públicos usam uma chave própria de assinatura. Guarde o pacote original
ou baixe atualizações somente do repositório oficial.
A versão interna debug instalada durante o desenvolvimento tem assinatura diferente:
ela não pode ser atualizada diretamente com este APK público. A troca exige reinstalar
uma vez e apaga as configurações/chaves locais do OpenMirror. Não afeta arquivos do iPhone.


Fontes do procedimento: [Downloader, pelo seu desenvolvedor](https://www.aftvnews.com/downloader/),
[permissão por aplicativo no Fire TV](https://community.amazondeveloper.com/t/unable-to-install-over-adb-with-recent-update/28012/3)
e [instalação por ADB, pela Amazon](https://developer.amazon.com/docs/fire-tv/installing-and-running-your-app.html).
