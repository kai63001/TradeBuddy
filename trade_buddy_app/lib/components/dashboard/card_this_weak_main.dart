import 'package:flutter/material.dart';

class CardThisWeakMain extends StatefulWidget {
  const CardThisWeakMain({super.key});

  @override
  State<CardThisWeakMain> createState() => _CardThisWeakMainState();
}

class _CardThisWeakMainState extends State<CardThisWeakMain> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text('hello')
      ],
    );
  }
}