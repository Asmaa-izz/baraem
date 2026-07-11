import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../theme/baraem_tokens.dart';
import '../theme/context_ext.dart';

/// A child's profile as a tappable circle with an accent ring and name below.
/// Falls back to the first letter of the name when there is no image.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.name,
    required this.accent,
    this.image,
    this.emoji,
    this.onTap,
    this.size = BaraemSize.avatar,
    this.showName = true,
  });

  final String name;
  final Color accent;
  final ImageProvider? image;

  /// Optional emoji avatar (used by system-provided avatars).
  final String? emoji;
  final VoidCallback? onTap;
  final double size;
  final bool showName;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final initial = name.characters.isEmpty ? '؟' : name.characters.first;

    final circle = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colors.card,
        shape: BoxShape.circle,
        border: Border.all(color: accent, width: 3),
        boxShadow: context.shadows.soft,
        image: image == null
            ? null
            : DecorationImage(image: image!, fit: BoxFit.cover),
      ),
      alignment: Alignment.center,
      child: image != null
          ? null
          : Text(
              emoji ?? initial,
              style: TextStyle(
                fontFamily: kDisplayFont,
                fontWeight: FontWeight.w700,
                fontSize: size * (emoji != null ? 0.5 : 0.42),
                color: colors.ink,
              ),
            ),
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(BaraemRadii.pill),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          circle,
          if (showName) ...[
            const SizedBox(height: BaraemSpace.sm),
            Text(
              name,
              style: context.texts.bodyLarge,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
