import 'package:flutter/material.dart';
import 'package:iptv/featuers/history/presentation/views/widgets/history_view_body.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HistoryViewBody(),
    );
  }
}