import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:share_extension/other/service.dart';

class SharedContentPage extends StatelessWidget {
  final SharedContent content;

  const SharedContentPage({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Shared Content')),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    log("------------------------>${content.content}");
    log("------------------------>${content.filePath}");
    log("------------------------>${content.type}");
    switch (content.type) {
      case SharedContentType.text:
        return Text(content.content ?? '');
      case SharedContentType.image:
        return Image.file(File(content.filePath!));
      case SharedContentType.document:
        return Text('Document path: ${content.filePath}');
    }
  }
}