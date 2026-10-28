import 'package:flutter_test/flutter_test.dart';
import 'package:englishmind/core/feedback_engine.dart';
import 'package:englishmind/data/progress_store.dart';

void main() {
  const engine = FeedbackEngine();

  test('detects improve / improvise confusion', () {
    final notes = engine.inspect('I want to improvise my pronunciation.');
    expect(notes.any((n) => n.title == 'Improve × improvise'), isTrue);
  });

  test('detects pronounce used as a noun', () {
    final notes = engine.inspect('I want to improve my pronounce.');
    expect(notes.any((n) => n.title == 'Pronounce × pronunciation'), isTrue);
  });

  test('does not invent errors for unfamiliar valid sentences', () {
    expect(engine.inspect('My English is not good.'), isEmpty);
  });

  test('does not confuse eighty with an audio pronunciation diagnosis', () {
    expect(engine.inspect('I have eighty gigabytes of RAM.'), isEmpty);
  });

  test('progress serializes and counts lessons', () {
    final first = PracticeProgress.empty().complete('eight').complete('eight');
    final again = PracticeProgress.fromJson(first.toJson());
    expect(again.total, 2);
    expect(again.completed['eight'], 2);
  });
}
