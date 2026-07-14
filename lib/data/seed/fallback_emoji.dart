/// Per-item emoji shown when a content image is missing. Distinct per item so
/// quiz tiles stay distinguishable without any photo (e.g. six animals with no
/// images would otherwise be indistinguishable).
const Map<String, String> kFallbackEmoji = {
  // أدوات المنزل
  'spoon': '🥄',
  'cup': '☕',
  'plate': '🍽️',
  'fork': '🍴',
  'pot': '🍲',
  'bottle': '🍼',
  // الحيوانات
  'cat': '🐱',
  'dog': '🐶',
  'horse': '🐴',
  'rabbit': '🐰',
  'mouse': '🐭',
  'sheep': '🐑',
  // الطيور
  'bird': '🐦',
  'duck': '🦆',
  'chicken': '🐔',
  'falcon': '🦅',
  'owl': '🦉',
  // أدوات المنزل (أثاث ومقتنيات)
  'mattress': '🛏️',
  'window': '🪟',
  'chair': '🪑',
  'door': '🚪',
  'frame': '🖼️',
};

/// Category-level emoji fallback (also used as the category icon default).
const Map<String, String> kCategoryEmoji = {
  'household': '🍽️',
  'animals': '🐾',
  'birds': '🐦',
  'home': '🛋️',
  'fruits': '🍎',
  'colors': '🎨',
};

/// Best emoji for an item: item-specific, else category, else a neutral glyph.
String emojiForItem(String itemId, {String? categoryId}) {
  return kFallbackEmoji[itemId] ??
      (categoryId == null ? null : kCategoryEmoji[categoryId]) ??
      '🧩';
}
