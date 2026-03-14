import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:school_management_system/public/config/user_information.dart';
import 'package:school_management_system/public/login/dividerforparent.dart';
import 'package:school_management_system/public/login/dividerwithtext.dart';
import 'package:school_management_system/public/utils/constant.dart';
import 'package:school_management_system/public/utils/font_style.dart';
import 'package:school_management_system/public/widgets/circuled_button.dart';
import 'package:school_management_system/public/widgets/custom_button.dart';
import 'package:school_management_system/public/widgets/custom_formfield.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_management_system/public/widgets/parent_dialog.dart';
import 'package:school_management_system/student/view/Home/messaging.dart';
import '../utils/util.dart';
import '../widgets/custom_dialog.dart';
import '../widgets/rounded_button.dart';
import '../widgets/send_email_container.dart';
import 'login_label.dart';
import 'package:school_management_system/services/api_service.dart';
import 'package:dio/dio.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPassword = true;
  bool student = false;
  bool teacher = false;
  bool admin = false;
  bool parent = false;
  var stcolor = gradientColor2,
      adcolor = gradientColor2,
      tecolor = gradientColor2,
      parcolor = gradientColor2;
  var sticotextcolor = gray,
      adicotextcolor = gray,
      teicotextcolor = gray,
      paricotextcolor = gray;

  GoogleSignIn _googleSignIn = GoogleSignIn();
  GetStorage storage = GetStorage();
  String txt2 = "";
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool _isGoogleLoading = false;
  bool _isLoading = false;

  initialMessage() async {
    var message = await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      Navigator.of(context).pushNamed("Studenthome");
    }
  }

  @override
  void initState() {
    super.initState();
    teacher = true;
    tecolor = gradientColor;
    teicotextcolor = Colors.white;
    initialMessage();
    fbm.getToken().then((token) {
      UserInformation.Token = token;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  // ─── LARAVEL API LOGIN ───────────────────────────
  void Login() async {
    if (parent) return; // parent Google se login karta hai

    if (!formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await ApiService.dio.post(
        '/login',
        data: {
          'email': _emailController.text.trim(),
          'password': _passwordController.text.trim(),
          'device_name': 'flutter-app',
        },
      );

      if (response.data['success'] == true) {
        final token = response.data['token'];
        final userData = response.data['user'];
        final role = userData['role'] ?? '';

        // Token aur data save karo
        ApiService.saveToken(token);
        storage.write('uid', userData['id'].toString());
        storage.write('api_token', token);
        storage.write('role', role);
        storage.write('user', userData);

        // UserInformation update karo
        UserInformation.User_uId = userData['id'].toString();
        UserInformation.apiToken = token;
        UserInformation.role = role;
        UserInformation.email = userData['email'] ?? '';
        UserInformation.fullname = userData['name'] ?? '';

        // Role check karo aur navigate karo
        // Role check karo aur navigate karo
        switch (role) {
          case 'admin':
            Get.offAllNamed('/teahome');
            break;
          case 'teacher':
            Get.offAllNamed('/teahome');
            break;
          case 'student':
            Get.offAllNamed('/sthome');
            break;
          case 'parent':
            Get.offAllNamed('/parhome');
            break;
          default:
            showSnackBar('Unknown role: $role', context);
        }
      } else {
        showSnackBar(response.data['message'] ?? 'Login failed', context);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        showSnackBar('Invalid email or password', context);
      } else {
        showSnackBar('Server error. Laravel server check karo.', context);
      }
    } catch (e) {
      showSnackBar('Error: $e', context);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void setstring() {
    _passwordController.text = txt2;
  }

  void google() async {
    setState(() => _isGoogleLoading = true);
    // Google login abhi bhi Firebase se — baad mein update karenge
    setState(() => _isGoogleLoading = false);
    showSnackBar('Google login coming soon', context);
  }

  @override
  Widget build(BuildContext context) {
    Pics pics = Pics();
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          width: size.width,
          height: size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/login-background-squares.png"),
                fit: BoxFit.cover),
          ),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 72.h),
                    const Loginlabel(),
                    SizedBox(height: size.height / 10),
                    Text("I am", style: sfBoldStyle(fontSize: 24, color: gray)),
                    SizedBox(height: 32.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 28.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          circuledButton(
                              pic: pics.teacherGreyPic,
                              text: 'teacher',
                              background: tecolor,
                              icontextcolor: teicotextcolor,
                              press: () {
                                setState(() {
                                  adcolor = gradientColor2;
                                  tecolor = gradientColor;
                                  parcolor = gradientColor2;
                                  stcolor = gradientColor2;
                                  adicotextcolor = gray;
                                  teicotextcolor = Colors.white;
                                  sticotextcolor = gray;
                                  paricotextcolor = gray;
                                  admin = false;
                                  teacher = true;
                                  student = false;
                                  parent = false;
                                });
                              }),
                          circuledButton(
                              pic: pics.studentGreyPic,
                              text: 'student',
                              background: stcolor,
                              icontextcolor: sticotextcolor,
                              press: () {
                                setState(() {
                                  adcolor = gradientColor2;
                                  tecolor = gradientColor2;
                                  parcolor = gradientColor2;
                                  stcolor = gradientColor;
                                  adicotextcolor = gray;
                                  teicotextcolor = gray;
                                  sticotextcolor = Colors.white;
                                  paricotextcolor = gray;
                                  admin = false;
                                  teacher = false;
                                  student = true;
                                  parent = false;
                                });
                              }),
                          circuledButton(
                              pic: pics.parentGreyPic,
                              text: 'parent',
                              background: parcolor,
                              icontextcolor: paricotextcolor,
                              press: () {
                                setState(() {
                                  adcolor = gradientColor2;
                                  tecolor = gradientColor2;
                                  parcolor = gradientColor;
                                  stcolor = gradientColor2;
                                  adicotextcolor = gray;
                                  teicotextcolor = gray;
                                  sticotextcolor = gray;
                                  paricotextcolor = Colors.white;
                                  admin = false;
                                  teacher = false;
                                  student = false;
                                  parent = true;
                                });
                              }),
                        ],
                      ),
                    ),
                    SizedBox(height: 32.h),
                    parent == false
                        ? Form(
                            key: formKey,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 40.w),
                              child: Column(children: [
                                customFormField(
                                  controller: _emailController,
                                  label: 'Email',
                                  prefix: Icons.email,
                                  onChange: (String val) {},
                                  type: TextInputType.emailAddress,
                                  validate: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'email must not be empty';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 24.h),
                                customFormField(
                                  controller: _passwordController,
                                  label: 'Password',
                                  prefix: Icons.lock,
                                  onChange: (String val) {
                                    txt2 = _passwordController.text;
                                  },
                                  suffix: isPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  isPassword: isPassword,
                                  suffixPressed: () {
                                    setState(() {
                                      isPassword = !isPassword;
                                      setstring();
                                    });
                                  },
                                  type: TextInputType.visiblePassword,
                                  validate: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'password is too short';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 20.h),
                              ]),
                            ),
                          )
                        : Column(
                            children: [
                              SizedBox(height: 32.h),
                              Text(
                                "Choose the same account given to School! ",
                                style:
                                    sfRegularStyle(fontSize: 12, color: blue),
                              ),
                              SizedBox(height: 20.h),
                              _isGoogleLoading
                                  ? CircularProgressIndicator(
                                      color: primaryColor)
                                  : ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.black,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 24, vertical: 12),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                      ),
                                      onPressed: google,
                                      icon: Icon(Icons.login,
                                          color: primaryColor),
                                      label: Text('Sign in with Google'),
                                    ),
                              SizedBox(height: 20.h),
                              const DividerParent(text: "Update your account"),
                              SizedBox(height: 20.h),
                              SendEmail(
                                press: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CustomDialog();
                                      });
                                },
                              ),
                            ],
                          ),
                    if (parent == false) SizedBox(height: 32.h),
                    if (parent == false)
                      _isLoading
                          ? CircularProgressIndicator(color: primaryColor)
                          : CustomButton(press: Login),
                    if (parent == false) SizedBox(height: 32.h),
                    if (teacher == true)
                      Column(
                        children: <Widget>[
                          DividerText(text: "or"),
                          SizedBox(height: 32.h),
                          _isGoogleLoading
                              ? CircularProgressIndicator(color: primaryColor)
                              : ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                  ),
                                  onPressed: google,
                                  icon: Icon(Icons.login, color: primaryColor),
                                  label: Text('Sign in with Google'),
                                ),
                        ],
                      )
                    else
                      const SizedBox(height: 1.0),
                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
