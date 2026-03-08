import 'package:flutter/material.dart';

class QuranScreen extends StatelessWidget {
  const QuranScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quran'),
      ),
      body: const Center(
        child: Text('Quran Screen'),
      ),
    );
  }
}
