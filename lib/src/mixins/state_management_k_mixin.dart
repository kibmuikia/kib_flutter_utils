/* state_management_k_mixin.dart */

import 'package:flutter/material.dart';
import 'package:kib_flutter_utils/kib_flutter_utils.dart'
    show StateK, StatefulWidgetK;
import 'package:kib_utils/kib_utils.dart' show Result, failure, success;

/// A mixin to add state management capabilities to StateK
mixin StateManagementK<T extends StatefulWidgetK> on StateK<T> {
  bool _isLoading = false;
  Object? _error;
  String _statusMessage = "";

  bool get isLoading => _isLoading;
  String get statusMessage => _statusMessage;
  Object? get error => _error;
  Type? get errorType => _error?.runtimeType;
  String? get genericErrorMessage =>
      errorType == null ? null : 'Encountered $errorType issue';
  bool get hasError => _error != null;

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

  /// Safely updates statusMessage state
  @protected
  void setStatusMessage(String message) {
    if (mounted) {
      setState(() => _statusMessage = message);
    }
  }

  /// Safely updates isLoading or error or statusMessage; in any combination
  /// Only sets a state if its not null.
  @protected
  void updateState({bool? isLoading, Object? error, String? statusMessage}) {
    if (mounted) {
      setState(() {
        if (isLoading != null) _isLoading = isLoading;
        if (error != null) _error = error;
        if (statusMessage != null) _statusMessage = statusMessage;
      });
    }
  }

  /// Safely reset all states
  @protected
  void resetAllStates() {
    if (mounted) {
      setState(() {
        _isLoading = false;
        _error = null;
        _statusMessage = "";
      });
    }
  }

  /// Safely start a loading state by setting isLoading to true and error to null
  @protected
  void startLoading() {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }
  }

  /// Helper to wrap async operations with loading and error states
  @protected
  Future<Result<A, Exception>> withStateManagement<A>(
    Future<A> Function() operation,
  ) async {
    try {
      startLoading();
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
