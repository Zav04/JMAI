class APIResponse {
  final bool success;
  final dynamic data;
  final String? errorMessage;

  APIResponse({
    required this.success,
    this.data,
    this.errorMessage,
  });
}
