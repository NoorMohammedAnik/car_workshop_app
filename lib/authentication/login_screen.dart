import 'dart:convert';
import 'dart:developer';

import 'package:car_workshop_app/authentication/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../admin/admin_homepage.dart';
import '../api/api_connection.dart';
import '../mechanic/mechanic_homepage.dart';
import '../model/user.dart';
import '../widgets/progress_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //Form controllers for email and password
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  //Storage for user information
  GetStorage box = GetStorage();
  String get userEmail => box.read("email") ?? "";

  //form state variables
  final GlobalKey<FormState> loginFormKey = GlobalKey();

  //functions for obscuring and revealing password
  bool obscurePassword = true;

  //function for user login
  userLogin() async {
    //Check internet connection
    bool isConnected = await InternetConnectionChecker().hasConnection;

    if (isConnected) {
      if (mounted) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext c) {
              return const ProgressDialog();
            });
      }

      try {
        //calling the API to authenticate user
        var res = await http.post(
          Uri.parse(API.userLogin),
          body: {
            "user_email": emailController.text.trim(),
            "user_password": passwordController.text.trim(),
          },
        );

        if (res.statusCode == 200) {
          var responseData = jsonDecode(res.body);
          if (responseData['success'] == true) {
            MyUser userInfo = MyUser.fromJson(responseData["userData"]);

            String userRole = userInfo.userRole.toString();

            //user info saved in local storage
            box.write("userId", userInfo.userId.toString());
            box.write("email", emailController.text.trim());

            if (userRole == 'Admin') {

              Get.offAll(() => const AdminHomepage());
            } else {
              Get.offAll(() =>  MechanicHomepage());
            }
          } else {
            Fluttertoast.showToast(msg: "Wrong email or password");

            if (mounted) {
              Navigator.pop(context);
            }
          }
        }
      } catch (e) {
        log(e.toString());
      }
    } else {
      Fluttertoast.showToast(msg: "No network connection");
    }
  }

  @override
  void initState() {

    super.initState();

    //Setting up text field controllers text
    emailController.text = userEmail;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(

        backgroundColor: Colors.redAccent,
        title: const Text(
          "Login",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Form(
        key: loginFormKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const SizedBox(height: 35),
              Image.asset("assets/images/logo.png",
                  height: 200,
                  width: MediaQuery.sizeOf(context).width / 2,
                  fit: BoxFit.fitWidth),
              const SizedBox(height: 10),
              Text(
                "Login to your account",
                style:
                    GoogleFonts.acme(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Your email address",
                  hintText: "Your email address",
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (String? value) {
                  if (value == null ||
                      !value.contains("@") ||
                      !value.contains(".")) {
                    return "Please enter a valid email address";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                obscureText: obscurePassword,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  labelText: "Your password",
                  hintText: "Your password",
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                      icon: obscurePassword
                          ? const Icon(Icons.visibility_outlined)
                          : const Icon(Icons.visibility_off_outlined)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter password";
                  } else if (value.length < 4) {
                    return "Password should be at least 4 characters long";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 60),
              Column(
                children: [
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        if (loginFormKey.currentState!.validate()) {
                          loginFormKey.currentState!.save();

                          // call login function
                          userLogin();
                        }
                      },
                      child: Text(
                        "Login",
                        style: GoogleFonts.acme(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          loginFormKey.currentState?.reset();


                          Get.to(()=> const RegistrationScreen());

                        },
                        child: const Text(
                          "Register now",
                          style: TextStyle(color: Colors.redAccent,fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
