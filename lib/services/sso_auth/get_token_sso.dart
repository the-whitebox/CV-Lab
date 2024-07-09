import 'dart:convert';
import 'package:crewdog_cv_lab/services/sso_auth/refresh_token.dart';
import '../../utils/consts/api_consts.dart';
import '../../utils/consts/constants.dart';
import 'package:http/http.dart' as http;
import '../../utils/local_db.dart';
import '../profile/retrieve_profile.dart';


Future<bool> getTokenFromCode(String code) async {
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
      final accessToken = decodedData['access_token'];
      final refreshToken = decodedData['refresh_token'];
      final expireAtString = decodedData['expires_at'];
      final DateTime expireAt = DateTime.parse(expireAtString);
      if (accessToken != null) {
        storeAccessToken(accessToken);
        var responseData = await retrieveProfile(accessToken);
        var profilePic = responseData['profile_pic'];
        if (profilePic != null) {
          storeProfilePic(profilePic);
        }
        var userId = responseData['id'];
        if(userId!=null){
          storeUserId(userId.toString());
        }
        if (refreshToken != null && expireAt !=null) {
          TokenRefresher().startRefreshTimer(refreshToken,expireAt);
        }
        return true;
      } else {
        print("Access token is null");
        return false;
      }
    } else {
      print("Response is null");
      return false;
    }
  } catch (error) {
    print('Error in generating token $error');
    return false;
  }
}
