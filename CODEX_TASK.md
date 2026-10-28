# Tarefa de continuação para Codex — EnglishMind

Você está trabalhando DENTRO do repositório Flutter EnglishMind. Há uma v0.1 inicial com exercícios e áudio gravado, mas ainda sem IA, sincronização ou reconhecimento automático.

## Contexto do produto

Usuário com Redmi 12S/Note 12S (reportados 8 GB RAM) e PC Windows Ryzen 5 4600G, 8 GB RAM single-channel, temporariamente sem acesso ao computador. Deseja aplicativo Android e Windows independentes, sem API paga. Progressos sincronizados futuramente por login Google; conversação e pronúncia com mesma prioridade.

## Faça primeiro

1. Leia README, ARCHITECTURE, pubspec e somente os arquivos ligados às tarefas.
2. Rode flutter analyze, flutter test e flutter build apk --debug; resolva problemas reais de dependências, plataforma e permissões sem remover testes.
3. Confira o workflow de Windows. Reporte limites de validação sem aparelho físico.
4. Teste gravação/parada/reprodução, erros de permissão do microfone, limpeza de arquivos temporários, navegação e progresso persistente.
5. Registre o status comprovado do build no README.

## Depois

- Banco SQLite com migração segura do armazenamento anterior e testes de sincronização eventual.
- Contratos separados para ASR, TTS, LLM e avaliação fonética. Nada de IA simulada.
- Benchmark de modelos totalmente offline com tamanhos e licenças documentados.
- Avaliação de pronúncia baseada no áudio, não somente em speech-to-text.
- Sincronização Google após autorização do usuário, com regras de segurança e sem upload automático de áudio.

## Regras

Sem API paga, não introduza custos ocultos; não commite tokens/segredos; não armazene gravações no GitHub; não transforme tudo numa God Class; não finja testes nem pontuações fonéticas. Priorize entregas que rodem no Redmi, com passos claros para obter o APK via GitHub Actions.
