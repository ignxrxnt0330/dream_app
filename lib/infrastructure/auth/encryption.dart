import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter/material.dart';

class Encryption {
  /// ChaCha20 needs a 32 byte key, so the password is hashed with SHA-256
  /// before being used as the key.
  static Future<SecretKey> _secretKey(String encryptionKey) async {
    final Hash hash = await Sha256().hash(utf8.encode(encryptionKey));
    return SecretKey(hash.bytes);
  }

  static Future<String> encryptData(String data, String encryptionKey) async {
    final algorithm = Chacha20.poly1305Aead();

    final SecretKey key = await _secretKey(encryptionKey);

    final nonce = algorithm.newNonce();

    final secretBox = await algorithm.encrypt(
      utf8.encode(data),
      secretKey: key,
      nonce: nonce,
    );

    return jsonEncode({
      'nonce': base64Encode(secretBox.nonce),
      'mac': base64Encode(secretBox.mac.bytes),
      'ciphertext': base64Encode(secretBox.cipherText)
    });
  }

  static Future<String> decryptData(
      String encryptedData, String encryptionKey) async {
    final algorithm = Chacha20.poly1305Aead();

    final SecretKey key = await _secretKey(encryptionKey);

    final json = jsonDecode(encryptedData);

    debugPrint("key $key");
    debugPrint("cipher ${json['ciphertext']}");
    debugPrint("mac ${json['mac']}");
    debugPrint("nonce ${json['nonce']}");

    final secretBox = SecretBox(
      base64Decode(json['ciphertext']),
      nonce: base64Decode(json['nonce']),
      mac: Mac(base64Decode(json['mac'])),
    );

    final List<int> decrypted = await algorithm.decrypt(
      secretBox,
      secretKey: key,
    );

    return utf8.decode(decrypted);
  }

  /// Deterministic hash of [data] (unlike [encryptData], it always returns
  /// the same value for the same input), used to detect unsaved changes.
  static Future<String> hashData(String data) async {
    final Hash hash = await Sha256().hash(utf8.encode(data));
    return base64Encode(hash.bytes);
  }
}
