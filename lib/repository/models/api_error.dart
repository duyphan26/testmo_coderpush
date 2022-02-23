class ApiError {
  final String? error;

  // ignore: prefer_constructors_over_static_methods
  static ApiError fromJson(Map<String, dynamic> json) {
    return ApiError(
      error: json['error'],
    );
  }

  ApiError({
    this.error,
  });
}
