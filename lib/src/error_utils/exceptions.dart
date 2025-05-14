import 'package:equatable/equatable.dart';

/// An extended exception class that provides additional context about errors.
///
/// Implements [Equatable] for value equality comparison and [Exception] interface.
/// Captures error details including message, type, original error, and stack trace.
///
/// Example:
/// ```dart
/// try {
///   // Some operation
/// } catch (e, stackTrace) {
///   throw ExceptionX(
///     message: 'Failed to load user data',
///     errorType: e.runtimeType,
///     error: e,
///     stackTrace: stackTrace,
///   );
/// }
/// ```
class ExceptionX extends Equatable implements Exception {
  /// Human-readable description of the error
  final String message;

  /// Runtime type of the original error
  final Type errorType;

  /// Original error object
  final Object error;

  /// Stack trace where the error occurred
  final StackTrace stackTrace;

  /// Creates an [ExceptionX] with context about the error.
  ///
  /// Requires a non-empty [message], the [errorType], original [error] object,
  /// and [stackTrace] where the error occurred.
  ExceptionX({
    required this.message,
    required this.errorType,
    required this.error,
    required this.stackTrace,
  }) : assert(message.isNotEmpty, 'Exception message must not be empty');

  @override
  List<Object?> get props => [message, errorType, error];

  @override
  String toString() => message;
}

/// Exception thrown when authentication fails or authorization is denied.
///
/// Use this exception for scenarios such as invalid credentials, expired tokens,
/// or insufficient permissions.
class UnauthorizedException implements Exception {
  /// Description of the authentication/authorization failure
  final String message;

  UnauthorizedException(this.message);
}

/// Exception thrown when a requested resource cannot be found.
///
/// Use this for cases where an entity lookup fails, an API endpoint returns 404,
/// or a required file is missing.
class NotFoundException implements Exception {
  /// Description of what resource was not found
  final String message;

  NotFoundException(this.message);
}

/// Exception thrown when network operations fail.
///
/// Use this for API request failures, timeouts, or connection issues.
class NetworkException implements Exception {
  /// URL of the failed request
  final String url;

  /// Description of the network failure
  final String message;

  /// Optional HTTP status code if applicable
  final int? statusCode;

  NetworkException(this.message, this.url, {this.statusCode});
}

/// Exception thrown when data validation fails.
///
/// Use this for form validation errors, invalid input data, or schema violations.
class ValidationException implements Exception {
  /// Description of the validation failure
  final String message;

  /// Optional map of field-specific validation errors
  final Map<String, String>? fieldErrors;

  ValidationException(this.message, {this.fieldErrors});
}

/// Exception thrown when a required configuration or setup is missing.
///
/// Use this for initialization errors, missing environment variables, or required setup steps.
class ConfigurationException implements Exception {
  /// Description of the missing or invalid configuration
  final String message;

  ConfigurationException(this.message);
}

/// Exception thrown when an action cannot be performed in the current state.
///
/// Use this for state machine violations, lifecycle issues, or when operations
/// are requested at inappropriate times.
class InvalidActionException implements Exception {
  /// Description of why the action is invalid
  final String message;

  /// Optional current state information
  final String? currentState;

  /// Optional information about what actions would be valid
  final List<String>? validActions;

  /// Creates an [InvalidActionException] with details about why the action cannot be performed.
  ///
  /// Example:
  /// ```dart
  /// if (audioPlayer.state != AudioPlayerState.playing) {
  ///   throw InvalidActionException(
  ///     'Cannot pause when not playing',
  ///     currentState: audioPlayer.state.toString(),
  ///     validActions: ['play', 'stop'],
  ///   );
  /// }
  /// ```
  InvalidActionException(this.message, {this.currentState, this.validActions});

  @override
  String toString() {
    final buffer = StringBuffer(message);
    if (currentState != null) {
      buffer.write(' (Current state: $currentState)');
    }
    if (validActions != null && validActions!.isNotEmpty) {
      buffer.write(' Valid actions: ${validActions!.join(', ')}');
    }
    return buffer.toString();
  }
}
