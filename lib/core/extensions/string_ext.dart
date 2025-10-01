extension StringExtension on String {
  String get firstLetter {
    String trimmed = trim();
    if (trimmed.isEmpty) return '';
    return trimmed[0].toUpperCase();
  }
}
