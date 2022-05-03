import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:login_google/main2.dart';
import 'package:login_google/user.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

void main() {
  runApp(const MyApp());
}
final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email'
    ]
);
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  GoogleSignInAccount? _currentUser;

  bool loggedIn = false;

  AccessToken? _accessToken;
  UserModel? currentUser;
  @override
  void initState() {
    _googleSignIn.onCurrentUserChanged.listen((account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            _buildWidget(),
            _buildWidgetFb()
          ],
        ),

      ),
    );
  }
  facebookLogin() async {
    print("FaceBook");
    final result =
    await FacebookAuth.i.login(permissions: ['public_profile', 'email']);
    if (result.status == LoginStatus.success) {
      final userData = await FacebookAuth.i.getUserData();
      print(userData);
    }
  }

  Widget _buildWidget(){
    GoogleSignInAccount? user = _currentUser;
    if(user != null){
      return Padding(
        padding: const EdgeInsets.fromLTRB(2, 12, 2, 12),
        child: Column(
          children: [
            ListTile(
              leading: GoogleUserCircleAvatar(identity: user),
              title:  Text(user.displayName ?? '', style: TextStyle(fontSize: 22),),
              subtitle: Text(user.email, style: TextStyle(fontSize: 22)),
            ),
            const SizedBox(height: 20,),
            const Text(
              'Signed in successfully',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10,),
            ElevatedButton(
                onPressed: signOutGoogle,
                child: const Text('Sign out')
            )
          ],
        ),
      );
    }else{
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const SizedBox(height: 20,),
            const Text(
              'You are not signed in',
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 10,),
            ElevatedButton(
                onPressed: signInGoogle,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Sign in', style: TextStyle(fontSize: 30)),
                )
            ),
         SignInWithAppleButton(
          onPressed: () async {

            final credential = await SignInWithApple.getAppleIDCredential(
              scopes: [
                AppleIDAuthorizationScopes.email,
                AppleIDAuthorizationScopes.fullName,
              ],
                webAuthenticationOptions: WebAuthenticationOptions(
                    clientId: 'jp.oyster.mobile.service',
                    redirectUri: Uri.parse('https://um9kvdfvh6.execute-api.ap-northeast-1.amazonaws.com/callbacks/sign_in_with_apple'))
            );
            final Map<String, dynamic> decodedIdentityToken =
             JwtDecoder.decode(credential.identityToken ?? '');
           String id= decodedIdentityToken['sub'] as String? ?? '';
            print("id $id");


            // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
            // after they have been validated with Apple (see `Integration` section for more information on how to do this)
          },
        ),
            ElevatedButton(
                onPressed: facebookLogin,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Sign in facebook', style: TextStyle(fontSize: 30)),
                )
            ),
          ],
        ),
      );
    }
  }
  Widget _buildWidgetFb() {
    UserModel? user = currentUser;
    if (user != null) {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                radius: user.pictureModel!.width! / 6,
                backgroundImage: NetworkImage(user.pictureModel!.url!),
              ),
              title: Text(user.name!),
              subtitle: Text(user.email!),
            ),
            const SizedBox(height: 20,),
            const Text(
              'Signed in successfully',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10,),
            ElevatedButton(
                onPressed: signOutFB,
                child: const Text('Sign out')
            )
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const SizedBox(height: 20,),
            const Text(
              'You are not signed in',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10,),
            ElevatedButton(
                onPressed: signInFB,
                child: const Text('Sign in')
            ),
          ],
        ),
      );
    }
  }

  Future<void> signInFB() async {
    final LoginResult result = await FacebookAuth.i.login();

    if(result.status == LoginStatus.success){
      _accessToken = result.accessToken;

      final data = await FacebookAuth.i.getUserData();
      UserModel model = UserModel.fromJson(data);

      currentUser = model;
      setState(() {

      });
    }
  }

  Future<void> signOutFB() async {
    await FacebookAuth.i.logOut();
    currentUser = null;
    _accessToken = null;
    setState(() {

    });
  }
}
  void signOutGoogle(){
    _googleSignIn.disconnect();
  }

  Future<void> signInGoogle() async {
    try{
      await _googleSignIn.signIn();
      final result2 = await _googleSignIn.signIn();
      final String _googleUserEmail = result2?.email ?? '';
      final String _googleUserName = result2?.displayName ?? '';
      final ggAuth = await result2?.authentication;
      final idTokenSub = 'ggl_sns_$_googleUserEmail';
      final accessToken = ggAuth?.accessToken;
      print(accessToken);
    }catch (e){
      print('Error signing in $e');
    }
  }

