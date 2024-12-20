# DisableWebContextMenu

A Flutter widget that disables the native context menu on web for the child widget.

Read the blog post about it [here](https://mariuti.com/posts/flutter-web-disable-browser-context-menu-for-specific-widget/)

You can test it live [here](https://987d6bac.disable-web-context-menu.pages.dev/)

## Usage

```dart
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: DisableWebContextMenu(
          child: Container(
            width: 200,
            height: 200,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: Text(
              'This container has the native context menu disabled on right click',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
```
