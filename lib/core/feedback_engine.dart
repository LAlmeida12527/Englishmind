/// Simple, transparent text-based observations — NOT AI and NOT audio evaluation.
/// Rules must avoid claiming a learner made a mistake based on ASR alone.
class TextObservation {
  const TextObservation({required this.title, required this.explanation, this.suggestion});
  final String title;
  final String explanation;
  final String? suggestion;
}

class FeedbackEngine {
  const FeedbackEngine();

  List<TextObservation> inspect(String text) {
    final input = text.trim();
    if (input.isEmpty) return const [];
    final notes = <TextObservation>[];
    if (RegExp(r'\bimprovise\s+my\s+(?:pronounce|pronunciation|english)\b', caseSensitive: false).hasMatch(input)) {
      notes.add(const TextObservation(
        title: 'Improve × improvise',
        explanation: 'Para melhorar uma habilidade, use improve. Improvise significa improvisar.',
        suggestion: 'I want to improve my pronunciation.',
      ));
    }
    if (RegExp(r'\bmy\s+pronounce\b', caseSensitive: false).hasMatch(input)) {
      notes.add(const TextObservation(
        title: 'Pronounce × pronunciation',
        explanation: 'Pronounce é um verbo. Para dizer "minha pronúncia", use my pronunciation.',
        suggestion: 'My pronunciation is improving.',
      ));
    }
    if (RegExp(r'\bmaked\s+(?:three|two|four|five|\d+)\s+kills?\b', caseSensitive: false).hasMatch(input)) {
      notes.add(const TextObservation(
        title: 'Expressão de jogo',
        explanation: 'Maked não é passado de make, e em jogos a expressão got three kills é mais natural.',
        suggestion: 'I got three kills.',
      ));
    }
    if (RegExp(r'\bdifficulty\s+to\s+speak\b', caseSensitive: false).hasMatch(input)) {
      notes.add(const TextObservation(
        title: 'Construção natural',
        explanation: 'Após have difficulty, costuma-se usar o verbo com -ing.',
        suggestion: 'I have difficulty speaking English.',
      ));
    }
    return notes;
  }
}
