# Kib Flutter Utils

A collection of Flutter utility classes and functions to simplify common tasks in Flutter development.

## Features

- Error handling utilities with custom exception types
- Snackbar utilities for quick feedback
- Widget utilities for common UI patterns
- General utility functions

## Installation

```yaml
dependencies:
  kib_flutter_utils: ^1.0.0
```

## Usage

### Error Handling

```dart
import 'package:kib_flutter_utils/kib_flutter_utils.dart';

try {
  // Some API call
  final response = await apiClient.fetchData();
  if (response.statusCode == 404) {
    throw NotFoundException('User profile not found');
  }
} catch (e, stackTrace) {
  throw ExceptionX(
    message: 'Failed to fetch user data',
    errorType: e.runtimeType,
    error: e,
    stackTrace: stackTrace,
  );
}
```

