# Changelog

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
