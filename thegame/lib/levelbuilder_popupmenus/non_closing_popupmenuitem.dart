import 'package:flutter/material.dart';

///Custom version of [PopupMenuItem] where the menu does not
///pop upon selecting an item
class NonClosingPopupMenuItem extends PopupMenuItem {
  const NonClosingPopupMenuItem({
    required Widget child,
    Key? key,
  }) : super(key: key, child: child);

  @override
  _PopupItemState createState() => _PopupItemState();
}

class _PopupItemState extends PopupMenuItemState {
  @override
  void handleTap() {}
}
