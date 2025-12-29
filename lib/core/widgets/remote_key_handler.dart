import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// TV-SAFE Remote/D-Pad handler for Android TV boxes.
/// Fixes:
/// - Uses persistent FocusNode (not recreated on every build)
/// - Enables autofocus to receive D-Pad input immediately
/// - Does NOT block rendering if no remote input occurs
class RemoteKeyHandler extends StatefulWidget {
  final Widget child;
  const RemoteKeyHandler({super.key, required this.child});

  @override
  State<RemoteKeyHandler> createState() => _RemoteKeyHandlerState();
}

class _RemoteKeyHandlerState extends State<RemoteKeyHandler> {
  // TV-SAFE (FIX #4): Persistent FocusNode - created once, reused across builds
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    // Create persistent FocusNode once
    _focusNode = FocusNode();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
        LogicalKeySet(LogicalKeyboardKey.enter): const ActivateIntent(),
        LogicalKeySet(LogicalKeyboardKey.space): const ActivateIntent(),
        LogicalKeySet(LogicalKeyboardKey.escape): const _BackIntent(),
        LogicalKeySet(LogicalKeyboardKey.goBack): const _BackIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          _BackIntent: CallbackAction<_BackIntent>(
            onInvoke: (intent) {
              if (Navigator.canPop(context)) Navigator.pop(context);
              return null;
            },
          ),
        },
        // TV-SAFE: FocusScope ensures proper focus tree for D-Pad navigation
        child: FocusScope(
          autofocus: true,
          child: Focus(
            autofocus: true,
            focusNode: _focusNode,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class _BackIntent extends Intent {
  const _BackIntent();
}
