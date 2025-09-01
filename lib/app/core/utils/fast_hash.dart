//Hash task string id to return a valid 32-bit signed integer to schedule notification

int fastHash(String string) {
  var hash = 0xcbf29ce484222325;

  for (var i = 0; i < string.length; i++) {
    final codeUnit = string.codeUnitAt(i);
    hash ^= codeUnit >> 8;
    hash *= 0x100000001b3;
    hash ^= codeUnit & 0xFF;
    hash *= 0x100000001b3;
  }

  // Force into 32-bit signed int range
  return (hash & 0x7fffffff).toInt(); // always positive
}
