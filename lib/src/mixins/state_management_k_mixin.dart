/* state_management_k_mixin.dart */

import 'package:flutter/material.dart';
import 'package:kib_flutter_utils/kib_flutter_utils.dart'
    show StateK, StatefulWidgetK;
import 'package:kib_utils/kib_utils.dart' show Result, failure, success;

/// A mixin to add state management capabilities to StateK
mixin StateManagementK<T extends StatefulWidgetK> on StateK<T> {
  bool _isLoading = false;
  Object? _error;

  bool get isLoading => _isLoading;
  Object? get error => _error;

  /// Safely updates loading state
  @protected
  void setLoading(bool value) {
    if (mounted) {
      setState(() => _isLoading = value);
    }
  }

  /// Safely updates error state
  @protected
  void setError(Object? error) {
    if (mounted) {
      setState(() => _error = error);
    }
  }

  /// Helper to wrap async operations with loading and error states
  @protected
  Future<Result<A, Exception>> withStateManagement<A>(
    Future<A> Function() operation,
  ) async {
    try {
      setLoading(true);
      setError(null);
      final result = await operation();
      return success(result);
    } catch (e, stack) {
      setError(e);
      logError('Operation failed', e, stack);
      return failure(e is Exception ? e : Exception(e.toString()));
    } finally {
      setLoading(false);
    }
  }
}
