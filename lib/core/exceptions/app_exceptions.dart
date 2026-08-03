import 'package:equatable/equatable.dart';

/// Base class for all application-specific exceptions
abstract class AppException extends Equatable implements Exception {
  final String message;
  final String? code;

  const AppException(this.message, [this.code]);

  @override
  List<Object?> get props => [message, code];

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'No Internet Connection', super.code]);
}

class ServerException extends AppException {
  const ServerException([super.message = 'Internal Server Error', super.code]);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Unauthorized Access', super.code]);
}

class UnknownException extends AppException {
  const UnknownException([super.message = 'Something went wrong', super.code]);
}

/// A wrapper class to hold UI-friendly error messages
class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure(this.message, [this.code]);

  factory Failure.fromException(Object exception) {
    if (exception is AppException) {
      return Failure(exception.message, exception.code);
    }
    return Failure(exception.toString());
  }

  @override
  List<Object?> get props => [message, code];
}
