class BaseResponse<T> {
  final T? data;
  final String? error;

  const BaseResponse({this.data, this.error})
      : assert(
          (data != null && error == null) ||
              (data == null && error != null) ||
              (data == null && error == null),
          'BaseResponse cannot contain both data and error.',
        );

  bool get hasData => data != null;

  bool get hasError => error != null;

  bool get isSuccess => data != null && error == null;

  T get requireData {
    if (data == null) {
      throw StateError(
        'BaseResponse.requireData called but data is null. Error: $error',
      );
    }
    return data as T;
  }

  BaseResponse<T> copyWith({
    T? data,
    String? error,
  }) {
    return BaseResponse<T>(
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }

  @override
  String toString() {
    if (hasError) return 'BaseResponse(error: $error)';
    return 'BaseResponse(data: $data)';
  }
}
