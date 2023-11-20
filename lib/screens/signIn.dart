


import 'package:flutter/material.dart';
import 'package:instagram/constant/colors.dart';
import 'package:instagram/firebase_services/auth.dart';
import 'package:instagram/screens/register.dart';
import 'package:instagram/shared/decrationOfTextFeild.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool hiddinPassword = true;
  final password = TextEditingController();
  final emailAddress = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor:
          screenWidth >= 600 ? webBackgroundColor : mobileBackgroundColorSR,
      // appBar: AppBar(
      //   backgroundColor: const Color.fromARGB(255, 48, 48, 48),
      //   title: const Text(
      //     "Sign in",
      //     style: TextStyle(color: Colors.white),
      //   ),
      // ),

      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(22),
            width: screenWidth >= 600 ? screenWidth / 2 : double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenWidth >= 600 ? 30 : 150),
                TextFormField(
                  controller: emailAddress,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.black),
                  obscureText: false,
                  decoration: decorationTextfield.copyWith(
                    hintText: "Enter Your Email : ",
                    hintStyle: TextStyle(
                        color: screenWidth >= 600
                            ? webBackgroundColor
                            : mobileBackgroundColorSR),
                    suffix: Icon(Icons.email,
                        color: screenWidth >= 600
                            ? webBackgroundColor
                            : mobileBackgroundColorSR),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  // autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: password,
                  keyboardType: TextInputType.text,
                  obscureText: hiddinPassword,
                  style: const TextStyle(color: Colors.black),
                  decoration: decorationTextfield.copyWith(
                    fillColor: Colors.white,
                    hintText: "Enter Your Password : ",
                    hintStyle: TextStyle(
                        color: screenWidth >= 600
                            ? webBackgroundColor
                            : mobileBackgroundColorSR),
                    suffix: IconButton(
                      onPressed: () {
                        setState(
                          () {
                            hiddinPassword = !hiddinPassword;
                          },
                        );
                      },
                      icon: hiddinPassword
                          ? Icon(Icons.visibility,
                              color: screenWidth >= 600
                                  ? webBackgroundColor
                                  : mobileBackgroundColorSR)
                          : Icon(Icons.visibility_off,
                              color: screenWidth >= 600
                                  ? webBackgroundColor
                                  : mobileBackgroundColorSR),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "forgot password",
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    AuthClass(context: context)
                        .signIn(emailAddress: emailAddress, password: password);
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 0, 0, 0))),
                  child: const Text(
                    "sign in",
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "if you don't have acount ",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: ((context) => const Register()),
                          ),
                        );
                      },
                      child: const Text(
                        "register",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
