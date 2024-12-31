# DisableWebContextMenu

A Flutter widget that disables the native context menu on web for the child widget.

Read the blog post about it [here](https://mariuti.com/posts/flutter-web-disable-browser-context-menu-for-specific-widget/)

**You can test it live [here](https://disable-web-context-menu.pages.dev)**

## Problem

By default on Flutter Web when you right click the native web context menu is shown.
What if you want to disable it to show a custom Flutter widget instead?

<img src="https://raw.githubusercontent.com/nank1ro/disable_web_context_menu/main/assets/problem.png" height="400">

As you can see when you try to display the custom flutter widget, the native web context menu is shown together. Play close attention to the red circle, it's the flutter context menu.

Flutter provides a solution you can [check here](https://api.flutter.dev/flutter/widgets/ContextMenuController-class.html) which uses:
```dart
// On web, disable the browser's context menu since this example uses a custom
// Flutter-rendered context menu.
if (kIsWeb) {
  BrowserContextMenu.disableContextMenu();
}
```

The downside of this solution is that the native context menu is disabled for all the app and all the widgets.
What if you want to disable it only for specific widgets?

## Solution

This package introduces a widget called `DisableWebContextMenu` that disables the native web context menu for a specific widget only.

You can safely import and use it in all the platforms, because on non-web platforms this package does nothing.

<img src="https://raw.githubusercontent.com/nank1ro/disable_web_context_menu/main/assets/solution.png" height="400">

> TIP: If you right click outside the container, the native web context menu will be shown.

## Example Usage

```dart
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
```
