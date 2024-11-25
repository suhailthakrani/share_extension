import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'other/service.dart';
import 'other/shared_content_page.dart';
class GlobalNavigator {
  static final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();
}

void main() {
  runApp(MyMyApp());
}

class MyMyApp extends StatelessWidget {
  const MyMyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: GlobalNavigator.key,
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  StreamSubscription? _sharedContentSub;

  @override
  void initState() {
    super.initState();
    // Handle shared content when app is in background
    _sharedContentSub = ReceiveSharingIntent.instance.getMediaStream().listen((value) {
      _handleSharedContent();
    });

    // Handle shared content when app is launched from scratch
    ReceiveSharingIntent.instance.getInitialMedia().then((value) {
      _handleSharedContent();
    });
  }

  Future<void> _handleSharedContent() async {
    final sharedContent = await ShareHandlerService.handleSharedContent();
    if (sharedContent != null) {
      // Use GlobalNavigator instead of context-based navigation
      GlobalNavigator.key.currentState?.push(
        MaterialPageRoute(
          builder: (context) => SharedContentPage(content: sharedContent),
        ),
      );
    }
  }

  @override
  void dispose() {
    _sharedContentSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Text("${_sharedContentSub != null}"),
        ),
      );
  }
}


