import 'package:flutter/material.dart';

class OutBox extends StatefulWidget {
  const OutBox({super.key});

  @override
  State<OutBox> createState() => _OutBoxState();
}

class _OutBoxState extends State<OutBox> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(),
    );
  }
}