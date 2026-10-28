import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/lesson.dart';
import 'data/progress_store.dart';
import 'features/practice_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const EnglishMindApp());
}

class EnglishMindApp extends StatefulWidget {
  const EnglishMindApp({super.key, this.progressStore});

  /// Permite testes isolados sem depender do armazenamento nativo.
  final ProgressStore? progressStore;

  @override
  State<EnglishMindApp> createState() => _EnglishMindAppState();
}

class _EnglishMindAppState extends State<EnglishMindApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  late final ProgressStore _store;
  PracticeProgress? _progress;
  String? _loadError;
  int _tab = 0;

  @override
  void initState() {
    super.initState();
    _store = widget.progressStore ?? ProgressStore(SharedPreferencesAsync());
    _load();
  }

  Future<void> _load() async {
    try {
      final progress = await _store.load();
      if (mounted) setState(() => _progress = progress);
    } catch (e) {
      if (mounted) setState(() => _loadError = e.toString());
    }
  }

  Future<void> _markCompleted(String id) async {
    final next = _progress!.complete(id);
    await _store.save(next);
    if (mounted) setState(() => _progress = next);
  }

  void _openLesson(Lesson lesson) {
    // Este State fica ACIMA do MaterialApp; Navigator.of(context) aqui
    // falhava no Android. Use o NavigatorState criado pelo MaterialApp.
    final navigator = _navigatorKey.currentState;
    if (navigator == null) {
      debugPrint('EnglishMind: navegador ainda indisponível');
      return;
    }
    navigator.push(MaterialPageRoute<void>(
      builder: (_) => PracticeScreen(lesson: lesson, onCompleted: _markCompleted),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(seedColor: const Color(0xFF8B8AF8), brightness: Brightness.dark);
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'EnglishMind',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        scaffoldBackgroundColor: const Color(0xFF11121A),
        cardTheme: const CardThemeData(margin: EdgeInsets.symmetric(vertical: 6), elevation: 0),
      ),
      home: _loadError != null
          ? Scaffold(body: Center(child: Text('Erro ao carregar dados locais: $_loadError')))
          : _progress == null
              ? const Scaffold(body: Center(child: CircularProgressIndicator()))
              : LayoutBuilder(builder: (context, constraints) {
                  final wide = constraints.maxWidth >= 760;
                  final content = switch (_tab) {
                    0 => _HomeTab(progress: _progress!, onOpen: _openLesson),
                    1 => _LessonsTab(onOpen: _openLesson, progress: _progress!),
                    _ => _ProgressTab(progress: _progress!),
                  };
                  return Scaffold(
                    appBar: AppBar(title: const Text('EnglishMind'), actions: const [
                      Padding(padding: EdgeInsets.only(right: 12), child: Center(child: Text('OFFLINE • v0.1'))),
                    ]),
                    body: wide
                        ? Row(children: [
                            NavigationRail(
                              selectedIndex: _tab,
                              extended: constraints.maxWidth >= 1000,
                              onDestinationSelected: (index) => setState(() => _tab = index),
                              destinations: const [
                                NavigationRailDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: Text('Início')),
                                NavigationRailDestination(icon: Icon(Icons.record_voice_over_outlined), selectedIcon: Icon(Icons.record_voice_over), label: Text('Praticar')),
                                NavigationRailDestination(icon: Icon(Icons.insights_outlined), selectedIcon: Icon(Icons.insights), label: Text('Progresso')),
                              ],
                            ),
                            const VerticalDivider(width: 1),
                            Expanded(child: content),
                          ])
                        : content,
                    bottomNavigationBar: wide ? null : NavigationBar(
                      selectedIndex: _tab,
                      onDestinationSelected: (index) => setState(() => _tab = index),
                      destinations: const [
                        NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Início'),
                        NavigationDestination(icon: Icon(Icons.record_voice_over_outlined), selectedIcon: Icon(Icons.record_voice_over), label: 'Praticar'),
                        NavigationDestination(icon: Icon(Icons.insights_outlined), selectedIcon: Icon(Icons.insights), label: 'Progresso'),
                      ],
                    ),
                  );
                }),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab({required this.progress, required this.onOpen});
  final PracticeProgress progress;
  final void Function(Lesson lesson) onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final recommended = lessons.reduce((a, b) =>
      (progress.completed[a.id] ?? 0) <= (progress.completed[b.id] ?? 0) ? a : b);
    return _Page(
      children: [
        const SizedBox(height: 12),
        Text('Fale mais. Traduza menos.', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text('Seu laboratório de inglês, começando pelo que pode funcionar completamente offline.', style: theme.textTheme.bodyLarge),
        const SizedBox(height: 18),
        Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [Icon(Icons.auto_awesome, color: theme.colorScheme.primary), const SizedBox(width: 8), const Text('PRÓXIMO TREINO')]),
            const SizedBox(height: 12),
            Text(recommended.title, style: theme.textTheme.titleLarge),
            const SizedBox(height: 6),
            Text(recommended.prompt),
            const SizedBox(height: 12),
            FilledButton.icon(onPressed: () => onOpen(recommended), icon: const Icon(Icons.mic), label: const Text('Começar prática')),
          ],
        ))),
        const SizedBox(height: 12),
        Text('Como funciona agora', style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        const _InformationTile(icon: Icons.mic_none, title: 'Grave sua voz', subtitle: 'O áudio permanece no dispositivo. Grave e ouça de novo.'),
        const _InformationTile(icon: Icons.spellcheck, title: 'Aprenda expressões naturais', subtitle: 'Regras transparentes identificam alguns padrões comuns em texto.'),
        const _InformationTile(icon: Icons.security_outlined, title: 'Sem API, sem conta obrigatória', subtitle: 'Este protótipo não manda suas respostas para a nuvem.'),
      ],
    );
  }
}

class _LessonsTab extends StatelessWidget {
  const _LessonsTab({required this.onOpen, required this.progress});
  final void Function(Lesson lesson) onOpen;
  final PracticeProgress progress;

  @override
  Widget build(BuildContext context) {
    return _Page(children: [
      Text('Prática guiada', style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 8),
      const Text('Escolha uma situação e fale em inglês. Você pode gravar, escutar e escrever uma resposta opcional.'),
      const SizedBox(height: 12),
      for (final lesson in lessons) Card(child: ListTile(
        leading: const Icon(Icons.record_voice_over_outlined),
        title: Text(lesson.title),
        subtitle: Text('${lesson.focus} • ${progress.completed[lesson.id] ?? 0} treino(s)'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => onOpen(lesson),
      )),
    ]);
  }
}

class _ProgressTab extends StatelessWidget {
  const _ProgressTab({required this.progress});
  final PracticeProgress progress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _Page(children: [
      Text('Seu progresso', style: theme.textTheme.headlineMedium),
      const SizedBox(height: 12),
      Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${progress.total}', style: theme.textTheme.displayMedium),
          const Text('Treinos concluídos neste dispositivo'),
          const SizedBox(height: 8),
          Text(progress.lastPracticed == null
              ? 'Você ainda não concluiu nenhum treino.'
              : 'Último treino: ${progress.lastPracticed!.toLocal().day}/${progress.lastPracticed!.toLocal().month}/${progress.lastPracticed!.toLocal().year}'),
        ],
      ))),
      const SizedBox(height: 12),
      for (final lesson in lessons) ListTile(
        title: Text(lesson.title),
        trailing: Text('${progress.completed[lesson.id] ?? 0}×'),
      ),
      const SizedBox(height: 24),
      const _InformationTile(icon: Icons.info_outline, title: 'Sincronização será adicionada', subtitle: 'A versão atual salva apenas no aparelho. Login Google e sincronização ainda NÃO estão implementados.'),
    ]);
  }
}

class _InformationTile extends StatelessWidget {
  const _InformationTile({required this.icon, required this.title, required this.subtitle});
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: Icon(icon),
    title: Text(title),
    subtitle: Text(subtitle),
  );
}

class _Page extends StatelessWidget {
  const _Page({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => SafeArea(child: Center(child: ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 840),
    child: ListView(padding: const EdgeInsets.fromLTRB(20, 20, 20, 32), children: children),
  )));
}
