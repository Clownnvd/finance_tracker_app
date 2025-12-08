class BaseResponse<T> {
  final T? data;
  final String? error;

  const BaseResponse({this.data, this.error});

  bool get isSuccess => error == null && data != null;
}
