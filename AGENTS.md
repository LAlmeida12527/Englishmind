# EnglishMind — instruções para agentes de código

## Visão do produto
Aplicativo Flutter instalável em Android e Windows para ensino de inglês, com **conversação e pronúncia** igualmente importantes. Offline-first, sem API paga. O modelo futuro executará no próprio dispositivo; o celular não pode depender de PC ligado. Sincronização opcional futura, após autenticação do usuário.

## Contexto atual
O branch `main` já tem uma v0.1: exercícios guiados, gravação/reprodução do microfone, feedback textual por regras, progresso local. A navegação de "Começar prática" foi corrigida para usar `GlobalKey<NavigatorState>`; há teste `test/practice_navigation_test.dart`. **Não existe ainda IA conversacional, ASR offline, TTS offline, avaliação fonética ou login Google.**

## Prioridades de engenharia
1. **Aplicativo instalável e fácil de baixar no celular.** GitHub Actions deve gerar um APK arm64 pequeno e oferecer download direto em GitHub Releases, sem depender de um ZIP de artifact da aba Actions. Marcar como prévia, não produção. Não divulgar APK que não passou por analyze/test/build.
2. **Voz local utilizável.** Gravar, parar, reproduzir; orientar permissões Android e testar estados de negação, retorno de background e erros do gravador. Implementar TTS local/fallback somente se houver suporte real e verificar disponibilidade offline.
3. **Abstrações testáveis:** `SpeechToTextEngine`, `TextToSpeechEngine`, `ConversationEngine`, `PronunciationEvaluator`, sem classes gigantes. Nenhuma transcrição pode ser apresentada como diagnóstico acústico de pronúncia.
4. **Testar um modelo conversacional pequeno on-device** apenas após medir memória, latência e fluência de inglês com modelos de licença adequada. Sem enviar áudio ou texto para serviços pagos. Se não cumprir qualidade mínima, documentar limites e manter a experiência funcional sem inventar IA.
5. **Dados e sync:** eventos de treino locais; quando houver migração para SQLite, preservar dados prévios, permitir exportação e exclusão. Futuro login Google com sincronização segura apenas do progresso, não de gravações por padrão.

## Regras de trabalho
- Antes de modificar, leia `README.md`, `ARCHITECTURE.md`, `CODEX_TASK.md` e arquivos relacionados.
- Evite reler o projeto inteiro a cada alteração; limite contexto ao módulo envolvido.
- Crie mudanças pequenas e testes reproduzíveis; execute `flutter analyze`, `flutter test` e build de APK no CI.
- Não peça credenciais, não publique segredos, não comite áudios pessoais.
- Não apague/edite outros repositórios; escopo exclusivo: `LAlmeida12527/Englishmind`.
- Não marque recursos planejados como implementados ou testados em dispositivos reais se só foram testados no CI.
- O APK não deve conter pesos enormes por padrão; modelos podem ser baixados opcionalmente com checksum e licença exibidos.
- Se necessário mudar o certificado de assinatura, alertar que APKs antigos podem exigir desinstalação, causando perda do progresso local. Nunca commitar chave de assinatura privada.
