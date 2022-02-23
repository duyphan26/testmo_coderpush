import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:retry/retry.dart';
import 'package:testmo_coderpush/common/common.dart';
import 'package:testmo_coderpush/repository/repository.dart';

const defaultErrorJson = '{"data": {"message": "Error occured while '
    'communication server with statusCode"}}';

abstract class BaseRemoteDataSource {
  late Client _client;
  late String _host;

  BaseRemoteDataSource(
      String host, {
        Client? client,
      }) {
    _client = client ?? Client();
    _host = host;
  }

  Uri _getParsedUrl(String path) {
    return Uri.parse('$_host$path');
  }

  BaseRequest _copyRequest(BaseRequest request) {
    BaseRequest requestCopy;

    if (request is Request) {
      requestCopy = Request(request.method, request.url)
        ..encoding = request.encoding
        ..bodyBytes = request.bodyBytes;
    } else if (request is MultipartRequest) {
      requestCopy = MultipartRequest(request.method, request.url)
        ..fields.addAll(request.fields)
        ..files.addAll(request.files);
    } else if (request is StreamedRequest) {
      throw Exception('copying streamed requests is not supported');
    } else {
      throw Exception('request type is unknown, cannot copy');
    }

    requestCopy
      ..persistentConnection = request.persistentConnection
      ..followRedirects = request.followRedirects
      ..maxRedirects = request.maxRedirects
      ..headers.addAll(request.headers);

    return requestCopy;
  }

  dynamic _call(
      String method,
      String path, {
        Map<String, Object?>? data,
      }) async {
    debugPrint(
        'Call API >> $method >> url: ${_getParsedUrl(path)} >> body: $data');
    dynamic responseJson;
    var numberAttempts = 0;
    try {
      var request = Request(method, _getParsedUrl(path));

      request.headers['app-id'] = '6215cdaea4314385496edb85';

      responseJson = await retry(() async {
        final response = await _client
            .send(request)
            .timeout(const Duration(seconds: 120))
            .then(Response.fromStream);
        return _returnResponse(response);
      }, retryIf: (e) async {
        debugPrint('Call API >> url: ${_getParsedUrl(path)} >> Error: $e');
        if (e is ExpiredTokenException) {
          if (numberAttempts == 3) {
            return false;
          }

          request.headers['app-id'] = '6215cdaea4314385496edb85';
          request = asT<Request>(_copyRequest(request))!;
          numberAttempts += 1;

          return true;
        }

        return false;
      });
    } on SocketException {
      debugPrint('No Internet connection');
      throw const SocketException('Operation timed out');
    }
    debugPrint('''Call API >>
     $method >> url: ${_getParsedUrl(path)} >> response: $responseJson''');

    return responseJson;
  }

  dynamic _returnResponse(Response response) {
    debugPrint('HTTP response\n'
        'Status: ${response.statusCode}\n'
        'Request: ${response.request}\n'
        'Data: ${response.body}');

    switch (response.statusCode) {
      case 200:
        if (response.body.isNotNullAndEmpty) {
          final responseJson = jsonDecode(response.body);
          return responseJson;
        }
        return null;
      case 201:
        if (response.body.isNotNullAndEmpty) {
          final responseJson = jsonDecode(response.body);
          return responseJson;
        }
        return null;
      case 400:
        final responseJson = jsonDecode(response.body);
        throw BadRequestException(responseJson);
      case 403:
        final responseJson = jsonDecode(response.body);
        throw ForbiddenException(responseJson);
      case 500:
        final responseJson = jsonDecode(response.body);
        throw ServerErrorException(responseJson);
      default:
        final responseJson = jsonDecode(defaultErrorJson);
        throw FetchDataException(responseJson);
    }
  }

  dynamic get(String path) async {
    return await _call('GET', path);
  }

  dynamic post(String path, [dynamic data]) async {
    return await _call('POST', path, data: data);
  }
}
