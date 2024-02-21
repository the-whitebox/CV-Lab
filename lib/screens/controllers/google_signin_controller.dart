import 'dart:convert';
import 'package:crewdog_cv_lab/screens/controllers/profile_controller.dart';
import 'package:crewdog_cv_lab/utils/local_db.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import '../../routes/app_routes.dart';
import '../../utils/app_snackbar.dart';
import '../../utils/constants.dart';
import '../../utils/functions.dart';

class GoogleSignInApi {
  static final _googleSignIn = GoogleSignIn();
  static Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();
}

Future googleSignIn() async {

  if (await isInternetConnected()){
    await GoogleSignInApi._googleSignIn.signOut();
    final GoogleSignInAccount? googleSignInAccount =
    await GoogleSignInApi.login();
    GoogleSignInAuthentication? googleAuth =
    await googleSignInAccount?.authentication;
    String? accessToken = googleAuth?.accessToken!;
    await _sendAccessTokenToServer(accessToken!);
  }else {
    appSnackBar(" Error", "No internet connectivity");
  }

}

Future<void> _sendAccessTokenToServer(String accessToken) async {
  {
    try {
      if (accessToken != null) {
        final response = await http.post(
          Uri.parse('$baseUrl/accounts/social/google/login/'),
          body: {'access_token': accessToken},
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          final String? access = responseData['tokens']['access'];
          storeAccessToken(access!);


          var profileResponse = await fetchProfile(access);
          print(profileResponse);
          var id = profileResponse['id'];
          // var email = responseData['email'];
          var profilePic = profileResponse['profile_pic'];
          // var firstName = response['first_name'];
          // var lastName = response['last_name'];
          // var avatarUrl = response['avatar_url'];
          storeUserId(id.toString());
          if(profilePic!=null) {
            print("Profile Pic Stored");
            storeProfilePic(profilePic);
          }


          Get.offAllNamed(AppRoutes.bottomBar);
          print('***Server Response: $responseData');
        } else {
          // Error response from the server
          print('Server Error: ${response.statusCode}');
          print('Server Response: ${response.body}');
        }
      }
    } catch (error) {
      print('Error sending access token to server: $error');
    }
  }

}