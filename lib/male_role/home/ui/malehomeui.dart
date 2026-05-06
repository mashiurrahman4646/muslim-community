import 'package:flutter/material.dart';
import 'package:muslim_community/appcolore.dart';

class MaleHomeUI extends StatelessWidget {
  const MaleHomeUI({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // Use global app background color
      backgroundColor: AppColors.backgroundColor,
      body: Center(child: Text('Male Home')),
    );
  }
}
