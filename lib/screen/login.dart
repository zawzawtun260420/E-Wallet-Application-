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
import 'package:projectapp/screen/signup.dart';
import 'package:projectapp/screen/otp_verification.dart';

// ---------------------------------------------------------------------------
// Design tokens — kept in sync with wallet_page.dart, settings.dart, home.dart
// ---------------------------------------------------------------------------
class _T {
  static const double s1 = 4;
  static const double s2 = 8;
  static const double s3 = 12;
  static const double s4 = 16;
  static const double s5 = 20;
  static const double s6 = 24;
  static const double s7 = 32;

  static const double rSm = 8;
  static const double rMd = 12;
  static const double rLg = 16;

  static const double bpTablet = 600;
  static const double bpDesktop = 840;

  // Max form width on larger screens — the form shouldn't stretch endlessly
  static const double formMaxWidth = 400;

  static double pagePadding(double width) {
    if (width < bpTablet) return s5;       // 20 on mobile (a bit roomier for auth)
    if (width < bpDesktop) return s6;      // 24 on tablet
    return s7;                              // 32 on desktop
  }
}

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
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _submit() {
    // Hide keyboard before submitting
    FocusScope.of(context).unfocus();

    final emailText = _email.text.trim();
    final passwordText = _password.text;
    if (emailText.isEmpty || passwordText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
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
    final width = MediaQuery.sizeOf(context).width;
    final pad = _T.pagePadding(width);
    final isMobile = width < _T.bpTablet;

    return BlocListener<LoginBloc, LoginState>(
      listener: _onLoginStateChange,
      child: Scaffold(
        backgroundColor: AppColors.bg,
        // resizeToAvoidBottomInset is true by default; with the scroll view below,
        // the form will lift correctly when the keyboard opens.
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Ensure the column can fill the viewport at minimum so vertical
              // centering works on tall phones, but still scrolls on short ones.
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: _T.formMaxWidth,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: pad,
                            vertical: _T.s5,
                          ),
                          child: _buildForm(isMobile),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------------
  // Form content
  // ------------------------------------------------------------------
  Widget _buildForm(bool isMobile) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: isMobile ? _T.s4 : _T.s7),
        // Logo — scales but capped so it doesn't dominate tablets
        Center(
          child: Image.asset(
            'assets/image/logo.png',
            width: isMobile ? 220 : 260,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: _T.s7),

        // Email field — full width within form constraints
        _LabeledField(
          controller: _email,
          hint: 'Email',
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.email, AutofillHints.username],
          onSubmitted: (_) => _passwordFocus.requestFocus(),
        ),
        SizedBox(height: _T.s4),

        // Password field with visibility toggle
        _LabeledField(
          controller: _password,
          focusNode: _passwordFocus,
          hint: 'Password',
          obscureText: _obscurePassword,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.password],
          onSubmitted: (_) => _submit(),
          suffix: IconButton(
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.muted,
              size: 20,
            ),
            onPressed: () => setState(
                  () => _obscurePassword = !_obscurePassword,
            ),
          ),
        ),

        // Forgot password — aligned right via Align, no hardcoded left padding
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: AppColors.muted,
              padding: EdgeInsets.symmetric(
                horizontal: _T.s2,
                vertical: _T.s1,
              ),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Forgot your password?',
              style: TextStyle(
                fontFamily: 'pppinsbold',
                fontSize: 12,
                color: AppColors.muted,
              ),
            ),
          ),
        ),
        SizedBox(height: _T.s4),

        // Sign in button — full width, fixed height for consistent tap target
        BlocBuilder<LoginBloc, LoginState>(
          buildWhen: (prev, curr) => prev.status != curr.status,
          builder: (context, state) {
            final loading = state.isLoading;
            return _SignInButton(loading: loading, onPressed: _submit);
          },
        ),
        SizedBox(height: _T.s5),

        // "Don't have an account?" — wraps gracefully on tiny screens
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text(
              "Don't have an account? ",
              style: TextStyle(color: AppColors.muted, fontSize: 13),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Signup()),
                );
              },
              child: const Text(
                'Create new account',
                style: TextStyle(
                  fontFamily: 'pppinsbold',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.accent,
                ),
              ),
            ),
          ],
        ),

        // Social login — hidden in original, kept hidden but with responsive layout
        // ready for when you enable it.
        Visibility(
          visible: false,
          child: Padding(
            padding: EdgeInsets.only(top: _T.s5),
            child: _SocialLoginSection(),
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------------
  // Bloc listener
  // ------------------------------------------------------------------
  void _onLoginStateChange(BuildContext context, LoginState state) {
    if (state.isSuccess && state.session != null) {
      AuthSessionStorage.instance.save(state.session!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: btn,
          behavior: SnackBarBehavior.floating,
          content: Text(
            state.session?.message ?? 'You are logged in now…',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
      final emailText = _email.text.trim();
      _email.clear();
      _password.clear();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OtpVerification(email: emailText),
        ),
      );
    } else if (state.isFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          content: Text(
            state.errorMessage ?? 'Login failed. Please try again.',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }
}

// ---------------------------------------------------------------------------
// Reusable input field — consistent styling across the form
// ---------------------------------------------------------------------------
class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.controller,
    required this.hint,
    this.focusNode,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.onSubmitted,
    this.suffix,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final String hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onSubmitted;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autofillHints: autofillHints,
      obscureText: obscureText,
      onSubmitted: onSubmitted,
      style: const TextStyle(color: AppColors.text, fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.muted),
        fillColor: AppColors.panel,
        filled: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: _T.s4,
          vertical: _T.s4 + 2,
        ),
        suffixIcon: suffix,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_T.rMd),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_T.rMd),
          borderSide: const BorderSide(
            color: AppColors.accent,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sign-in button — full width, loading state, consistent height
// ---------------------------------------------------------------------------
class _SignInButton extends StatelessWidget {
  const _SignInButton({required this.loading, required this.onPressed});

  final bool loading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_T.rMd),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.accent.withOpacity(0.6),
          minimumSize: const Size.fromHeight(54),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_T.rMd),
          ),
        ),
        child: loading
            ? const SizedBox(
          height: 22,
          width: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : const Text(
          'Sign in',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Social login section — kept here so it's ready when you enable it
// ---------------------------------------------------------------------------
class _SocialLoginSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Or continue with',
          style: TextStyle(fontSize: 13, color: AppColors.muted),
        ),
        SizedBox(height: _T.s3),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _socialButton(
              child: const Icon(Icons.facebook, color: Colors.blue, size: 28),
              onTap: () {},
            ),
            SizedBox(width: _T.s3),
            _socialButton(
              child: Image.asset(
                'assets/image/google.png',
                width: 28,
                height: 28,
              ),
              onTap: () {},
            ),
            SizedBox(width: _T.s3),
            _socialButton(
              child: const Icon(Icons.apple, color: Colors.black, size: 28),
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _socialButton({required Widget child, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(_T.rMd),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.panel,
          borderRadius: BorderRadius.circular(_T.rMd),
          border: Border.all(color: AppColors.border),
        ),
        child: Center(child: child),
      ),
    );
  }
}