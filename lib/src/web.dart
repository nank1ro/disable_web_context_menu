import 'dart:js_interop';
import 'package:web/web.dart' as html;
import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';

class DisableWebContextMenu extends StatefulWidget {
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
  State<DisableWebContextMenu> createState() => _DisableWebContextMenuState();
}

class _DisableWebContextMenuState extends State<DisableWebContextMenu> {
  html.MutationObserver? observer;
  final _identifier = UniqueKey();
  String get identifier => widget.identifier ?? _identifier.toString();

  @override
  void initState() {
    super.initState();
    SemanticsBinding.instance.ensureSemantics();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final element = findElement();
      if (element != null) {
        element.setAttribute('oncontextmenu', 'return false;');
      }
    });
    addObserver();
  }

  html.Element? findElement() => html.document
      .querySelector('flt-semantics-host')
      ?.querySelector('[flt-semantics-identifier="$identifier"]');
  void addObserver() {
    observer = html.MutationObserver((JSArray jsMutations, void _) {
      final mutations = jsMutations.dartify() as List<dynamic>;
      for (final mutation in mutations) {
        final m = mutation as html.MutationRecord;
        if (m.type == 'attributes' &&
            m.attributeName == 'flt-semantics-identifier') {
          final node = m.target as html.HTMLElement;
          final id =
              node.attributes.getNamedItem('flt-semantics-identifier')?.value;

          if (id == identifier) {
            node.setAttribute('oncontextmenu', 'return false;');
            removeObserver();
            break;
          }
        }
      }
    }.toJS);

    observer!.observe(
      html.document,
      html.MutationObserverInit(
        childList: true,
        subtree: true,
        attributes: true,
        attributeFilter:
            (['flt-semantics-identifier'].jsify() as JSArray<JSString>),
      ),
    );
  }

  void removeObserver() {
    observer?.disconnect();
  }

  @override
  void dispose() {
    removeObserver();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      identifier: identifier,
      child: widget.child,
    );
  }
}
