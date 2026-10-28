class Lesson {
  const Lesson({
    required this.id,
    required this.title,
    required this.prompt,
    required this.explanation,
    required this.example,
    required this.focus,
  });

  final String id;
  final String title;
  final String prompt;
  final String explanation;
  final String example;
  final String focus;
}

const lessons = <Lesson>[
  Lesson(
    id: 'improve',
    title: 'Improve, não improvise',
    prompt: 'Em inglês, conte qual habilidade você quer melhorar e por quê.',
    example: 'I want to improve my pronunciation because I want to speak more naturally.',
    explanation: 'Improve significa melhorar. Improvise significa improvisar. Pronunciation é o substantivo; pronounce é verbo.',
    focus: 'Naturalidade e escolha de palavras',
  ),
  Lesson(
    id: 'eight',
    title: 'Eight × eighty',
    prompt: 'Diga em inglês que seu celular tem oito gigabytes de RAM. Grave e escute novamente.',
    example: 'My phone has eight gigabytes of RAM.',
    explanation: 'Eight (8) tem uma sílaba, /eɪt/. Eighty (80) tem duas, /ˈeɪti/. Transcrição automática sozinha não prova erro de pronúncia.',
    focus: 'Sons e clareza',
  ),
  Lesson(
    id: 'gaming',
    title: 'Conte uma partida',
    prompt: 'Fale por 20 segundos sobre sua última partida de Valorant ou outro jogo.',
    example: 'Yesterday I played Valorant. I got three kills in one round, but we lost the match.',
    explanation: 'Para eliminações em jogos, got three kills costuma soar mais natural do que made three kills.',
    focus: 'Fluência e frases naturais',
  ),
  Lesson(
    id: 'thinking',
    title: 'Pense diretamente em inglês',
    prompt: 'Descreva o que você fez hoje sem traduzir mentalmente uma frase pronta do português.',
    example: 'I woke up, had breakfast, and spent some time studying English.',
    explanation: 'O objetivo não é repetir o exemplo, mas construir sua própria frase. Uma forma válida pode ter várias alternativas naturais.',
    focus: 'Produção espontânea',
  ),
];
