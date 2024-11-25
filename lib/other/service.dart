import 'dart:io';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class ShareHandlerService {
  static Future<SharedContent?> handleSharedContent() async {
    try {
      // Listen for shared files (images/documents)
      List<SharedMediaFile> sharedFiles = await ReceiveSharingIntent.instance.getInitialMedia();

      if (sharedFiles.isNotEmpty) {
        final file = File(sharedFiles.first.path);
        final extension = file.path.split('.').last.toLowerCase();

        return SharedContent(
          content: file.path,
          type: _getContentType(extension),
          filePath: file.path,
        );
      }

      return null; // No content received
    } catch (e) {
      print('Error handling shared content: $e');
      return null;
    }
  }

  static SharedContentType _getContentType(String extension) {
    switch (extension) {
      case 'jpg':
      case 'jpeg':
      case 'png':
        return SharedContentType.image;
      default:
        return SharedContentType.document;
    }
  }
}

enum SharedContentType {
  text,
  image,
  document,
}

class SharedContent {
  final SharedContentType type;
  final String? content;
  final String? filePath;

  SharedContent({
    required this.type,
    this.content,
    this.filePath,
  });
}
