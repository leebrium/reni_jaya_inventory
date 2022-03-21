class Response {
  String errorMessage = "";
  bool get success {
    return errorMessage.isEmpty;
  }

  Response({required this.errorMessage});
}