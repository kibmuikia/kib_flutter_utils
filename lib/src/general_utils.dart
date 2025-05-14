import 'package:flutter/material.dart'
    show BuildContext, FocusScope, WidgetsBinding;
import 'package:kib_debug_print/kib_debug_print.dart' show kprint;

/// Executes a callback after the current frame is rendered.
///
/// This function provides a convenient wrapper around [WidgetsBinding.instance.addPostFrameCallback]
/// with additional error handling. It's useful for operations that need to be performed
/// after the UI has been built and rendered, such as:
/// - Showing dialogs
/// - Initiating animations
/// - Adjusting scroll positions
/// - Performing measurements that depend on rendered widgets
///
/// The function automatically catches and logs exceptions that occur during the callback
/// execution, preventing unhandled exceptions from crashing the app.
///
/// Example usage:
/// ```dart
/// // Show a dialog after the frame is rendered
/// postFrame(() async {
///   await showDialog(
///     context: context,
///     builder: (context) => AlertDialog(
///       title: Text('Welcome'),
///       content: Text('Thanks for using our app!'),
///     ),
///   );
/// });
///
/// // Scroll to a position after layout is complete
/// postFrame(() async {
///   scrollController.animateTo(
///     1000,
///     duration: Duration(milliseconds: 300),
///     curve: Curves.easeOut,
///   );
/// });
/// ```
///
/// Parameters:
/// * [callback] - An asynchronous function to execute after the frame is rendered.
///   The function can return a Future which will be awaited.
void postFrame(Future<void> Function() callback) {
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    try {
      await callback();
    } on Exception catch (e) {
      kprint.lg('** postFrame: $e');
    }
  });
}

/// Extension methods for keyboard-related operations on [BuildContext].
///
/// This extension provides utility methods for managing the keyboard state
/// from any widget that has access to a [BuildContext].
extension KeyboardUtil on BuildContext {
  /// Hides the software keyboard if it's currently visible.
  ///
  /// This method safely dismisses the keyboard by unfocusing the currently
  /// focused widget. It checks if there is a focused child before attempting
  /// to unfocus, making it safe to call even when the keyboard isn't shown.
  ///
  /// Example usage:
  /// ```dart
  /// // Hide keyboard when tapping outside a text field
  /// GestureDetector(
  ///   onTap: () {
  ///     context.hideKeyboard();
  ///   },
  ///   child: Container(
  ///     color: Colors.transparent,
  ///     child: yourWidget,
  ///   ),
  /// )
  ///
  /// // Hide keyboard when submitting a form
  /// ElevatedButton(
  ///   onPressed: () {
  ///     context.hideKeyboard();
  ///     submitForm();
  ///   },
  ///   child: Text('Submit'),
  /// )
  /// ```
  ///
  /// Note: This method does nothing if no widget is currently focused or if
  /// the primary focus already belongs to another widget that doesn't control
  /// the keyboard.
  void hideKeyboard() {
    final currentFocus = FocusScope.of(this);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      currentFocus.focusedChild!.unfocus();
    }
  }
}
