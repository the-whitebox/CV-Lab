import 'package:crewdog_cv_lab/services/sso_auth/get_token_sso.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import '../../../utils/constants.dart';


const appAuth = FlutterAppAuth();

Future<bool> signInWithSso() async {
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
      final token =await  getTokenFromCode(result.authorizationCode!);
      if(token){
        return true;
      }else{
        print("Token Is Invalid");
        return false;
      }
    } else {
      print("Code Is Empty");
      return false;
    }
  } catch (e) {
    print(" Error $e");
    return false;
  }
}
