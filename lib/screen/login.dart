<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectapp/constant/colours.dart';
import 'package:projectapp/theme/app_colors.dart';
import 'package:projectapp/core/network/dio_client.dart';
import 'package:projectapp/core/session/auth_session_storage.dart';
import 'package:projectapp/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:projectapp/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:projectapp/features/auth/domain/usecases/login_user.dart';
import 'package:projectapp/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:projectapp/screen/navbar.dart';
import 'package:projectapp/screen/signup.dart';
import 'package:projectapp/screen/otp_verification.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final dio = DioClient.create();
        final remote = AuthRemoteDataSource(dio);
        final repository = AuthRepositoryImpl(remote);
        return LoginBloc(loginUser: LoginUser(repository));
      },
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final TextEditingController email = TextEditingController();
  final TextEditingController pass = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    email.dispose();
    pass.dispose();
    super.dispose();
  }

  void _submit() {
    final emailText = email.text.trim();
    final passwordText = pass.text;
    if (emailText.isEmpty || passwordText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Please enter both email and password.',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      return;
    }
    context.read<LoginBloc>().add(
          LoginSubmitted(email: emailText, password: passwordText),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.isSuccess && state.session != null) {
          AuthSessionStorage.instance.save(state.session!);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: btn,
              content: Text(
                state.session?.message ?? 'You are logged in now...',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
          final emailText = email.text.trim();
          email.clear();
          pass.clear();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => OtpVerification(email: emailText)),
          );
        } else if (state.isFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                state.errorMessage ?? 'Login failed. Please try again.',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.bg,
        body: SafeArea(
            child: SingleChildScrollView(
          child: Container(
            color: AppColors.bg,
            child: Container(
              decoration: const BoxDecoration(
                  color: AppColors.bg,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30))),
              margin: const EdgeInsets.only(top: 60),
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30, right: 30, top: 20),
                    child: Center(
                        child: Image.asset(
                      'assets/image/logo.png',
                      width: 260,
                    )),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                    width: 315,
                    child: TextField(
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: AppColors.text),
                      decoration: InputDecoration(
                        hintText: "Email",
                        hintStyle: const TextStyle(color: AppColors.muted),
                        fillColor: AppColors.panel,
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.accent,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 315,
                    child: TextField(
                      controller: pass,
                      obscureText: _obscurePassword,
                      style: const TextStyle(color: AppColors.text),
                      decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: const TextStyle(color: AppColors.muted),
                        fillColor: AppColors.panel,
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.muted,
                          ),
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.accent,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 158, top: 10),
                    child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Forgot your password?",
                          style: TextStyle(
                              fontFamily: 'pppinsbold',
                              fontSize: 12,
                              color: AppColors.muted),
                        )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  BlocBuilder<LoginBloc, LoginState>(
                    buildWhen: (prev, curr) => prev.status != curr.status,
                    builder: (context, state) {
                      final loading = state.isLoading;
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accent.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: loading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(315, 54),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: loading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : const Text(
                                  "Sign in",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(color: AppColors.muted, fontSize: 13),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Signup()));
                          },
                          child: const Text(
                            "Create new account",
                            style: TextStyle(
                                fontFamily: 'pppinsbold',
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.accent),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: false,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: TextButton(
                              onPressed: () {},
                              child: const Text(
                                "Or continue with",
                                style: TextStyle(fontSize: 13, color: btntxt),
                              )),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.facebook,
                                  color: Colors.blue,
                                  size: 35,
                                ),
                                onPressed: () {},
                              ),
                            ),
                            const SizedBox(width: 20),
                            Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Image.asset(
                                  'assets/image/google.png',
                                  width: 50,
                                  height: 50,
                                )),
                            const SizedBox(width: 20),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.apple,
                                  color: Colors.black,
                                  size: 35,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )),
      ),
    );
=======
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projectapp/constant/colours.dart';
import 'package:projectapp/screen/home.dart';
import 'package:projectapp/screen/nabbar.dart';
import 'package:projectapp/screen/signup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

TextEditingController email = TextEditingController();
TextEditingController pass = TextEditingController();

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
                    color: btntxt,
                    child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30), topLeft: Radius.circular(30))),
            margin: EdgeInsets.only(top: 100),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(text: 'GBNX ', style: TextStyle(color: btn)),
                          TextSpan(text: 'Digital App', style: TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Text(
                    "Welcome back you’ve been missed!",
                    style: TextStyle(fontSize: 18, fontFamily: 'pppins'),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: 315,
                  child: TextField(
                    controller: email,
                    decoration: InputDecoration(
                      hintText: " Email",
                      hintStyle: TextStyle(color: Colors.grey),
                      fillColor: Colors.grey[100],
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: btn, // Border color when focused
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: 315,
                  child: TextField(
                    controller: pass,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: " Password",
                      hintStyle: TextStyle(color: Colors.grey),
                      fillColor: Colors.grey[100],
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: btn, // Border color when focused
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 158, top: 10),
                  child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "Forgot your password?",
                        style: TextStyle(
                            fontFamily: 'pppinsbold',
                            fontSize: 12,
                            color: btntxt),
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue, // Button color
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFd6deff),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: const Offset(0, 3), // Shadow position
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigator.push(
                      //     context, MaterialPageRoute(builder: (context) => Home()));
                      firbaselogin();
                    },
                    child: Text(
                      "Sign in",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: btn,
                      minimumSize: Size(300, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Signup()));
                      },
                      child: Text(
                        "Create new account",
                        style: TextStyle(
                            fontFamily: 'pppinsbold',
                            fontSize: 13,
                            color: Color(0xFF4a4a4a)),
                      )),
                ),
              ],
            ),
                    ),
                  ),
          )),
    );
  }

  void firbaselogin() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text,
        password: pass.text,
      );
      final snackBar = SnackBar(
        backgroundColor: btn,
        content: const Text(
          'Your are login now...',
          style: TextStyle(color: Colors.white),
        ),
        action: SnackBarAction(
          label: '',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      email.clear();
      pass.clear();
      Navigator.push(context, MaterialPageRoute(builder: (context) => Nabbar()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        final snackBar = SnackBar(
          backgroundColor: Colors.red,
          content: const Text(
            'No user found for that email.',
            style: TextStyle(color: Colors.white),
          ),
          action: SnackBarAction(
            label: '',
            onPressed: () {},
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (e.code == 'wrong-password') {
        final snackBar = SnackBar(
          backgroundColor: Colors.lightBlueAccent,
          content: const Text(
            'Wrong password provided for that user.',
            style: TextStyle(color: Colors.black),
          ),
          action: SnackBarAction(
            label: '',
            onPressed: () {},
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
>>>>>>> dad7861bff05e73639116e2d7911d08ec2d778c2
  }
}
