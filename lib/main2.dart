// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
// import 'package:html_shim/html.dart' if (dart.library.html) 'dart:html' show window;
//
//
// class LoginApplePage extends StatefulWidget {
//   const LoginApplePage({Key? key}) : super(key: key);
//
//   @override
//   _LoginApplePageState createState() => _LoginApplePageState();
// }
//
// class _LoginApplePageState extends State<LoginApplePage> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Example app: Sign in with Apple'),
//         ),
//         body: Container(
//           padding: const EdgeInsets.all(10),
//           child: Center(
//             child: SignInWithAppleButton(
//               onPressed: () async {
//                 final credential = await SignInWithApple.getAppleIDCredential(
//                   scopes: [
//                     AppleIDAuthorizationScopes.email,
//                     AppleIDAuthorizationScopes.fullName,
//                   ],
//                   webAuthenticationOptions: WebAuthenticationOptions(
//                     clientId:
//                     'de.lunaone.flutter.signinwithappleexample.service',
//
//                     redirectUri:
//                     // For web your redirect URI needs to be the host of the "current page",
//                     // while for Android you will be using the API server that redirects back into your app via a deep link
//                     kIsWeb
//                         ? Uri.parse('https://${window.location.host}/')
//                         : Uri.parse(
//                       'https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple',
//                     ),
//                   ),
//                   // TODO: Remove these if you have no need for them
//                   nonce: 'example-nonce',
//                   state: 'example-state',
//                 );
//
//                 // ignore: avoid_print
//                 print(credential);
//
//                 // This is the endpoint that will convert an authorization code obtained
//                 // via Sign in with Apple into a session in your system
//                 final signInWithAppleEndpoint = Uri(
//                   scheme: 'https',
//                   host: 'flutter-sign-in-with-apple-example.glitch.me',
//                   path: '/sign_in_with_apple',
//                   queryParameters: <String, String>{
//                     'code': credential.authorizationCode,
//                     if (credential.givenName != null)
//                       'firstName': credential.givenName!,
//                     if (credential.familyName != null)
//                       'lastName': credential.familyName!,
//                     'useBundleId':
//                     !kIsWeb && (Platform.isIOS || Platform.isMacOS)
//                         ? 'true'
//                         : 'false',
//                     if (credential.state != null) 'state': credential.state!,
//                   },
//                 );
//
//                 final session = await http.Client().post(
//                   signInWithAppleEndpoint,
//                 );
//
//
//                 print(session);
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }