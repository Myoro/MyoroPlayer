import 'package:flutter/material.dart';

/// Vertical [SingleChildScrollView] that will always show the scrollbar
final class VerticalScrollbar extends StatefulWidget {
  /// If the component will be using the [ScrollController]
  final ScrollController? scrollController;

  /// Padding around the items and the scrollbar
  final EdgeInsets padding;

  /// Items of the scrollbar
  final List<Widget> children;

  const VerticalScrollbar({
    super.key,
    this.scrollController,
    this.padding = const EdgeInsets.symmetric(horizontal: 12),
    this.children = const [],
  });

  @override
  State<VerticalScrollbar> createState() => _VerticalScrollbarState();
}

final class _VerticalScrollbarState extends State<VerticalScrollbar> {
  EdgeInsets get _padding => widget.padding;
  List<Widget> get _children => widget.children;

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
    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: _padding,
          child: Column(
            children: _children,
          ),
        ),
      ),
    );
  }
}
