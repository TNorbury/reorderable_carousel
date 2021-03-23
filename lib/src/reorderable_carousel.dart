import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// A carousel that can be re-ordered by dragging the elements around.
class ReorderableCarousel extends StatefulWidget {
  final int numItems;
  final void Function(int index) addItemAt;
  final Widget Function(double boxSize, int index, bool isSelected) itemBuilder;
  final void Function(int oldIndex, int newIndex) onReorder;
  final void Function(int selectedIndex) onItemSelected;

  ReorderableCarousel({
    @required this.numItems,
    @required this.addItemAt,
    @required this.itemBuilder,
    @required this.onReorder,
    @required this.onItemSelected,
    Key key,
  }) : super(key: key);

  @override
  _ReorderableCarouselState createState() => _ReorderableCarouselState();
}

class _ReorderableCarouselState extends State<ReorderableCarousel> {
  bool _dragInProgress = false;

  double boxSize;
  final double iconSize = 24 + 16.0;

  ScrollController _controller;
  int selectedIdx;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    selectedIdx = 0;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        boxSize = constraints.maxWidth / 3;

        var children = [
          SizedBox(
            width: boxSize,
          ),
          for (int i = 0; i < widget.numItems; i++)
            GestureDetector(
              onTap: () {
                setState(() {
                  _updateSelectedIndex(i);
                });
                _scrollToBox(i - 1);
              },
              child: widget.itemBuilder(boxSize, i, i == selectedIdx),
            ),
          SizedBox(
            width: boxSize - iconSize,
          ),
        ];

        return ReorderableList(
          // We want all the pages to be cached. This also
          // alleviates a problem where scrolling would get broken if
          // a page changed a position by more than ~4.
          cacheExtent: (boxSize + iconSize) * 10,
          controller: _controller,
          scrollDirection: Axis.horizontal,
          onReorder: (oldIndex, newIndex) {
            // compensate for the leading space
            oldIndex--;
            newIndex--;
            if (newIndex > oldIndex) {
              newIndex--;
            }

            // clamp, in the event that the reorder involves the
            // leading spaces. Removing 1 to accommodate the fact that the item
            // will be removed as part of reordering.
            newIndex = newIndex.clamp(0, widget.numItems - 1);
            widget.onReorder(oldIndex, newIndex);

            // Color swap = colors.removeAt(oldIndex);
            // colors.insert(newIndex, swap);
            setState(() {
              _dragInProgress = false;

              _updateSelectedIndex(newIndex);

              _scrollToBox(newIndex - 1);
            });
          },
          itemCount: children.length,
          itemBuilder: (context, i) {
            return Row(
              key: ValueKey(i),
              children: [
                Listener(
                  behavior: HitTestBehavior.opaque,
                  onPointerDown: (event) {
                    final SliverReorderableListState list =
                        SliverReorderableList.maybeOf(context);

                    list?.startItemDragReorder(
                      index: i,
                      event: event,
                      recognizer:
                          DelayedMultiDragGestureRecognizer(debugOwner: this),
                    );
                    _PointerSmuggler(debugOwner: this)
                      ..onStart = ((d) {
                        // the wait time has passed and the drag has
                        // started
                        setState(() {
                          _updateSelectedIndex(i - 1);
                          _dragInProgress = true;
                        });
                        return;
                      })
                      ..addPointer(event);
                  },
                  onPointerUp: (e) {
                    setState(() {
                      _dragInProgress = false;
                    });
                  },
                  child: children[i],
                ),

                // no plus icons for the invisible boxes
                if (i != 0 && i != children.length - 1)
                  // once we have 10 items, don't allow anymore items to be built
                  if (widget.numItems < 10)
                    AnimatedOpacity(
                      opacity: _dragInProgress ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 250),
                      child: IconButton(
                        visualDensity: VisualDensity.compact,
                        icon: Icon(Icons.add),
                        onPressed: () {
                          widget.addItemAt(i);
                          setState(() {
                            _updateSelectedIndex(i);

                            _scrollToBox(i - 1);
                          });
                        },
                      ),
                    )
                  else
                    SizedBox(
                      width: iconSize,
                    ),
              ],
            );
          },
          proxyDecorator: (child, index, animation) {
            // move and scale the dragged item
            var align = AlignmentGeometryTween(
              begin: Alignment.centerLeft,
              end: Alignment.center,
            ).animate(animation);
            var size = Tween(
              begin: 1.0,
              end: 1.1,
            ).animate(animation);

            return AlignTransition(
              alignment: align,
              child: ScaleTransition(
                scale: size,
                child: Material(
                  elevation: 4,
                  child: widget.itemBuilder(
                    boxSize,
                    index - 1,
                    true,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _updateSelectedIndex(int index) {
    widget.onItemSelected(index);
    setState(() {
      selectedIdx = index;
    });
  }

  void _scrollToBox(int index) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // _controller.jumpTo(0);
      _controller.animateTo(
          (((index) * (boxSize + iconSize)) + boxSize + iconSize),
          duration: Duration(milliseconds: 350),
          curve: Curves.linear);
    });
  }
}

/// This allows one pointer event to be used for multiple gesture recognizers.
/// This allows us to create a custom callback that is informed with the
/// recognizer starts, but doesn't event up actually doing anything with the
/// event (seeing as it's handled by the other gesture recognizer)
class _PointerSmuggler extends DelayedMultiDragGestureRecognizer {
  _PointerSmuggler(
      {Duration delay = kLongPressTimeout,
      Object debugOwner,
      PointerDeviceKind kind})
      : super(debugOwner: debugOwner, delay: delay, kind: kind);

  @override
  void rejectGesture(int pointer) {
    acceptGesture(pointer);
  }
}
