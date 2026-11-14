import 'package:campus_net/dio_http.dart';
import 'package:campus_net/dbg_print.dart';
import 'package:campus_net/crypto.dart';

void main() async {
  // var http = DioHttp();
  // http.login2SelfHelp();
  funTest();
  String key = 'aYqrK+l4EM4cqJ+7IbTe4Q==';
  String payload = 'UyET+K6UM8esqZHEu4t64w==';
  print(aes_decrypt(key, payload));
}

int ret(int a) {
  if (a > 5) return 114;
  return 0;
}

void funTest() {
  List<String> session = [];
  print(session.length);
  print('now add a element');
  session.add('one');
  print(session.length);
  print(session[session.length - 1]);

  print(ret(7));
}
