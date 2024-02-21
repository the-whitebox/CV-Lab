import 'dart:convert';

import 'package:get/get.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:http/http.dart' as http;
import 'package:crewdog_cv_lab/utils/constants.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_snackbar.dart';
import '../../utils/functions.dart';
import '../../utils/local_db.dart';

void appleSignIn() async {
  if (await isInternetConnected()){
    final credentials = await SignInWithApple.getAppleIDCredential(scopes: [
      AppleIDAuthorizationScopes.email,
      AppleIDAuthorizationScopes.fullName,
    ]);
    print('IdToken: ${credentials.identityToken}');

    // Send the identity token to server
    final response = await http.post(
      Uri.parse('$baseUrl/accounts/social/apple/login/'),
      body: {'token': credentials.identityToken},
    );

    // Handle the server response
    if (response.statusCode == 200) {
      // Authentication successful on the server side
      print('***Server Response: ${response.body}');
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      // final String? access = responseData['access'];
      // storeAccessToken(access!);
      // print("Access Token:$access");
      Get.offAllNamed(AppRoutes.bottomBar);
    } else {
      // Handle errors
      print('Server Error: ${response.statusCode}');
      print('Server Response: ${response.body}');
    }
  }else {
    appSnackBar(" Error", "No internet connectivity");
  }


}
