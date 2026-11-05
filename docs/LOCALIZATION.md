# Idioma da interface

O OpenMirror usa a seleção nativa de recursos Android/Fire OS. O idioma da tela
inicial, mensagens, aviso ao sair e banner da lista de apps segue o Fire TV.

| Idioma | Recursos |
|---|---|
| Inglês e alternativa para idiomas não traduzidos | values / drawable-xhdpi |
| Português | values-pt / drawable-pt-xhdpi |
| Espanhol | values-es / drawable-es-xhdpi |
| Francês | values-fr / drawable-fr-xhdpi |
| Italiano | values-it / drawable-it-xhdpi |

As variantes regionais usam a tradução geral correspondente. No aparelho de teste,
o sistema informou pt-BR. A seleção não modifica as configurações globais da TV.
Se o idioma do sistema for alterado, reabra o aplicativo para garantir a atualização
da tela e das mensagens do serviço.

A tela de espera aparece antes de qualquer iPhone conectar. Não há mecanismo
implementado que obtenha de forma confiável o idioma do iPhone para substituir
a preferência do Fire TV. O nome de descoberta OpenMirror (experimental) é estável,
compartilhado entre a interface e o receptor e não traduzido.

Os textos de versão são formatados com BuildConfig.VERSION_NAME. A identidade
OpenMirror e Presentation Edition permanece igual em todos os idiomas.

## Manutenção da identidade

O desenho original está em branding/mark.json e branding/openmirror-icon.svg.
Ícones adaptativos usam vetores; PNGs por densidade e banners traduzidos estão
incluídos no repositório e não exigem ferramentas extras no build do APK.
Para regenerar os desenhos no Mac com Swift instalado:

```bash
python3 scripts/render_branding.py
```

Esse comando usa apenas bibliotecas padrão Python e frameworks de desenho do macOS.
Nenhuma imagem é buscada ou gerada por serviço externo. Arte e scripts são cobertos
pela licença GPL-3.0 do projeto.
