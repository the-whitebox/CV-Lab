import 'dart:convert';
import '../../utils/constants.dart';
import 'package:http/http.dart' as http;


Future<String> getTokenFromCode(String code) async {
  try {
    final url = Uri.parse("$tokenEndPoint?code=$code");
    final payload = {
      'code': code,
      'grant_type': 'authorization_code',
      'client_id': clientID,
      'client_secret': clientSecret,
      'redirect_uri': redirectUrl,
    };
    final headers = {
      'Content-Type': 'application/json',
    };
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      final accessToken = decodedData['access_token'] as String?;
      if (accessToken != null) {
        return accessToken;
      } else {
        return '';
      }
    } else {
      return '';
    }
  } catch (error) {
    return "";
  }
}
