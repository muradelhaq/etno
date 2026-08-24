import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Platform-specific file downloader for Mobile & Desktop (IO)
Future<bool> saveAndDownloadFile({
  required String filename,
  required Uint8List bytes,
  required String mimeType,
}) async {
  try {
    Directory tempDir;
    try {
      tempDir = await getTemporaryDirectory();
    } catch (_) {
      tempDir = Directory.systemTemp;
    }

    final file = File('${tempDir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);

    try {
      final xFile = XFile(file.path, mimeType: mimeType, name: filename);
      await Share.shareXFiles(
        [xFile],
        text: 'Laporan Rekapitulasi E-Modul Etnosains: $filename',
        subject: 'Laporan E-Modul Etnosains',
      );
    } catch (_) {
      // In headless test environments or devices without share target, saving file is still successful
    }
    return true;
  } catch (e) {
    return false;
  }
}
