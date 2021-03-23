import 'package:flutter_test/flutter_test.dart';

import 'package:reorderable_carousel/reorderable_carousel.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets(
    "Tap on item",
    (WidgetTester tester) async {
      int selectedIndex;
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: ReorderableCarousel(
              numItems: 1,
              addItemAt: (int index) {},
              itemBuilder: (double itemWidth, int index, bool isSelected) {
                return Container(
                  key: Key("Item $index"),
                  height: 100,
                  width: itemWidth,
                );
              },
              onItemSelected: (int idx) {
                selectedIndex = idx;
              },
              onReorder: (int oldIndex, int newIndex) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key("Item 0")));
      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(selectedIndex, 0);
    },
  );

  testWidgets(
    "Drag test",
    (WidgetTester tester) async {
      int oldIndex;
      int newIndex;
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: ReorderableCarousel(
              numItems: 2,
              addItemAt: (int index) {},
              itemBuilder: (double itemWidth, int index, bool isSelected) {
                return Container(
                  key: Key("Item $index"),
                  height: 100,
                  width: itemWidth,
                );
              },
              onReorder: (int oldIdx, int newIdx) {
                oldIndex = oldIdx;
                newIndex = newIdx;
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      Offset dragStart = tester.getCenter(find.byKey(Key("Item 0")));
      Offset dragEnd = Offset(
          tester.getBottomRight(find.byKey(Key("Item 1"))).dx + 50,
          tester.getBottomRight(find.byKey(Key("Item 1"))).dy);

      final gesture = await tester.startGesture(
        dragStart,
        pointer: 7,
      );
      await tester.pump(const Duration(seconds: 20));
      await gesture.moveTo(dragEnd);
      await tester.pump();
      await gesture.up();
      await tester.pump();

      expect(oldIndex, 0);
      expect(newIndex, 1);
    },
  );

  testWidgets(
    "Add item callback",
    (WidgetTester tester) async {
      int newIndex;
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: ReorderableCarousel(
              numItems: 1,
              addItemAt: (int index) {
                newIndex = index;
              },
              itemBuilder: (double itemWidth, int index, bool isSelected) {
                return Container(
                  key: Key("Item $index"),
                  height: 100,
                  width: itemWidth,
                );
              },
              onReorder: (int oldIdx, int newIdx) {},
            ),
          ),
        ),
      );

      await tester.tap(find.byType(IconButton).first);

      expect(newIndex, 1);
    },
  );
}
