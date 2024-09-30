/// Extension for [Iterable] class.
extension IterableExtension<T> on Iterable<T> {
  /// Returns a copy of `this` sorted by [comparator].
  List<T> toSortedList(Comparator<T> comparator) {
    return [...this]..sort(comparator);
  }
}
