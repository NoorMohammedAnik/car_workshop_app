import 'dart:convert';
import 'dart:developer';

import 'package:car_workshop_app/authentication/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../api/api_connection.dart';
import '../widgets/progress_dialog.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  // //Form controllers
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var userRoleController = TextEditingController();

  // Form state variables
  final GlobalKey<FormState> registrationFormKey = GlobalKey();

  // State variables for form validation
  bool obscurePassword = true;

  // This function opens a dialog for selecting the user type
  Future<void> _selectUserType() async {
    String? selectedType = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select User Role'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'Admin');
              },
              child: const Text('Admin'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'Mechanic');
              },
              child: const Text('Mechanic'),
            ),
          ],
        );
      },
    );

    if (selectedType != null) {
      setState(() {
        userRoleController.text = selectedType;
      });
    }
  }

  //function for user sign up
  userRegistration() async {
    //check internet connection
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

        //api call to register user
        var res = await http.post(
          Uri.parse(API.userSignup),
          body: {
            "user_name": nameController.text.trim(),
            "user_email": emailController.text.trim(),
            "user_password": passwordController.text.trim(),
            "user_role": userRoleController.text.trim(),
          },
        );

        if (res.statusCode == 200) {
          var responseData = jsonDecode(res.body);
          if (responseData['success'] == true) {
            Get.offAll(() => const LoginScreen());
            Fluttertoast.showToast(msg: "Registration Successful");
          }

        else  if (responseData['success'] == "exists") {

            Fluttertoast.showToast(msg: "User already exists!");
            Get.back();
          }

          else {
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white
        ),
        backgroundColor: Colors.redAccent,
        title: const Text(
          'Registration',
          style: TextStyle(color: Colors.white
        ),),
      ),

      body: Form(
        key: registrationFormKey,
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
                "User Registration",
                style:
                GoogleFonts.acme(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: nameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Your name",
                  hintText: "Your name",
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your name";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 10),
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
              const SizedBox(height: 10),
              TextFormField(
                controller: userRoleController,
                readOnly: true,
                onTap: () {
                  _selectUserType();
                },
                decoration: InputDecoration(
                  labelText: "Select user role",
                  hintText: "Select user role",
                  prefixIcon: const Icon(Icons.person_add),
                  suffixIcon: const Icon(Icons.arrow_drop_down),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please select user role";
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


                        if (registrationFormKey.currentState!.validate()) {
                          registrationFormKey.currentState!.save();

                          // call signup function
                          userRegistration();
                        }
                      },
                      child: Text(
                        "Signup",
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
                      const Text("Already have an account?"),
                      TextButton(
                        onPressed: () {
                          registrationFormKey.currentState?.reset();
                          Get.offAll(const LoginScreen());
                        },
                        child: const Text(
                          "Login now",
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
