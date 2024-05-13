class EmptyError extends Error {
  final String message;

  EmptyError({required this.message});

  @override
  String toString() => 'EmptyError(message: "$message")';
}
