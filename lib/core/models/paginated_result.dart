class PaginatedResult<T> {
  final List<T> items;
  final int count;

  const PaginatedResult({required this.items, required this.count});
}
