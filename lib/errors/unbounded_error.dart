/// A custom error class representing an unbounded error.
/// This error is thrown when an unbounded condition is encountered.
///
/// This class extends the built-in 'Error' class and provides a custom error message.
class UnboundedError extends Error {
  /// The error message describing the unbounded condition.
  final String message;

  /// Creates a new instance of [UnboundedError] with the given [message].
  ///
  /// The [message] parameter is required and should not be null.
  UnboundedError({required this.message});

  @override
  String toString() => 'UnboundedError(message: "$message")';
}
