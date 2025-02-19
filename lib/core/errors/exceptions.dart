class CacheException implements Exception {
  final String message;
  CacheException([this.message = "Cache Error"]);

  @override
  String toString() => "CacheException: $message";
}

class ServerException implements Exception {
  final String message;
  ServerException([this.message = "Server Error"]);

  @override
  String toString() => "ServerException: $message";
}
