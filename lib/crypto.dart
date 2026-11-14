import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';

String aes_encrypt(String keyBase64, String cipherBase64) {
  final keyBytes = base64.decode(base64.normalize(keyBase64));
  final encrypter = Encrypter(
    AES(Key(keyBytes), mode: AESMode.ecb, padding: 'PKCS7'),
  );
  // ECB 不用 IV，但该库要求传入一个 IV 对象，给全 0 即可
  return encrypter.encrypt(cipherBase64, iv: IV(Uint8List(16))).base64;
}

/// AES-ECB + PKCS7 解密
/// keyBase64: Base64 编码的密钥（16/24/32 字节）
/// cipherBase64: Base64 编码的密文
String aes_decrypt(String keyBase64, String cipherBase64) {
  // 1. 密钥：Base64 -> 原始字节
  final keyBytes = base64.decode(base64.normalize(keyBase64));

  // 2. 密文：Base64 -> 原始字节
  final cipherBytes = base64.decode(base64.normalize(cipherBase64));

  // 3. AES-ECB + PKCS7
  final encrypter = Encrypter(
    AES(Key(keyBytes), mode: AESMode.ecb, padding: 'PKCS7'),
  );

  // 4. 解密（ECB 不需要 IV，但 encrypt 包要求传入，给全 0 即可）
  final decrypted = encrypter.decrypt(
    Encrypted(cipherBytes),
    iv: IV(Uint8List(16)),
  );

  return decrypted;
}

String xorToBase64(String input, String key) {
  final inputBytes = utf8.encode(input);
  final keyBytes = utf8.encode(key);

  final result = <int>[];
  for (var i = 0; i < inputBytes.length; i++) {
    result.add(inputBytes[i] ^ keyBytes[i % keyBytes.length]);
  }

  // 关键改动：直接对字节做 Base64
  return base64.encode(result);
}

String xorDecrypt(String base64Str, String key) {
  final bytes = base64.decode(base64Str);
  final keyBytes = utf8.encode(key);

  final result = <int>[];
  for (var i = 0; i < bytes.length; i++) {
    result.add(bytes[i] ^ keyBytes[i % keyBytes.length]);
  }

  return utf8.decode(result);
}

String pass(String pswd) {
  String key = 'SGVsbG8=';
  return xorDecrypt(pswd, key);
}
