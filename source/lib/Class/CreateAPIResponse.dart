class CreateAPIResponse {
  final bool success;
  final dynamic data;
  final String? errorMessage;

  CreateAPIResponse({
    required this.success,
    this.data,
    this.errorMessage,
  });
}
