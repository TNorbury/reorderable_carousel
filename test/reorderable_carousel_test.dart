import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reorderable_carousel/reorderable_carousel.dart';

void main() {
  testWidgets(
    "Tap on item",
    (WidgetTester tester) async {
      int? selectedIndex;
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
      await tester.pumpAndSettle(Duration(seconds: 20));
      expect(selectedIndex, 0);
    },
  );

  testWidgets(
    "Drag test",
    (WidgetTester tester) async {
      int? oldIndex;
      int? newIndex;
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
      int? newIndex;
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
      await tester.pumpAndSettle();

      await tester.tap(find.byType(IconButton).first);
      await tester.pumpAndSettle();

      expect(newIndex, 1);
    },
  );

  testWidgets(
    "Add item awaits",
    (WidgetTester tester) async {
      bool? addItemCalled;
      bool? itemSelectedCalled;
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: ReorderableCarousel(
              numItems: 1,
              addItemAt: (int index) async {
                await Future.delayed(Duration(seconds: 1));
                addItemCalled = true;
              },
              itemBuilder: (double itemWidth, int index, bool isSelected) {
                return Container(
                  key: Key("Item $index"),
                  height: 100,
                  width: itemWidth,
                );
              },
              onReorder: (int oldIdx, int newIdx) {},
              onItemSelected: (_) {
                expect(addItemCalled, true);
                itemSelectedCalled = true;
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(IconButton).first);
      await tester.pumpAndSettle(const Duration(seconds: 20));

      expect(itemSelectedCalled, true);
    },
  );

  testWidgets(
    "selected item isn't updated if add item returns null",
    (WidgetTester tester) async {
      bool? itemSelectedCalled = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: ReorderableCarousel(
              numItems: 1,
              addItemAt: (int index) async {
                await Future.delayed(Duration(seconds: 1));
                return false;
              },
              itemBuilder: (double itemWidth, int index, bool isSelected) {
                return Container(
                  key: Key("Item $index"),
                  height: 100,
                  width: itemWidth,
                );
              },
              onReorder: (int oldIdx, int newIdx) {},
              onItemSelected: (_) {
                itemSelectedCalled = true;
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(IconButton).first);
      await tester.pumpAndSettle(const Duration(seconds: 20));

      expect(itemSelectedCalled, false);
    },
  );

  testWidgets(
    "Add icon isn't visible if max number of items is reach",
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: ReorderableCarousel(
              maxNumberItems: 5,
              numItems: 5,
              addItemAt: (int index) {},
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
      await tester.pumpAndSettle();

      expect(find.byType(IconButton), findsNothing);
    },
  );

  testWidgets(
    "Different builder used when dragging",
    (WidgetTester tester) async {
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
              onReorder: (int oldIdx, int newIdx) {},
              draggedItemBuilder: (itemWidth, index) {
                return Container(
                  width: itemWidth,
                  height: 50,
                  child: Text("Dragging $index"),
                );
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      Offset dragStart = tester.getCenter(find.byKey(Key("Item 0")));

      final gesture = await tester.startGesture(
        dragStart,
        pointer: 7,
      );
      await tester.pump(const Duration(seconds: 20));

      // find the dragged widget
      expect(find.text("Dragging 0"), findsOneWidget);
      await gesture.up();
      await tester.pump();

      // widget should be gone after pointer up
      expect(find.text("Dragging 0"), findsNothing);
    },
  );
}
