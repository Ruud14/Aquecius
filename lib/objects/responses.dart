/// Response that we use to communicate data back from service calls.
class BackendResponse<T> {
  final bool isSuccessful;
  final String? message;
  final T? data;
  BackendResponse({
    required this.isSuccessful,
    this.message,
    this.data,
  });
}
