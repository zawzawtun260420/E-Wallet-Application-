<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectapp/constant/colours.dart';
import 'package:projectapp/theme/app_colors.dart';
import 'package:projectapp/core/network/dio_client.dart';
import 'package:projectapp/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:projectapp/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:projectapp/features/auth/domain/usecases/register_user.dart';
import 'package:projectapp/features/auth/presentation/bloc/register/register_bloc.dart';
import 'package:projectapp/screen/login.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final dio = DioClient.create();
        final remote = AuthRemoteDataSource(dio);
        final repository = AuthRepositoryImpl(remote);
        return RegisterBloc(registerUser: RegisterUser(repository));
      },
      child: const _SignupView(),
    );
  }
}

class _SignupView extends StatefulWidget {
  const _SignupView();

  @override
  State<_SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<_SignupView> {
  final TextEditingController firstName = TextEditingController();
  final TextEditingController familyName = TextEditingController();
  final TextEditingController emailsig = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController passsig = TextEditingController();
  final TextEditingController cpass = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    firstName.dispose();
    familyName.dispose();
    emailsig.dispose();
    phone.dispose();
    passsig.dispose();
    cpass.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(message, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  void _submit() {
    final firstNameText = firstName.text.trim();
    final familyNameText = familyName.text.trim();
    final emailText = emailsig.text.trim();
    final phoneText = phone.text.trim();
    final passwordText = passsig.text;
    final confirmText = cpass.text;

    if (firstNameText.isEmpty ||
        familyNameText.isEmpty ||
        emailText.isEmpty ||
        phoneText.isEmpty ||
        passwordText.isEmpty ||
        confirmText.isEmpty) {
      _showError('Please fill in all fields.');
      return;
    }
    if (passwordText != confirmText) {
      _showError('Passwords do not match.');
      return;
    }

    context.read<RegisterBloc>().add(
          RegisterSubmitted(
            firstName: firstNameText,
            familyName: familyNameText,
            email: emailText,
            phone1: phoneText,
            password: passwordText,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: btn,
              content: Text(
                state.user?.message ?? 'User successfully added.',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
          firstName.clear();
          familyName.clear();
          emailsig.clear();
          phone.clear();
          passsig.clear();
          cpass.clear();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const Login()),
          );
        } else if (state.isFailure) {
          _showError(state.errorMessage ?? 'Sign up failed. Please try again.');
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
              margin: const EdgeInsets.only(top: 40),
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30, right: 30, top: 20),
                    child: Center(
                        child: Image.asset(
                      'assets/image/logo.png',
                      width: 200,
                    )),
                  ),
                  const SizedBox(height: 30),
                  _buildField(
                    controller: firstName,
                    hint: "First Name",
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 15),
                  _buildField(
                    controller: familyName,
                    hint: "Last Name",
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 15),
                  _buildField(
                    controller: emailsig,
                    hint: "Email",
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 15),
                  _buildField(
                    controller: phone,
                    hint: "Phone",
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 15),
                  _buildField(
                    controller: passsig,
                    hint: "Password",
                    obscureText: _obscurePassword,
                    onToggleObscure: () => setState(
                      () => _obscurePassword = !_obscurePassword,
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 15),
                  _buildField(
                    controller: cpass,
                    hint: "Confirm Password",
                    obscureText: _obscureConfirm,
                    onToggleObscure: () => setState(
                      () => _obscureConfirm = !_obscureConfirm,
                    ),
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 30),
                  BlocBuilder<RegisterBloc, RegisterState>(
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
                                  "Sign up",
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
                          "Already have an account? ",
                          style: TextStyle(color: AppColors.muted, fontSize: 13),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Login()));
                          },
                          child: const Text(
                            "Sign in",
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
                                style: TextStyle(
                                    fontFamily: 'pppinsbold',
                                    fontSize: 13,
                                    color: btntxt),
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
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    bool obscureText = false,
    VoidCallback? onToggleObscure,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
  }) {
    return SizedBox(
      width: 315,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        style: const TextStyle(color: AppColors.text),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.muted),
          fillColor: AppColors.panel,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          suffixIcon: onToggleObscure == null
              ? null
              : IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.muted,
                  ),
                  onPressed: onToggleObscure,
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
    );
  }
}
=======
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:projectapp/constant/colours.dart';
import 'package:projectapp/screen/login.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

TextEditingController emailsig = TextEditingController();
TextEditingController passsig = TextEditingController();
TextEditingController cpass = TextEditingController();



class _SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Background,
      body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              color: btntxt,
              child: Container(
                decoration: BoxDecoration(
                    color: Background,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30), topLeft: Radius.circular(30))),
                margin: EdgeInsets.only(top: 80),
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
                      padding: const EdgeInsets.only(left: 40, right: 40),
                      child: Text(
                        "Your Gateway to Smarter, Safer, and Seamless Banking!",
                        style: TextStyle(fontSize: 16, fontFamily: 'pppins', color: btntxt),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 315,
                      child: TextField(
                        controller: emailsig,
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
                      height: 20,
                    ),
                    Container(
                      width: 315,
                      child: TextField(
                        controller: passsig,
            
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
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 315,
                      child: TextField(
                        controller: cpass,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: " Confirm Password",
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
                          //     context, MaterialPageRoute(builder: (context) => Login()));
                          createUserWithEmailAndPassword();
                        },
                        child: Text(
                          "Sign up",
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
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) => Login()));
                          },
                          child: Text(
                            "Already have an account",
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

  void createUserWithEmailAndPassword() async{
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailsig.text,
        password: passsig.text,
      );
      final snackBar = SnackBar(
        backgroundColor: btn,
        content: const Text('User sucessfully added....', style: TextStyle(color: Colors.white),),
        action: SnackBarAction(
          label: '',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      emailsig.clear();
      passsig.clear();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Login()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        final snackBar = SnackBar(
          backgroundColor: Colors.red,
          content: const Text('The password provided is too weak.', style: TextStyle(color: Colors.white),),
          action: SnackBarAction(
            label: '',
            onPressed: () {
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (e.code == 'email-already-in-use') {
        final snackBar = SnackBar(
          backgroundColor: Colors.lightBlueAccent,
          content: const Text('The account already exists for that email.', style: TextStyle(color: Colors.black),),
          action: SnackBarAction(
            label: '',
            onPressed: () {
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      print(e);
    }
  }
}
>>>>>>> dad7861bff05e73639116e2d7911d08ec2d778c2
