`
final dio = Dio();

try {
  final res = await dio.get(
    'https://example.com/api/user',
    queryParameters: {'id': 1},
  );

  print(res.statusCode);     // 200
  print(res.statusMessage);  // OK
  print(res.headers);        // 响应头
  print(res.requestOptions.path); // /api/user
  print(res.data);           // 自动解析后的 JSON
} on DioException catch (e) {
  // 即使报错，也可能有 response
  print(e.response?.statusCode);
  print(e.response?.data);
} 

final dio = Dio(BaseOptions(
  baseUrl: 'https://api.example.com',
  connectTimeout: Duration(seconds: 10),
  receiveTimeout: Duration(seconds: 10),
  sendTimeout: Duration(seconds: 10),
  contentType: Headers.jsonContentType,
  responseType: ResponseType.json,
  headers: {
    'Accept': 'application/json',
  },
));

