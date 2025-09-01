//Extension on string to capitalize first letter
extension StringX on String {
  String capitalizeFirst() =>
      isEmpty ? '' : '${this[0].toUpperCase()}${substring(1)}';
}
