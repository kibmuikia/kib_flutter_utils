import 'package:flutter/material.dart'
    show
        BuildContext,
        ColorScheme,
        State,
        StatefulWidget,
        StatelessWidget,
        TextTheme,
        Theme,
        ThemeData,
        VoidCallback,
        Widget,
        protected;
import 'package:kib_debug_print/kib_debug_print.dart' show kprint;
import 'package:kib_flutter_utils/src/snackbar_utils.dart';
import 'package:kib_utils/kib_utils.dart' show Result;

/// A customized base class for stateful widgets with integrated logging
/// and theme access.
///
/// This abstract class extends [StatefulWidget] with additional functionality:
/// - Automatic logging of widget lifecycle events
/// - Required tagging for better debugging
/// - Theme data access in the state class
///
/// Example usage:
/// ```dart
/// class MyCustomWidget extends StatefulWidgetK {
///   final String title;
///
///   const MyCustomWidget({
///     Key? key,
///     required this.title,
///   }) : super(key: key, tag: 'MyCustomWidget');
///
///   @override
///   StateK<StatefulWidgetK> createState() => _MyCustomWidgetState();
/// }
///
/// class _MyCustomWidgetState extends StateK<MyCustomWidget> {
///   @override
///   Widget buildWithTheme(BuildContext context) {
///     return Column(
///       children: [
///         Text(
///           widget.title,
///           style: textTheme.headlineMedium?.copyWith(
///             color: colorScheme.primary,
///           ),
///         ),
///         ElevatedButton(
///           onPressed: () => informUser('Button pressed'),
///           child: const Text('Press Me'),
///         ),
///       ],
///     );
///   }
/// }
/// ```
abstract class StatefulWidgetK extends StatefulWidget {
  /// Unique identifier for this widget, used for logging and debugging
  final String tag;

  /// Creates a [StatefulWidgetK] with the specified [tag].
  ///
  /// The [tag] parameter is required and must not be empty.
  /// It is used for logging lifecycle events and improving debugging.
  StatefulWidgetK({super.key, required this.tag})
    : assert(tag.isNotEmpty, 'Tag must not be empty');

  @override
  StateK<StatefulWidgetK> createState();
}

/// A customized base class for state objects with integrated logging
/// and theme access.
///
/// This abstract class extends [State] with additional functionality:
/// - Automatic logging of widget lifecycle events
/// - Safe setState calls that check if the widget is mounted
/// - Easy access to theme data
/// - Helper method for showing user messages
///
/// @typeParam T The type of the associated [StatefulWidgetK]
abstract class StateK<T extends StatefulWidgetK> extends State<T> {
  late ThemeData _theme;
  late ColorScheme _colorScheme;
  late TextTheme _textTheme;

  /// The current theme data, initialized in [build].
  ///
  /// This provides easy access to the app's theme without
  /// repeatedly calling `Theme.of(context)`.
  @protected
  ThemeData get theme => _theme;

  /// The current color scheme from the theme.
  ///
  /// Provides convenient access to the color palette.
  @protected
  ColorScheme get colorScheme => _colorScheme;

  /// The current text theme from the theme.
  ///
  /// Provides convenient access to text styles.
  @protected
  TextTheme get textTheme => _textTheme;

  @override
  void initState() {
    super.initState();
    kprint.lg('initState: ${widget.tag}');
  }

  @override
  void dispose() {
    kprint.lg('dispose: ${widget.tag}');
    super.dispose();
  }

  /// Safely calls [setState] only if the widget is mounted.
  ///
  /// This prevents the common error of calling setState after
  /// a widget has been disposed.
  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    _colorScheme = _theme.colorScheme;
    _textTheme = _theme.textTheme;
    return buildWithTheme(context);
  }

  /// Builds the widget with convenient access to theme data.
  ///
  /// This method should be implemented instead of the standard [build]
  /// method. The theme data properties will be initialized before this
  /// method is called.
  ///
  /// @param context The build context
  /// @return The widget to render
  @protected
  Widget buildWithTheme(BuildContext context);

  /// Displays a message to the user using a snackbar.
  ///
  /// This is a convenience method that uses the [showMessage] extension
  /// from snackbar_utils.dart.
  ///
  /// @param message The message to display to the user
  @protected
  void informUser(String message) {
    if (mounted) context.showMessage(message);
  }

  /// Logs a debug message with the widget's tag.
  ///
  /// This is a convenience method for logging that automatically
  /// includes the widget's tag.
  ///
  /// @param message The message to log
  @protected
  void logDebug(String message) {
    kprint.lg('${widget.tag}: $message');
  }

  /// Logs an error message with the widget's tag.
  ///
  /// This is a convenience method for logging errors that automatically
  /// includes the widget's tag.
  ///
  /// @param message The error message to log
  /// @param [error] Optional error object
  /// @param [stackTrace] Optional stack trace
  @protected
  void logError(String message, [Object? error, StackTrace? stackTrace]) {
    kprint.err(
      '${widget.tag} ERROR${error == null ? '' : '[${error.runtimeType}]'}: $message',
    );
  }
}

/// A customized base class for stateless widgets with integrated logging
/// and theme access.
///
/// This abstract class extends [StatelessWidget] with additional functionality:
/// - Automatic logging of widget builds
/// - Required tagging for better debugging
/// - Convenient theme data access in the build method
/// - Helper method for showing user messages
///
/// Example usage:
/// ```dart
/// class MyInfoCard extends StatelessWidgetK {
///   final String title;
///   final String content;
///
///   const MyInfoCard({
///     Key? key,
///     required this.title,
///     required this.content,
///   }) : super(key: key, tag: 'MyInfoCard');
///
///   @override
///   Widget buildWithTheme(
///     BuildContext context,
///     ThemeData theme,
///     ColorScheme colorScheme,
///     TextTheme textTheme,
///   ) {
///     return Card(
///       color: colorScheme.surface,
///       child: Padding(
///         padding: const EdgeInsets.all(16.0),
///         child: Column(
///           crossAxisAlignment: CrossAxisAlignment.start,
///           children: [
///             Text(title, style: textTheme.titleLarge),
///             const SizedBox(height: 8),
///             Text(content, style: textTheme.bodyMedium),
///             TextButton(
///               onPressed: () => informUser(context, 'More info coming soon'),
///               child: const Text('More Info'),
///             ),
///           ],
///         ),
///       ),
///     );
///   }
/// }
/// ```
abstract class StatelessWidgetK extends StatelessWidget {
  /// Unique identifier for this widget, used for logging and debugging
  final String tag;

  /// Creates a [StatelessWidgetK] with the specified [tag].
  ///
  /// The [tag] parameter is required and must not be empty.
  /// It is used for logging builds and improving debugging.
  StatelessWidgetK({super.key, required this.tag})
    : assert(tag.isNotEmpty, 'Tag must not be empty');

  @override
  Widget build(BuildContext context) {
    kprint.lg('build: $tag');
    final theme = Theme.of(context);
    return buildWithTheme(context, theme, theme.colorScheme, theme.textTheme);
  }

  /// Builds the widget with convenient access to theme data.
  ///
  /// This method should be implemented instead of the standard [build]
  /// method. The theme data is extracted and passed as parameters for
  /// convenience.
  ///
  /// @param context The build context
  /// @param theme The current theme data
  /// @param colorScheme The current color scheme
  /// @param textTheme The current text theme
  /// @return The widget to render
  @protected
  Widget buildWithTheme(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    TextTheme textTheme,
  );

  /// Displays a message to the user using a snackbar.
  ///
  /// This is a convenience method that uses the [showMessage] extension
  /// from snackbar_utils.dart and returns a [Result] for error handling.
  ///
  /// @param context The current build context
  /// @param message The message to display to the user
  /// @return A [Result] indicating success or containing an exception
  @protected
  Result<void, Exception> informUser(BuildContext context, String message) =>
      context.showMessage(message);

  /// Logs a debug message with the widget's tag.
  ///
  /// This is a convenience method for logging that automatically
  /// includes the widget's tag.
  ///
  /// @param message The message to log
  @protected
  void logDebug(String message) {
    kprint.lg('$tag: $message');
  }

  /// Logs an error message with the widget's tag.
  ///
  /// This is a convenience method for logging errors that automatically
  /// includes the widget's tag.
  ///
  /// @param message The error message to log
  /// @param [error] Optional error object
  /// @param [stackTrace] Optional stack trace
  @protected
  void logError(String message, [Object? error, StackTrace? stackTrace]) {
    kprint.err(
      '$tag ERROR${error == null ? '' : '[${error.runtimeType}]'}: $message',
    );
  }
}
