import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wallpaper_app/wallpaper_first_screen.dart';

// ignore: camel_case_types
class splash extends StatefulWidget {
  const splash({super.key});

  @override
  State<splash> createState() => _splashState();
}

// ignore: camel_case_types
class _splashState extends State<splash> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        (() async => await Navigator.pushReplacement<Future, dynamic>(context,
            MaterialPageRoute<Future>(builder: (context) => Wallpaper()))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.black,
          child: const Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Wall',
                  style: TextStyle(color: Colors.white, fontSize: 40),
                ),
                Text(
                  'Paper',
                  style: TextStyle(
                      color: Color.fromARGB(255, 3, 100, 247), fontSize: 50),
                ),
              ],
            ),
          )),
    );
  }
}
