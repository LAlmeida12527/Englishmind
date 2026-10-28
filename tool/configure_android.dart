import 'dart:io';

/// Execute after flutter create --platforms=android .
void main() {
  final path = 'android/app/src/main/AndroidManifest.xml';
  final file = File(path);
  if (!file.existsSync()) {
    stderr.writeln('Missing $path. Run flutter create --platforms=android . first.');
    exitCode = 1;
    return;
  }
  var xml = file.readAsStringSync();
  if (!xml.contains('android.permission.RECORD_AUDIO')) {
    final manifest = RegExp(r'<manifest\b[^>]*>');
    if (!manifest.hasMatch(xml)) {
      stderr.writeln('Could not locate <manifest> tag');
      exitCode = 1;
      return;
    }
    xml = xml.replaceFirstMapped(manifest, (match) =>
      '${match.group(0)}\n    <uses-permission android:name="android.permission.RECORD_AUDIO" />');
  }
  xml = xml.replaceAll('android:label="englishmind"', 'android:label="EnglishMind"');
  file.writeAsStringSync(xml);
  stdout.writeln('Configured Android microphone permission and app label.');
}
