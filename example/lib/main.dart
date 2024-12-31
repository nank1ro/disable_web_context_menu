import 'package:disable_web_context_menu/disable_web_context_menu.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TapRegion(
          onTapOutside: (_) {
            // When tapping outside the container, hide the context menu.
            ContextMenuController.removeAny();
          },
          child: DisableWebContextMenu(
            child: _ContextMenuRegion(
              contextMenuBuilder: (BuildContext context, Offset offset) {
                // The custom context menu will look like the default context menu
                // on the current platform with a single 'Print' button.
                return AdaptiveTextSelectionToolbar.buttonItems(
                  anchors: TextSelectionToolbarAnchors(
                    primaryAnchor: offset,
                  ),
                  buttonItems: <ContextMenuButtonItem>[
                    ContextMenuButtonItem(
                      onPressed: () {
                        ContextMenuController.removeAny();
                      },
                      label: 'Print',
                    ),
                  ],
                );
              },
              child: Container(
                width: 200,
                height: 200,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                child: Text(
                  'Right click to show the custom context menu',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// This example was taken from the [official documentation](https://api.flutter.dev/flutter/widgets/ContextMenuController-class.html)
// A builder that includes an Offset to draw the context menu at.
typedef ContextMenuBuilder = Widget Function(
    BuildContext context, Offset offset);

/// Shows and hides the context menu based on user gestures.
///
/// By default, shows the menu on right clicks and long presses.
class _ContextMenuRegion extends StatefulWidget {
  /// Creates an instance of [_ContextMenuRegion].
  const _ContextMenuRegion({
    required this.child,
    required this.contextMenuBuilder,
  });

  /// Builds the context menu.
  final ContextMenuBuilder contextMenuBuilder;

  /// The child widget that will be listened to for gestures.
  final Widget child;

  @override
  State<_ContextMenuRegion> createState() => _ContextMenuRegionState();
}

class _ContextMenuRegionState extends State<_ContextMenuRegion> {
  final controller = ContextMenuController();

  void _onSecondaryTapDown(TapDownDetails details) {
    _show(details.globalPosition);
  }

  void _onTap() {
    if (!controller.isShown) {
      return;
    }
    _hide();
  }

  void _show(Offset position) {
    controller.show(
      context: context,
      contextMenuBuilder: (BuildContext context) {
        return widget.contextMenuBuilder(context, position);
      },
    );
  }

  void _hide() {
    controller.remove();
  }

  @override
  void dispose() {
    _hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTapDown: _onSecondaryTapDown,
      onTap: _onTap,
      child: widget.child,
    );
  }
}
