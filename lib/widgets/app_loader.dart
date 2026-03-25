import 'package:flutter/material.dart';

import '../core/constants/constants.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(strokeWidth: AppSizes.xs / 2),
    );
  }
}
