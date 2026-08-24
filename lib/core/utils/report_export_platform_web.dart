// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:typed_data';

/// Platform-specific file downloader for Flutter Web (Browser Blob)
Future<bool> saveAndDownloadFile({
  required String filename,
  required Uint8List bytes,
  required String mimeType,
}) async {
  try {
    final blob = html.Blob([bytes], mimeType);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', filename)
      ..style.display = 'none';

    html.document.body?.children.add(anchor);
    anchor.click();
    html.document.body?.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
    return true;
  } catch (e) {
    return false;
  }
}
