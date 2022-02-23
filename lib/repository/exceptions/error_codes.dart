class ErrorCodes {
  static _Internal get Internal => _Internal();
}

class _Internal {
  static final _Internal _singleton = _Internal._internal();

  factory _Internal() {
    return _singleton;
  }

  _Internal._internal();

  final String appIdNotExist = 'APP_ID_NOT_EXIST';
  final String appIdMissing = 'APP_ID_MISSING';
  final String paramsNotValid = 'PARAMS_NOT_VALID';
  final String bodyNotValid = 'BODY_NOT_VALID';
  final String resourceNotFound = 'RESOURCE_NOT_FOUND';
  final String pathNotFound = 'PATH_NOT_FOUND';
  final String serverError = 'SERVER_ERROR';
}
