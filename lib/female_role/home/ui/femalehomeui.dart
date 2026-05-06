import 'package:flutter/material.dart';
import 'package:muslim_community/appcolore.dart';

class FemaleHomeUI extends StatelessWidget {
  const FemaleHomeUI({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // Use global app background color
      backgroundColor: AppColors.backgroundColor,
      body: Center(child: Text('Female Home')),
    );
  }
}
