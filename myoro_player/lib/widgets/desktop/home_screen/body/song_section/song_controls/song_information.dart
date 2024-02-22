import 'package:flutter/material.dart';

/// Holds:
/// - Album cover
/// - Song name
/// - Song artist
class SongInformation extends StatelessWidget {
  const SongInformation({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Image.network(
          'https://audioxide.com/api/images/album-artwork/zuu-denzel-curry-medium-square.jpg',
          width: 60,
          height: 60,
        ),
        const SizedBox(width: 5),
        SizedBox(
          width: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Song name qweiqwje',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium,
              ),
              Text(
                'Song artistqwejqweoijqeoijqwioejqweiqwje',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
