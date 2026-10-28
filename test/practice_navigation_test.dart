import 'package:englishmind/main.dart';
import 'package:englishmind/data/progress_store.dart';
import 'package:flutter_test/flutter_test.dart';
class FakeProgressStore implements ProgressRepository {
  @override
  Future<PracticeProgress> load() async => PracticeProgress.empty();

  @override
  Future<void> save(PracticeProgress progress) async {}
}

void main() {
  testWidgets('botao Comecar pratica abre a tela com microfone', (tester) async {
    await tester.pumpWidget(EnglishMindApp(progressStore: FakeProgressStore()));
    await tester.pumpAndSettle();

    expect(find.text('Começar prática'), findsOneWidget);
    await tester.tap(find.text('Começar prática'));
    await tester.pumpAndSettle();

    expect(find.text('Gravar minha fala'), findsOneWidget);
    expect(find.textContaining('Em inglês, conte'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
