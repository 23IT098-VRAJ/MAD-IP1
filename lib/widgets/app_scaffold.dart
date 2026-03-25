import 'package:flutter/material.dart';

import '../core/constants/constants.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.drawer,
    this.floatingActionButton,
    this.resizeToAvoidBottomInset = true,
  });

  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? drawer;
  final Widget? floatingActionButton;
  final bool resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      drawer: drawer,
      appBar: AppBar(title: Text(title), actions: actions),
      body: SafeArea(
        child: Padding(padding: const EdgeInsets.all(AppSizes.md), child: body),
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
