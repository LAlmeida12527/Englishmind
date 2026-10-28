# EnglishMind — protótipo

## 📱 Download direto para Android (arm64)

**[Baixar EnglishMind v0.1.2 — APK arm64 (aprox. 17,6 MB)](https://github.com/LAlmeida12527/Englishmind/releases/download/preview-v0.1.2/EnglishMind-v0.1.2-android-arm64-preview.apk)**

Página oficial da prévia: [EnglishMind v0.1.2](https://github.com/LAlmeida12527/Englishmind/releases/tag/preview-v0.1.2).

Esta prévia corrigiu a navegação do botão **Começar prática** e mantém os exercícios, a gravação de voz e o progresso local. **Ainda não há IA conversacional.** Como o pacote usa assinatura de teste gerada no CI, pode ser necessário desinstalar o APK anterior antes de instalar o novo; isso exclui o progresso local daquela instalação.


**Aplicativo Flutter offline-first para Android e Windows.**

Este é o projeto inicial real de um aplicativo de prática de inglês. O objetivo futuro é conversar por voz com IA rodando no próprio dispositivo, sem API paga. **A IA ainda não está implementada.**

## Já implementado

- Interface responsiva de início, prática e progresso.
- Exercícios de inglês com exemplos de erros comuns: improve/improvise, pronounce/pronunciation, eight/eighty e linguagem de jogos.
- Gravação do microfone e reprodução de áudio no aparelho.
- Campo de texto com algumas regras explícitas de feedback; não é IA.
- Contador e data de treinos salvos localmente.
- Workflows de build para Android e Windows.

## Ainda NÃO implementado

- Modelo de linguagem conversacional; reconhecimento de fala offline; síntese de voz.
- Avaliação automática de pronúncia com base em fonemas e áudio original.
- Login Google e sincronização entre dispositivos.
- Banco de dados SQLite durável, assinatura de APK de produção.

O texto reconhecido por voz não comprova que alguém pronunciou uma palavra incorretamente. O protótipo não atribui notas fonéticas.

## Compilar APK diretamente do celular

1. Abra **Actions** neste repositório.
2. Escolha **Build Android APK** e confira a execução iniciada pelo último commit. Se necessário, use **Run workflow**.
3. Se o build terminar com sucesso, abra a execução e, em **Artifacts**, baixe **EnglishMind-Android-debug**.
4. Extraia o ZIP e instale o arquivo `app-debug.apk` no Android.

É um APK de teste, não uma versão de produção. Verifique o código antes de instalar e siga os avisos de segurança do Android.

## Compilar no Windows

Em **Actions**, selecione **Build Windows** > **Run workflow**. Após o sucesso, extraia o pacote completo de arquivos e execute o .exe junto com os demais arquivos do bundle.

## Rodar localmente

```sh
flutter create --platforms=android,windows --project-name englishmind .
dart run tool/configure_android.dart
flutter pub get
flutter analyze
flutter test
flutter build apk --debug
```

## Privacidade

Os áudios ficam apenas em armazenamento temporário no aparelho, sujeito à limpeza do sistema. O progresso fica local neste protótipo. Não há envio a serviços de IA. Para futura sincronização, a configuração exigirá consentimento e regras de segurança, evitando enviar áudios sem necessidade.

Veja [ARCHITECTURE.md](ARCHITECTURE.md) e [CODEX_TASK.md](CODEX_TASK.md).

**Status:** código inicial publicado; resultados de build devem ser confirmados nos GitHub Actions e no Redmi real.
