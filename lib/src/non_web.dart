import 'package:flutter/widgets.dart';

class DisableWebContextMenu extends StatelessWidget {
  const DisableWebContextMenu({
    super.key,
    required this.child,
    this.identifier,
  });

  /// The identifier to use for the semantics node to find this element, defaults to `UniqueKey().toString()`.
  final String? identifier;

  /// The child widget for which the context menu should be disabled.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // no-op on non-web platforms
    return child;
  }
}
