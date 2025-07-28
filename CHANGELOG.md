# Changelog

## [1.0.106]

### 🔧 StatelessWidgetK
- **BREAKING CHANGE**: Made `key` parameter required and removed `assert` statements to enable `const` constructor usage
- Improved performance optimization by maintaining const constructor compatibility
- Enhanced documentation with clearer usage examples and parameter requirements

## 1.0.105
### 🔧 StatefulWidgetK
- **BREAKING CHANGE**: Made `key` parameter required and removed `assert` statements to enable `const` constructor usage
- Improved performance optimization by maintaining const constructor compatibility

### ✨ StateManagementK Enhancements
- **New Features**:
  - Added `_statusMessage` private field for status tracking
  - Added getter methods for `_statusMessage` and utils for `_error`
  
- **New Utility Methods**:
  - `startLoading()` - Initialize loading state
  - `resetAllStates()` - Reset all state variables to default
  - `updateState()` - Generic state update helper
  - `setStatusMessage()` - Update status message with validation



## 1.0.104
* add LocalProviderUtils.

## 1.0.103
* add StateManagementK mixin for enhanced state management capabilities

## 1.0.102
* remove debug print statement from StatelessWidgetK build method

## 1.0.101
* Update README.md

## 1.0.100

* Added custom exception classes in `error_utils/exceptions.dart`
  * `ExceptionX`: Base exception class with extended error context
  * `UnauthorizedException`: For authentication failures
  * `NotFoundException`: For resource not found errors
  * `NetworkException`: For API and connection failures
  * `ValidationException`: For data validation errors
  * `ConfigurationException`: For missing configuration issues
  * `InvalidActionException`: For state-related errors

## 0.0.100

* Initial release with basic utilities
