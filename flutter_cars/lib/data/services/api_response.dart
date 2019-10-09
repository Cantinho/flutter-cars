

class ApiResponse<T> {
  T result;
  String error;

  ApiResponse.success(this.result) {
    error = null;
  }

  ApiResponse.error(this.error) {
    result = null;
  }

  bool isSuccess() {
    return error == null;
  }
}