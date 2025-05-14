import 'package:flutter/material.dart';
import 'package:kib_flutter_utils/src/error_utils/exceptions.dart'
    show ExceptionX;
import 'package:kib_utils/kib_utils.dart';

/// Displays a snackbar message with the given [message] in the provided [context].
///
/// This function wraps the Flutter snackbar functionality with error handling,
/// returning a [Result] that indicates success or contains an exception if the
/// operation fails.
///
/// Example usage:
/// ```dart
/// void showSuccessMessage(BuildContext context) {
///   final result = showSnackbarMessage(
///     context,
///     'Operation completed successfully',
///     backgroundColor: Colors.green,
///     durationSeconds: 5,
///     showCloseIcon: true,
///   );
///
///   result.isFailure((exception) {
///     debugPrint('Failed to show snackbar: ${exception.toString()}');
///   });
/// }
/// ```
///
/// Parameters:
/// * [context] - The BuildContext used to find the ScaffoldMessenger
/// * [message] - The text to display in the snackbar
/// * [durationSeconds] - How long to display the snackbar (defaults to 3 seconds)
/// * [backgroundColor] - The background color of the snackbar
/// * [action] - An optional action button to display on the snackbar
/// * [behavior] - Controls how the snackbar animates and its position
/// * [onVisible] - Callback that will be triggered when the snackbar is fully visible
/// * [dismissDirection] - The direction in which the snackbar can be dismissed
/// * [showCloseIcon] - Whether to show a close icon on the snackbar
/// * [closeIconColor] - The color of the close icon if shown
///
/// Returns a [Result] which contains:
/// * Success: void (no value)
/// * Error: An [Exception] if showing the snackbar fails
Result<void, Exception> showSnackbarMessage(
  BuildContext context,
  String message, {
  int? durationSeconds,
  Color? backgroundColor,
  SnackBarAction? action,
  SnackBarBehavior? behavior,
  VoidCallback? onVisible,
  DismissDirection? dismissDirection,
  bool? showCloseIcon,
  Color? closeIconColor,
}) {
  return tryResult(
    () {
      final messenger = ScaffoldMessenger.of(context);
      messenger.clearSnackBars();
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(color: Colors.black),
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
          ),
          duration:
              durationSeconds != null
                  ? Duration(seconds: durationSeconds)
                  : Duration(seconds: 3),
          backgroundColor: backgroundColor,
          action: action,
          behavior: behavior,
          onVisible: onVisible,
          dismissDirection: dismissDirection,
          showCloseIcon: showCloseIcon,
          closeIconColor: closeIconColor,
        ),
      );
    },
    (err) => ExceptionX(
      error: err,
      stackTrace: StackTrace.current,
      message: 'Error, ${err.runtimeType}, encountered while showing snackbar',
      errorType: err.runtimeType,
    ),
  );
}

/// Extension on [BuildContext] providing a convenient way to show snackbar messages.
///
/// This extension simplifies the process of showing snackbar messages by allowing
/// direct access through the BuildContext, which is typically available in widget
/// build methods and most UI interaction handlers.
///
/// Example usage:
/// ```dart
/// ElevatedButton(
///   onPressed: () {
///     // Direct usage from BuildContext
///     context.showMessage(
///       'Settings saved!',
///       backgroundColor: Colors.green[300],
///       showCloseIcon: true,
///     );
///   },
///   child: Text('Save Settings'),
/// )
/// ```
///
/// Example with error handling:
/// ```dart
/// void onSubmit() {
///   final result = context.showMessage('Processing...');
///   result.isFailure((exception) {
///     print('Failed to show notification: $exception');
///   });
///
///   // Continue with submission logic...
/// }
/// ```
extension SnackbarExtension on BuildContext {
  /// Shows a snackbar message in the current context.
  ///
  /// This method is a convenient wrapper around [showSnackbarMessage] that automatically
  /// passes the current context. It provides the same functionality and parameters as
  /// the standalone function.
  ///
  /// Parameters:
  /// * [message] - The text to display in the snackbar
  /// * [durationSeconds] - How long to display the snackbar (defaults to 3 seconds)
  /// * [backgroundColor] - The background color of the snackbar
  /// * [action] - An optional action button to display on the snackbar
  /// * [behavior] - Controls how the snackbar animates and its position
  /// * [onVisible] - Callback that will be triggered when the snackbar is fully visible
  /// * [dismissDirection] - The direction in which the snackbar can be dismissed
  /// * [showCloseIcon] - Whether to show a close icon on the snackbar
  /// * [closeIconColor] - The color of the close icon if shown
  ///
  /// Returns a [Result] which contains:
  /// * Success: void (no value)
  /// * Error: An [Exception] if showing the snackbar fails
  Result<void, Exception> showMessage(
    String message, {
    int? durationSeconds,
    Color? backgroundColor,
    SnackBarAction? action,
    SnackBarBehavior? behavior,
    VoidCallback? onVisible,
    DismissDirection? dismissDirection,
    bool? showCloseIcon,
    Color? closeIconColor,
  }) => showSnackbarMessage(
    this,
    message,
    durationSeconds: durationSeconds,
    backgroundColor: backgroundColor,
    action: action,
    behavior: behavior,
    onVisible: onVisible,
    dismissDirection: dismissDirection,
    showCloseIcon: showCloseIcon,
    closeIconColor: closeIconColor,
  );
}
