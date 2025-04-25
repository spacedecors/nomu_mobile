import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Content(),
    );
  }

  Widget Content() {
    return CarouselSlider(
      items: [1, 2, 3, 4, 5].map((i) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              "Text $i",
              style: const TextStyle(fontSize: 40),
            ),
          ),
        );
      }).toList(),
      options: CarouselOptions(
        height: 300,
      ),
    );
  }
}
