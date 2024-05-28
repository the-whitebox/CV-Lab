import 'package:crewdog_cv_lab/services/sso_auth/get_token_sso.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import '../../../utils/constants.dart';

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

