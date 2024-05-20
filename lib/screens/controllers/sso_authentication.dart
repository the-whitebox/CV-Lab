import 'dart:convert';
import 'package:flutter_appauth/flutter_appauth.dart';
import '../../utils/constants.dart';
import 'package:http/http.dart' as http;

const appAuth = FlutterAppAuth();

Future<String> signInWithSso() async {
  try {
    final AuthorizationResponse? result = await appAuth.authorize(
      AuthorizationRequest(
        allowInsecureConnections: true,
        clientID,
        redirectUrl,
        responseMode: 'code',
        issuer: issuerUrl,
      ),
    );

    if (result != null) {
      final token = getTokenFromCode(result.authorizationCode!);
      return token;
    } else {
      return "";
    }
  } catch (e) {
    return '';
  }
}

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
        print("Access Token: $accessToken");
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
