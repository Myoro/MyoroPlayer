import 'dart:math';

import 'package:flutter/material.dart';

class SongList extends StatefulWidget {
  const SongList({super.key});

  @override
  State<SongList> createState() => _SongListState();
}

class _SongListState extends State<SongList> {
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Expanded(
        child: Scrollbar(
          controller: _controller,
          thumbVisibility: true,
          child: SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              controller: _controller,
              child: Column(
                children: List.generate(50, (index) => const _Song()),
              ),
            ),
          ),
        ),
      );
}

class _Song extends StatefulWidget {
  const _Song();

  @override
  State<_Song> createState() => _SongState();
}

class _SongState extends State<_Song> {
  final ValueNotifier<bool> _hovered = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _hovered.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return ValueListenableBuilder(
      valueListenable: _hovered,
      builder: (context, hovered, child) {
        final Color textColor =
            !hovered ? theme.colorScheme.onPrimary : theme.colorScheme.primary;
        final TextStyle bodyMedium =
            theme.textTheme.bodyMedium!.copyWith(color: textColor);
        final TextStyle bodySmall =
            theme.textTheme.bodySmall!.copyWith(color: textColor);

        return LayoutBuilder(
          builder: (context, constraints) => Padding(
            padding: const EdgeInsets.only(
              top: 5,
              bottom: 5,
              left: 5,
              right: 15,
            ),
            child: InkWell(
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {}, // TODO
              onHover: (value) => _hovered.value = value,
              child: Container(
                decoration: BoxDecoration(
                  color: !hovered
                      ? Colors.transparent
                      : theme.colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.network(
                          [
                            'https://upload.wikimedia.org/wikipedia/en/1/15/Mac_Miller_-_Circles.png',
                            'https://m.media-amazon.com/images/I/81hyfGUtN8L._UF1000,1000_QL80_.jpg',
                            'https://cdns-images.dzcdn.net/images/cover/5c5774a43a421d37f58ae170df87b9e8/500x500.jpg',
                            'https://f4.bcbits.com/img/a2347697865_65',
                          ][Random().nextInt(4)],
                          width: 60,
                          height: 60,
                        ),
                      ),
                      if (constraints.maxWidth > 120) ...[
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Tooltip(
                                message: 'iqojweioqjweoqiwejio',
                                waitDuration: const Duration(milliseconds: 500),
                                child: Text(
                                  'OOGABOOGA  whats uuuuup what supj w what',
                                  style: bodyMedium,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 3),
                              Tooltip(
                                message: 'qjwepjqweiojqweoiqjweioj',
                                waitDuration: const Duration(milliseconds: 500),
                                child: Text(
                                  'Ski Mask the Slump God and now some useless text',
                                  style: bodySmall,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (constraints.maxWidth > 180) const SizedBox(width: 10),
                      if (constraints.maxWidth > 500) ...[
                        Expanded(
                          child: Tooltip(
                            message: 'qjwepjqweiojqweoiqjweioj',
                            waitDuration: const Duration(milliseconds: 500),
                            child: Text(
                              'Album name ioqpjweiqjweiqjeoiqwje',
                              style: theme.textTheme.bodySmall!.copyWith(
                                color: !hovered
                                    ? theme.colorScheme.onPrimary
                                    : theme.colorScheme.primary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                      if (constraints.maxWidth > 170) ...[
                        Text(
                          '420:00',
                          style: theme.textTheme.bodyMedium!.copyWith(
                            color: !hovered
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 10), // For the scrollbar
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
