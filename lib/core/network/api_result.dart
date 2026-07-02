// lib/core/network/api_result.dart
import '../errors/app_exceptions.dart';

class ApiResult<T> {
  final T? data;
  final AppException? error;
  final bool isSuccess;
  
  ApiResult.success(this.data)
      : error = null,
        isSuccess = true;
  
  ApiResult.failure(this.error)
      : data = null,
        isSuccess = false;
  
  void handle({
    required Function(T data) onSuccess,
    required Function(AppException error) onFailure,
  }) {
    if (isSuccess && data != null) {
      onSuccess(data!);
    } else if (error != null) {
      onFailure(error!);
    }
  }
}