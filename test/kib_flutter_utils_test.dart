import 'package:flutter_test/flutter_test.dart';
import 'package:kib_flutter_utils/kib_flutter_utils.dart'
    show
        ExceptionX,
        UnauthorizedException,
        NotFoundException,
        NetworkException,
        ValidationException,
        ConfigurationException,
        InvalidActionException;

void main() {
  group('ExceptionX tests', () {
    test('creates ExceptionX with required properties', () {
      final error = Exception('Original error');
      final stackTrace = StackTrace.current;

      final exception = ExceptionX(
        message: 'Test error message',
        errorType: error.runtimeType,
        error: error,
        stackTrace: stackTrace,
      );

      expect(exception.message, 'Test error message');
      expect(exception.errorType, equals(error.runtimeType));
      expect(exception.error, error);
      expect(exception.stackTrace, stackTrace);
    });

    test('toString returns the message', () {
      final exception = ExceptionX(
        message: 'Test message',
        errorType: Exception,
        error: Exception(),
        stackTrace: StackTrace.current,
      );

      expect(exception.toString(), 'Test message');
    });

    test('empty message throws assertion error', () {
      expect(
        () => ExceptionX(
          message: '',
          errorType: Exception,
          error: Exception(),
          stackTrace: StackTrace.current,
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('UnauthorizedException tests', () {
    test('creates with message', () {
      final exception = UnauthorizedException('Invalid credentials');
      expect(exception.message, 'Invalid credentials');
    });
  });

  group('NotFoundException tests', () {
    test('creates with message', () {
      final exception = NotFoundException('User not found');
      expect(exception.message, 'User not found');
    });
  });

  group('NetworkException tests', () {
    test('creates with message and url', () {
      final exception = NetworkException(
        'Connection failed',
        'https://api.example.com',
      );
      expect(exception.message, 'Connection failed');
      expect(exception.url, 'https://api.example.com');
      expect(exception.statusCode, isNull);
    });

    test('creates with status code', () {
      final exception = NetworkException(
        'Server error',
        'https://api.example.com',
        statusCode: 500,
      );
      expect(exception.message, 'Server error');
      expect(exception.url, 'https://api.example.com');
      expect(exception.statusCode, 500);
    });
  });

  group('ValidationException tests', () {
    test('creates with message only', () {
      final exception = ValidationException('Validation failed');
      expect(exception.message, 'Validation failed');
      expect(exception.fieldErrors, isNull);
    });

    test('creates with field errors', () {
      final fieldErrors = {
        'email': 'Invalid email format',
        'password': 'Password too short',
      };

      final exception = ValidationException(
        'Form validation failed',
        fieldErrors: fieldErrors,
      );

      expect(exception.message, 'Form validation failed');
      expect(exception.fieldErrors, fieldErrors);
    });
  });

  group('ConfigurationException tests', () {
    test('creates with message', () {
      final exception = ConfigurationException('API key not configured');
      expect(exception.message, 'API key not configured');
    });
  });

  group('InvalidActionException tests', () {
    test('creates with message only', () {
      final exception = InvalidActionException('Cannot process at this time');
      expect(exception.message, 'Cannot process at this time');
      expect(exception.currentState, isNull);
      expect(exception.validActions, isNull);
    });

    test('creates with current state', () {
      final exception = InvalidActionException(
        'Cannot pause',
        currentState: 'stopped',
      );

      expect(exception.message, 'Cannot pause');
      expect(exception.currentState, 'stopped');
      expect(exception.validActions, isNull);
    });

    test('creates with valid actions', () {
      final validActions = ['play', 'stop'];
      final exception = InvalidActionException(
        'Cannot pause',
        currentState: 'stopped',
        validActions: validActions,
      );

      expect(exception.message, 'Cannot pause');
      expect(exception.currentState, 'stopped');
      expect(exception.validActions, validActions);
    });

    test('toString includes message, state and valid actions', () {
      final exception = InvalidActionException(
        'Cannot pause',
        currentState: 'stopped',
        validActions: ['play', 'stop'],
      );

      expect(
        exception.toString(),
        'Cannot pause (Current state: stopped) Valid actions: play, stop',
      );
    });

    test('toString works with partial information', () {
      final exception1 = InvalidActionException(
        'Cannot pause',
        currentState: 'stopped',
      );

      expect(exception1.toString(), 'Cannot pause (Current state: stopped)');

      final exception2 = InvalidActionException(
        'Cannot pause',
        validActions: ['play', 'stop'],
      );

      expect(exception2.toString(), 'Cannot pause Valid actions: play, stop');
    });
  });
}
