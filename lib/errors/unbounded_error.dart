class UnboundedError extends Error {
  final String message;

  UnboundedError({required this.message});

  @override
  String toString() => 'UnboundedError(message: "$message")';
}
