import 'dart:async';
import 'dart:convert';
import 'package:crewdog_cv_lab/utils/local_db.dart';
import '../../utils/constants.dart';
import 'package:http/http.dart' as http;

class TokenRefresher {
  Timer? _timer;

  void startRefreshTimer(String refreshToken, DateTime expireAt) {
    Duration durationUntilExpiration = expireAt.difference(DateTime.now());

    _timer = Timer(durationUntilExpiration, () async {
      try {
        final url = Uri.parse(refreshTokenEndPoint);
        final payload = {
          'refresh': refreshToken,
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
          final refreshToken = decodedData['refresh_token'] as String?;
          final expireAtString = decodedData['expires_at'];
          final DateTime expireAt = DateTime.parse(expireAtString);
          if (accessToken != null && refreshToken!=null) {
            storeAccessToken(accessToken);
            storeRefreshToken(refreshToken);
            startRefreshTimer(refreshToken!, expireAt);
          }
        } else {
          print("Error");
        }
      } catch (error) {
     print("Error in Refresh token catch $error");
      }
    });
  }

  void cancelRefreshTimer() {
    _timer?.cancel();
  }
}
