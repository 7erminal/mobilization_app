import 'package:flutter/material.dart';
import 'package:mobilization_app/index.dart';
import 'package:provider/provider.dart';

// Keep your existing project imports here, e.g.:
// import 'package:yourapp/providers/auth_provider.dart';
// import 'package:yourapp/blocs/user_bloc.dart';
// import 'package:yourapp/services/api_fetcher.dart';
// import 'package:yourapp/screens/register.dart';
// import 'package:yourapp/screens/home_navigation.dart';
// import 'package:yourapp/widgets/loading.dart';
// import 'package:yourapp/widgets/dialogs.dart';
// import 'package:yourapp/constants/assets.dart';

/// Brand gradient — reuse this anywhere else in the app that needs the
/// same identity (buttons, headers, splash screen, etc).
class BrandGradient {
  static const Color mint = Color(0xFF0FDED7);
  static const Color teal = Color(0xFF19918E);
  static const Color deepTeal = Color(0xFF06A187);

  static const LinearGradient diagonal = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [deepTeal, teal, mint],
  );

  static const LinearGradient button = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [deepTeal, mint],
  );
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String id = "/login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _closeKeyboard() {
    FocusScope.of(context).unfocus();
  }

  Future<void> _handleLogin() async {
    _closeKeyboard();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    // ---- Original login logic, preserved -------------------------------
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userBloc = Provider.of<UserBloc>(context, listen: false);

    showLoading(context);
    var loginUser = await ApiFetcher.instance.login(
      username: usernameController.text,
      password: passwordController.text,
      clientId: "",
    );
    Navigator.pop(context);

    if (loginUser != null) {
      if (loginUser['StatusCode'] == true) {
        authProvider.login();

        showLoading(context);
        await ApiFetcher.instance.userDetails(
          phoneNumber: usernameController.text,
          clientId: usernameController.text,
        );
        Navigator.pop(context);

        ApiFetcher.instance.getCorporatives();

        DateTime now = DateTime.now();
        String fromDate =
            "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}T00:00:00.000Z";
        String toDate =
            "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}T23:59:59.000Z";
        ApiFetcher.instance.agentTransactions(
          agentCode: userBloc.user.agentCode?.agentCode ?? "",
          clientId: usernameController.text,
          fromDate: fromDate,
          toDate: toDate,
        );

        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          HomeNavigation.id,
          (route) => false,
        );
      } else {
        if (!mounted) return;
        informationDialogWithButton(
          context,
          "Login Failed",
          loginUser['StatusMessage'],
          BrandColors.danger,
          BrandColors.black,
          "Retry",
          () => Navigator.pop(context),
          false,
        );
      }
    }
    // ---------------------------------------------------------------------

    await Future.delayed(const Duration(milliseconds: 900)); // demo only
    if (!mounted) return;
    setState(() => _isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return GestureDetector(
      onTap: _closeKeyboard,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4FBFA),
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ---- Gradient hero header with logo ---------------------
              Container(
                padding: EdgeInsets.only(
                  top: topPadding + 36,
                  bottom: 48,
                  left: 24,
                  right: 24,
                ),
                decoration: const BoxDecoration(
                  gradient: BrandGradient.diagonal,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(36),
                    bottomRight: Radius.circular(36),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 84,
                      height: 84,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        Assets.brandLogoEnhanced,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.bolt_rounded,
                          color: BrandGradient.deepTeal,
                          size: 36,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Welcome back',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Sign in to continue to your account',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // ---- Form card, overlapping the header slightly ---------
              Transform.translate(
                offset: const Offset(0, -28),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: BrandGradient.teal.withOpacity(0.10),
                          blurRadius: 30,
                          offset: const Offset(0, 14),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _FieldLabel('Username'),
                          const SizedBox(height: 8),
                          _buildTextField(
                            controller: usernameController,
                            hintText: 'Enter your username',
                            prefixIcon: Icons.person_outline_rounded,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Username is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          _FieldLabel('Password'),
                          const SizedBox(height: 8),
                          _buildTextField(
                            controller: passwordController,
                            hintText: 'Enter your password',
                            prefixIcon: Icons.lock_outline_rounded,
                            keyboardType: TextInputType.visiblePassword,
                            isPassword: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 32),
                                tapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () {
                                // Navigator.pushNamed(context, ForgotPassword.id);
                              },
                              child: const Text(
                                'Forgot password?',
                                style: TextStyle(
                                  color: BrandGradient.deepTeal,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          _buildLoginButton(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              // ---- Footer sign-up row ----------------------------------
              Padding(
                padding: const EdgeInsets.only(bottom: 28),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, Register.id);
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: BrandGradient.deepTeal,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: BrandGradient.button,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: BrandGradient.deepTeal.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: _isSubmitting ? null : _handleLogin,
            child: Center(
              child: _isSubmitting
                  ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  valueColor:
                  AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
                  : const Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    required TextInputType keyboardType,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword ? _obscurePassword : false,
      validator: validator,
      style: const TextStyle(fontSize: 15, color: Colors.black87),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
        prefixIcon: Icon(prefixIcon, color: BrandGradient.teal, size: 21),
        suffixIcon: isPassword
            ? IconButton(
          splashRadius: 20,
          icon: Icon(
            _obscurePassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: Colors.black38,
            size: 20,
          ),
          onPressed: () {
            setState(() => _obscurePassword = !_obscurePassword);
          },
        )
            : null,
        filled: true,
        fillColor: const Color(0xFFF4FBFA),
        contentPadding:
        const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE3F3F1), width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: BrandGradient.deepTeal,
            width: 1.6,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }
}