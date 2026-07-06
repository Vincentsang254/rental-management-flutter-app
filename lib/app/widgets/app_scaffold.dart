import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget? body;
  final Widget? floatingActionButton;

  const AppScaffold({Key? key, required this.title, this.body, this.floatingActionButton}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: SafeArea(
        child: body ?? const SizedBox.shrink(),
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
