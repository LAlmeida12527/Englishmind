import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../core/feedback_engine.dart';
import '../core/lesson.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key, required this.lesson, required this.onCompleted});
  final Lesson lesson;
  final Future<void> Function(String lessonId) onCompleted;

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  final _recorder = AudioRecorder();
  final _player = AudioPlayer();
  final _answer = TextEditingController();
  bool _recording = false;
  bool _busy = false;
  bool _completed = false;
  String? _recordedPath;
  String? _error;
  List<TextObservation>? _observations;

  @override
  void initState() {
    super.initState();
    _answer.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _answer.dispose();
    _recorder.dispose();
    _player.dispose();
    super.dispose();
  }

  Future<void> _toggleRecording() async {
    if (_busy) return;
    setState(() { _busy = true; _error = null; });
    try {
      if (_recording) {
        final path = await _recorder.stop();
        if (!mounted) return;
        setState(() { _recordedPath = path; _recording = false; });
      } else {
        if (!await _recorder.hasPermission()) {
          throw StateError('Permissão do microfone não concedida.');
        }
        final dir = await getTemporaryDirectory();
        final path = '${dir.path}${Platform.pathSeparator}englishmind_${DateTime.now().microsecondsSinceEpoch}.m4a';
        await _recorder.start(const RecordConfig(encoder: AudioEncoder.aacLc), path: path);
        if (!mounted) return;
        setState(() { _recording = true; _recordedPath = null; });
      }
    } catch (e) {
      if (mounted) setState(() { _error = 'Não foi possível usar o microfone: $e'; });
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _listen() async {
    final path = _recordedPath;
    if (path == null) return;
    try {
      await _player.stop();
      await _player.play(DeviceFileSource(path));
    } catch (e) {
      if (mounted) setState(() { _error = 'Não foi possível reproduzir o áudio: $e'; });
    }
  }

  void _checkText() {
    setState(() => _observations = const FeedbackEngine().inspect(_answer.text));
  }

  Future<void> _complete() async {
    if (_completed || _recording || _busy) return;
    setState(() => _busy = true);
    try {
      await widget.onCompleted(widget.lesson.id);
      if (mounted) setState(() => _completed = true);
    } catch (e) {
      if (mounted) setState(() { _error = 'Não foi possível salvar o treino: $e'; });
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lesson = widget.lesson;
    return Scaffold(
      appBar: AppBar(title: Text(lesson.title)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 740),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(lesson.focus.toUpperCase(), style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.primary)),
                const SizedBox(height: 10),
                Text(lesson.prompt, style: theme.textTheme.headlineSmall),
                const SizedBox(height: 24),
                Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('EXEMPLO', style: theme.textTheme.labelSmall),
                    const SizedBox(height: 8),
                    SelectableText(lesson.example, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 12),
                    Text(lesson.explanation),
                  ],
                ))),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _busy ? null : _toggleRecording,
                  icon: Icon(_recording ? Icons.stop_circle_outlined : Icons.mic),
                  label: Text(_recording ? 'Parar gravação' : 'Gravar minha fala'),
                ),
                if (_recording) const Padding(padding: EdgeInsets.all(8), child: Text('● Gravando localmente, sem envio para servidores.', textAlign: TextAlign.center)),
                if (_recordedPath != null) OutlinedButton.icon(
                  onPressed: _listen,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Escutar minha gravação'),
                ),
                const SizedBox(height: 8),
                Text('Se quiser, escreva o que você tentou dizer. Esta análise é de TEXTO, não de pronúncia.', style: theme.textTheme.bodySmall),
                const SizedBox(height: 8),
                TextField(controller: _answer, maxLines: 3, decoration: const InputDecoration(
                  labelText: 'Minha resposta em inglês (opcional)',
                  border: OutlineInputBorder(),
                )),
                const SizedBox(height: 8),
                OutlinedButton.icon(onPressed: _checkText, icon: const Icon(Icons.spellcheck), label: const Text('Verificar padrões conhecidos')),
                if (_observations != null) ...[
                  const SizedBox(height: 12),
                  if (_observations!.isEmpty)
                    const Text('Nenhum padrão conhecido encontrado. Isso NÃO significa que a frase esteja correta ou incorreta.'),
                  for (final item in _observations!) Card(child: ListTile(
                    title: Text(item.title),
                    subtitle: Text('${item.explanation}${item.suggestion == null ? '' : '\nExemplo: ${item.suggestion}'}'),
                  )),
                ],
                if (_error != null) Padding(padding: const EdgeInsets.all(12), child: Text(_error!, style: TextStyle(color: theme.colorScheme.error))),
                const SizedBox(height: 18),
                FilledButton.tonalIcon(
                  onPressed: (_busy || _recording || _completed || (_recordedPath == null && _answer.text.trim().isEmpty)) ? null : _complete,
                  icon: Icon(_completed ? Icons.check_circle : Icons.task_alt),
                  label: Text(_completed ? 'Treino salvo neste dispositivo' : 'Concluir treino'),
                ),
                const SizedBox(height: 12),
                const Text('Protótipo v0.1: grava/reproduz sua voz e oferece regras textuais limitadas. Ainda não há IA conversacional, avaliação fonética ou sincronização Google.', textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
