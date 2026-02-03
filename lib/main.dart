import 'package:flutter/material.dart';
import 'package:lab5/pageone.dart';
import 'package:lab5/pagetwo.dart';

void main() {
  runApp(Myapp());

}

class Myapp extends StatelessWidget {
  const Myapp ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:Pageone(),
    );
  }
}