import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Local prototype storage. Migrate to transactional SQLite before real sync.
class ProgressStore {
  ProgressStore(this._prefs);
  final SharedPreferencesAsync _prefs;
  static const _key = 'englishmind_progress_v1';

  Future<PracticeProgress> load() async {
    final raw = await _prefs.getString(_key);
    if (raw == null) return PracticeProgress.empty();
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return PracticeProgress.fromJson(decoded);
    } catch (_) {
      // Never overwrite a malformed record automatically; a future recovery
      // screen should let the learner export it.
      return PracticeProgress.empty();
    }
  }

  Future<void> save(PracticeProgress progress) async {
    await _prefs.setString(_key, jsonEncode(progress.toJson()));
  }
}

class PracticeProgress {
  PracticeProgress({required this.completed, required this.lastPracticed});
  factory PracticeProgress.empty() => PracticeProgress(completed: {}, lastPracticed: null);
  factory PracticeProgress.fromJson(Map<String, dynamic> json) {
    final raw = json['completed'];
    final counts = <String, int>{};
    if (raw is Map) {
      for (final entry in raw.entries) {
        if (entry.key is String && entry.value is num) {
          counts[entry.key as String] = (entry.value as num).toInt().clamp(0, 1000000).toInt();
        }
      }
    }
    final date = json['lastPracticed'];
    return PracticeProgress(
      completed: counts,
      lastPracticed: date is String ? DateTime.tryParse(date) : null,
    );
  }

  final Map<String, int> completed;
  final DateTime? lastPracticed;
  int get total => completed.values.fold(0, (a, b) => a + b);

  PracticeProgress complete(String lessonId) {
    return PracticeProgress(
      completed: {...completed, lessonId: (completed[lessonId] ?? 0) + 1},
      lastPracticed: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'schemaVersion': 1,
        'completed': completed,
        'lastPracticed': lastPracticed?.toUtc().toIso8601String(),
      };
}
