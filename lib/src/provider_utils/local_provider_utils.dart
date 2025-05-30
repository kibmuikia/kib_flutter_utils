import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// A utility class that provides local scoped providers to specific widget subtrees.
/// This approach avoids global provider pollution and ensures providers are only
/// available where they're actually needed.
class LocalProviderUtils {
  /// A more generic version that accepts any ChangeNotifier-based provider.
  /// This allows you to locally scope other providers using the same pattern.
  ///
  /// Type parameter T must extend ChangeNotifier to work with ChangeNotifierProvider.
  ///
  /// Parameters:
  /// - [create]: A function that creates and returns an instance of type T
  /// - [child]: The widget that needs access to the provider
  ///
  /// Example usage:
  /// ```dart
  /// LocalProviderUtils.withProvider<MyCustomProvider>(
  ///   create: (context) => MyCustomProvider(),
  ///   child: MyWidget(),
  /// );
  /// ```
  static Widget withProvider<T extends ChangeNotifier>({
    required T Function(BuildContext context) create,
    required Widget child,
  }) {
    return ChangeNotifierProvider<T>(create: create, child: child);
  }

  /// Creates multiple locally scoped providers in a single call.
  /// This is useful when a widget subtree needs access to multiple providers
  /// but you want to keep them locally scoped rather than global.
  ///
  /// Parameters:
  /// - [providers]: List of provider configurations
  /// - [child]: The widget that needs access to all the providers
  ///
  /// Example usage:
  /// ```dart
  /// LocalProviderUtils.withMultipleProviders(
  ///   providers: [
  ///     ChangeNotifierProvider<FirestoreObituaryServiceProvider>(
  ///       create: (_) => FirestoreObituaryServiceProvider(),
  ///     ),
  ///     ChangeNotifierProvider<AnotherProvider>(
  ///       create: (_) => AnotherProvider(),
  ///     ),
  ///   ],
  ///   child: MyComplexWidget(),
  /// );
  /// ```
  static Widget withMultipleProviders({
    required List<Provider> providers,
    required Widget child,
  }) {
    return MultiProvider(providers: providers, child: child);
  }
}

/// Extension methods on Widget to make local provider usage even more convenient.
/// These extensions allow you to chain provider wrapping directly on any widget.
extension LocalProviderExtensions on Widget {
  /// Wraps this widget with any ChangeNotifier-based provider.
  ///
  /// Example usage:
  /// ```dart
  /// MyWidget().withProvider<MyProvider>(
  ///   create: (context) => MyProvider(),
  /// )
  /// ```
  Widget withProvider<T extends ChangeNotifier>({
    required T Function(BuildContext context) create,
  }) {
    return LocalProviderUtils.withProvider<T>(create: create, child: this);
  }
}
