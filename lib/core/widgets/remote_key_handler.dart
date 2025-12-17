import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Simple global handler that maps some remote keys to app actions.
class RemoteKeyHandler extends StatelessWidget {
  final Widget child;
  const RemoteKeyHandler({super.key, required this.child});

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
        child: Focus(autofocus: true, child: child),
      ),
    );
  }
}

class _BackIntent extends Intent {
  const _BackIntent();
}
