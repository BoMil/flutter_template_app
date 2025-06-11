enum ResponseStatus { loading, completed, error }

class ApiResponse<T> {
  ResponseStatus status;
  String? statusCode;
  T? data;
  String message = '';

  ApiResponse.loading(this.message) : status = ResponseStatus.loading;

  ApiResponse.completed(this.data) : status = ResponseStatus.completed;

  ApiResponse.error(this.message, {this.statusCode = ''}) : status = ResponseStatus.error;

  @override
  String toString() {
    return 'Status : $status \n Message : $message \n Data : $data';
  }
}
