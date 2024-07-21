import 'package:flutter/material.dart';

/// Vertical scrollbar that always shows the scrollbar
final class VerticalScrollList extends StatefulWidget {
  final ScrollController? scrollController;
  final List<Widget> children;

  const VerticalScrollList({
    super.key,
    this.scrollController,
    this.children = const [],
  });

  @override
  State<VerticalScrollList> createState() => _VerticalScrollListState();
}

final class _VerticalScrollListState extends State<VerticalScrollList> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = widget.children;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 13,
        ),
        child: Column(
          children: children,
        ),
      ),
    );
  }
}
