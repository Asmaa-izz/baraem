import 'package:flutter/widgets.dart';

/// Web has no file system; user-file images aren't supported there.
ImageProvider? makeFileImage(String path) => null;
