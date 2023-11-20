import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram/firebase_options.dart';
import 'package:instagram/screens/signIn.dart';
import 'package:instagram/provider/userData.dart';
import 'package:instagram/responsive/mobileScreen.dart';
import 'package:instagram/responsive/responsive.dart';
import 'package:instagram/responsive/webScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:instagram/shared/toastMessag.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDOhzrZ9fwnNe8IeXXPMCNDaijb0jez0eo",
        authDomain: "instagram-test-6e985.firebaseapp.com",
        projectId: "instagram-test-6e985",
        storageBucket: "instagram-test-6e985.appspot.com",
        messagingSenderId: "970057154500",
        appId: "1:970057154500:web:90ca5360d9f5c22b8cae91",
      ),
    );
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return UserProvider(context: context);
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.white,
              ));
            } else if (snapshot.hasError) {
              return toastMessag(msg: "Something went wrong", myColor: Colors.red);
            } else if (snapshot.hasData) {
              return const Responsive(
                myWebScreen: WebScreen(),
                myMobileScreen: MobileScreen(),
              );
            } else {
              return const SignIn();
            }
          },
        ),
      ),
    );
  }
}
