# EnglishMind — decisões de arquitetura

## Princípios

1. Android e Windows podem funcionar de forma independente e offline.
2. Sem API paga de IA, assinatura obrigatória ou dependência contínua de PC ligado.
3. Modelo de linguagem aberto e pequeno, local, só depois de benchmark em hardware real.
4. Sistema de ensino, memória de erros e treinamento personalizados desenvolvidos neste projeto.
5. Transcrição automática não é avaliação de pronúncia: usar áudio original e avaliação fonética separada.
6. Login Google e sincronização opcional, apenas quando houver internet, com privacidade e controle.

## v0.1 — base inicial

Flutter, gravação/reprodução de voz, lições guiadas, regras textuais simples e progresso local em SharedPreferencesAsync. Não simular respostas de IA nem notas de pronúncia inexistentes.

## v0.2 — dados duráveis

Migrar para SQLite com histórico de eventos, identificadores por dispositivo, testes de migração, exportação e exclusão de dados. Evitar sincronizar contadores usando last-write-wins.

## v0.3 — voz offline

Avaliar reconhecimento e síntese de voz on-device (sherpa-onnx como candidato). Testar variantes do Redmi 12S/Note 12S e PC Ryzen 5 4600G com 8 GB RAM. Medir memória, tamanho de modelo, velocidade e robustez contra ruído.

## v0.4 — conversação com LLM local

Interface de abstração para modelo e backend como llama.cpp. Testar modelos multilíngues quantizados pequenos, conforme licença. Verificar qualidade gramatical e velocidade antes de escolher o modelo. Sem substituição silenciosa por API em nuvem.

## v0.5 — motor educacional

Identificar erros recorrentes, planejar revisão, oferecer correção contextual. Motor de pronúncia com avaliação baseada em áudio e pares mínimos, sem penalizar sotaque indevidamente nem produzir notas falsas.

## v0.6 — login e sincronização

Armazenamento local continua primário. OAuth Google e sincronização segura dos eventos pedagógicos, não gravações de voz por padrão. Regras de acesso obrigatórias, controle de exclusão e cotas gratuitas verificadas. Nunca colocar credenciais secretas dentro do aplicativo.

## Validação

Rodar analyze/test e build Android e Windows no CI; confirmar permissão de microfone, instalação real, modo avião, limpeza de arquivos temporários, estado de permissão negada, falhas de áudio e recuperação de progresso. Documentar todas as limitações.
