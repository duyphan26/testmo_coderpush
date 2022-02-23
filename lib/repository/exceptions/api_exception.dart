import 'package:testmo_coderpush/repository/models/models.dart';

class ApiException implements Exception {
  final ApiError? _data;

  ApiException(
    Map<String, dynamic> json, {
    String? prefix,
  }) : _data = json['data'] != null ? ApiError.fromJson(json['data']) : null;

  ApiError? get error => _data;
}

class FetchDataException extends ApiException {
  FetchDataException([error])
      : super(error, prefix: 'Error During Communication:');
}

class BadRequestException extends ApiException {
  BadRequestException([error]) : super(error, prefix: 'Invalid Request: ');
}

class ForbiddenException extends ApiException {
  ForbiddenException([error]) : super(error, prefix: 'Forbidden: ');
}

class ServerErrorException extends ApiException {
  ServerErrorException([error]) : super(error, prefix: 'Server Error: ');
}

class ExpiredTokenException extends ApiException {
  ExpiredTokenException([error]) : super(error, prefix: 'Token Expired: ');
}
