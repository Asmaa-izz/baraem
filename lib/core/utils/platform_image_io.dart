import 'dart:io';

import 'package:flutter/widgets.dart';

/// Native platforms load parent-uploaded images from the file system.
ImageProvider? makeFileImage(String path) => FileImage(File(path));
