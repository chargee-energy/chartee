/// A custom error class for representing empty errors.
/// This error is thrown when an array is empty which is expected to have a value.
///
/// This class extends the built-in 'Error' class and provides a custom error message.
class EmptyError extends Error {
  /// The error message describing the empty error.
  final String message;

  /// Creates a new instance of [EmptyError] with the given [message].
  ///
  /// The [message] parameter is required and should not be null.
  EmptyError({required this.message});

  @override
  String toString() => 'EmptyError(message: "$message")';
}
