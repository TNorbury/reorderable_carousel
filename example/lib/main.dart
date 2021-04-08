import 'dart:math';

import 'package:flutter/material.dart';
import 'package:reorderable_carousel/reorderable_carousel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State createState() {
    return MyHomePageState();
  }
}

class MyHomePageState extends State<MyHomePage> {
  late List<Color> colors;

  late Color selectedColor;
  late int selectedIdx;

  final double iconSize = 24 + 16.0;

  @override
  void initState() {
    super.initState();
    colors = [
      Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0)
    ];
    selectedIdx = 0;
    selectedColor = colors[selectedIdx];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Device Layout -- "),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: MediaQuery.of(context).size.width / 3,
            height: MediaQuery.of(context).size.height * .6,
            color: selectedColor,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .25,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ReorderableCarousel(
                maxNumberItems: 10,
                numItems: colors.length,
                addItemAt: (index) {
                  setState(() {
                    colors.insert(
                        index,
                        Color((Random().nextDouble() * 0xFFFFFF).toInt())
                            .withOpacity(1.0));
                  });
                },
                itemBuilder: (boxSize, index, isSelected) {
                  return AnimatedContainer(
                    key: ValueKey(colors[index]),
                    duration: const Duration(milliseconds: 250),
                    height: 150,
                    width: boxSize,
                    decoration: BoxDecoration(
                      border: isSelected
                          ? Border.all(color: Colors.amber, width: 10.0)
                          : null,
                      color: colors[index],
                    ),
                  );
                },
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    Color swap = colors.removeAt(oldIndex);
                    colors.insert(newIndex, swap);
                  });
                },
                onItemSelected: (int selectedIndex) {
                  setState(() {
                    selectedColor = colors[selectedIndex];
                  });
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
