# reorderable_carousel

[![pub package](https://img.shields.io/pub/v/reorderable_carousel.svg)](https://pub.dev/packages/reorderable_carousel)
[![flutter_tests](https://github.com/TNorbury/reorderable_carousel/workflows/flutter%20tests/badge.svg)](https://github.com/TNorbury/reorderable_carousel/actions?query=workflow%3A%22flutter+tests%22)
[![codecov](https://codecov.io/gh/TNorbury/reorderable_carousel/branch/main/graph/badge.svg)](https://codecov.io/gh/TNorbury/reorderable_carousel)
[![style: flutter lints](https://img.shields.io/badge/style-flutter__lints-blue)](https://pub.dev/packages/effective_dart)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A carousel which allows you to reorder the contents within the carousel, as well as add or remove items from it.

![](https://raw.githubusercontent.com/TNorbury/reorderable_carousel/main/readme_assets/reorderable_carousel.gif)

## Getting Started

### Installing

In your Flutter project, add the package to your dependencies

```yml
dependencies:
    reorderable_carousel: ^0.4.0+1
```

### Usage example

Now you can put the carousel anywhere you want.
One thing to note: You need to have at least one item at all times

```dart
import 'package:reorderable_carousel/reorderable_carousel.dart';

//...

List<Color> colors = [Colors.blue];

//...

ReorderableCarousel(
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
    // items have be reordered, update our list
    setState(() {
      Color swap = colors.removeAt(oldIndex);
      colors.insert(newIndex, swap);
    });
  },
  onItemSelected: (int selectedIndex) {
    // a new item has been selected
    setState(() {
      selectedColor = colors[selectedIndex];
    });
  },
),
```
