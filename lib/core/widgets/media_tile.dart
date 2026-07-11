import 'package:flutter/material.dart';

import '../theme/baraem_tokens.dart';
import '../theme/context_ext.dart';
import 'emoji_fallback.dart';

/// A square media surface: the content image (asset or file), with a graceful
/// [EmojiFallback] whenever the image is absent or fails to load. Never crashes
/// on a missing asset.
class MediaTile extends StatelessWidget {
  const MediaTile({
    super.key,
    required this.emoji,
    this.image,
    this.seed = '',
    this.radius = BaraemRadii.lg,
    this.overlay,
    this.border = true,
    this.shadow = true,
  });

  /// Emoji used when [image] is null or fails to decode.
  final String emoji;

  /// The image to show; when null the tile renders [EmojiFallback] directly.
  final ImageProvider? image;
  final String seed;
  final double radius;

  /// Optional overlay (e.g. a speaker button) stacked on the tile.
  final Widget? overlay;
  final bool border;
  final bool shadow;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final br = BorderRadius.circular(radius);
    final fallback = EmojiFallback(emoji: emoji, seed: seed);

    Widget inner = image == null
        ? fallback
        : Image(
            image: image!,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stack) => fallback,
            frameBuilder: (context, child, frame, wasSync) {
              if (wasSync || frame != null) return child;
              return fallback;
            },
          );

    return AspectRatio(
      aspectRatio: 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: br,
          border: border ? Border.all(color: colors.line) : null,
          boxShadow: shadow ? context.shadows.soft : null,
        ),
        child: ClipRRect(
          borderRadius: br,
          child: Stack(
            fit: StackFit.expand,
            children: [
              inner,
              if (overlay != null)
                Positioned.directional(
                  textDirection: Directionality.of(context),
                  top: 12,
                  start: 12,
                  child: overlay!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
