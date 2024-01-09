// ignore_for_file: constant_identifier_names

enum Status {
  LOADING,
  SUCCESS,
  ERROR;

  bool get isLoading => this == Status.LOADING;
  bool get isSuccess => this == Status.SUCCESS;
  bool get isError   => this == Status.ERROR;
}