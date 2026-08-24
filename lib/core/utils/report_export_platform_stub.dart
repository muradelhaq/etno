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
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);

    final xFile = XFile(file.path, mimeType: mimeType, name: filename);
    await Share.shareXFiles(
      [xFile],
      text: 'Laporan Rekapitulasi E-Modul Etnosains: $filename',
      subject: 'Laporan E-Modul Etnosains',
    );
    return true;
  } catch (e) {
    return false;
  }
}
