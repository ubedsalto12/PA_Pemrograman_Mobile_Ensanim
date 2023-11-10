import 'package:flutter/material.dart';

class CrudScreens extends StatelessWidget {
  const CrudScreens({super.key});
  static const String routeName = '\CrudScreens';
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(10),
        child: const Text(
          'CRUD',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 36,
          ),
        ),
      ),
    );
  }
}
