abstract class Resource<T> {}

class Loading<T> extends Resource<T> {
  final bool isLoading;
  Loading(this.isLoading);
}

class Success<T> extends Resource<T> {
  final T data;
  Success(this.data);
}

class Error<T> extends Resource<T> {
  final String error;
  Error(this.error);
}
