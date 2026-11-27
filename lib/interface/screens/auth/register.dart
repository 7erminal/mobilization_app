import 'package:flutter/material.dart';
import 'package:mobilization_app/index.dart';

class Register extends StatefulWidget {
  const Register({super.key});
  static const String id = "/register";

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  final _clientCodeController = TextEditingController();
  Future<dynamic>? corporatives_;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    phoneNumberController.text = "";
    nameController.text = "";
    emailController.text = "";
    passwordController.text = "";
    repeatPasswordController.text = "";
    usernameController.text = "";
    _clientCodeController.text = "";
    corporatives_ = _getCorporatives();
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    repeatPasswordController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  Future<dynamic> _getCorporatives() async {
    try {
      // showLoading(context);
      var response = await ApiFetcher.instance.getCorporatives();
      // Navigator.pop(context);

      debugPrint("Response returned for get corporatives...");

      return response;
    } catch(e){
      debugPrint("An error occurred in the api fetcher: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF4FBFA),
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: topPadding + 36,
                  bottom: 48,
                  left: 24,
                  right: 24,
                ),
                decoration: const BoxDecoration(
                  gradient: _RegisterGradient.diagonal,
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
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        Assets.brandLogoEnhanced,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.person_add_alt_1_rounded,
                          color: _RegisterGradient.deepTeal,
                          size: 36,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Create account',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Register to start using your account',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
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
                          color: _RegisterGradient.teal.withValues(alpha: 0.10),
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
                          const _FieldLabel('Co-operative Code'),
                          const SizedBox(height: 8),
                          FutureBuilder(
                            future: corporatives_,
                            builder: (context, asyncSnapshot) {
                              if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(color: BrandColors.primaryColor),
                                );
                              }
                              if (asyncSnapshot.hasError || asyncSnapshot.data == null) {
                                return const Text(
                                  "An error occurred while fetching corporatives. Please restart the app and try again.",
                                  style: TextStyle(color: Colors.redAccent),
                                );
                              }
                              if (asyncSnapshot.hasData) {
                                return _buildTextField(
                                  controller: _clientCodeController,
                                  hintText: "Enter co-operative code",
                                  prefixIcon: Icons.ads_click_outlined,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value?.isEmpty ?? true) {
                                      return 'Co-operative code is required';
                                    }
                                    if (value!.length < 6) {
                                      return 'Code must be at least 6 characters';
                                    }
                                    return null;
                                  },
                                );
                              }
                              return buildLoadingWidget();
                            },
                          ),
                          const SizedBox(height: 20),
                          const _FieldLabel('Username'),
                          const SizedBox(height: 8),
                          _buildTextField(
                            controller: usernameController,
                            hintText: "Enter username",
                            prefixIcon: Icons.supervised_user_circle_rounded,
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(height: 20),
                          const Divider(color: Color(0xFFE3F3F1), height: 1.2),
                          const SizedBox(height: 20),
                          const _FieldLabel('Name'),
                          const SizedBox(height: 8),
                          _buildTextField(
                            controller: nameController,
                            hintText: "Enter name",
                            prefixIcon: Icons.perm_identity,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Name is required';
                              }
                              return null;
                            }
                          ),
                          const SizedBox(height: 20),
                          const _FieldLabel('Email'),
                          const SizedBox(height: 8),
                          _buildTextField(
                            controller: emailController,
                            hintText: "Enter email",
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Email is required';
                                }
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value!)) {
                                  return 'Enter a valid email address';
                                }
                                return null;
                              }
                          ),
                          const SizedBox(height: 20),
                          const _FieldLabel('Phone Number'),
                          const SizedBox(height: 8),
                          _buildTextField(
                            controller: phoneNumberController,
                            hintText: "Enter phone number",
                            prefixIcon: Icons.phone,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Phone number is required';
                              }
                              if (!RegExp(r'^\d{10,15}$').hasMatch(value!)) {
                                return 'Enter a valid phone number';
                              }
                              return null;
                            }
                          ),
                          const SizedBox(height: 20),
                          const _FieldLabel('Password'),
                          const SizedBox(height: 8),
                          _buildTextField(
                            controller: passwordController,
                            hintText: "Enter password",
                            prefixIcon: Icons.password,
                            keyboardType: TextInputType.visiblePassword,
                            isPassword: true,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Password is required';
                              }
                              if (value!.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            }
                          ),
                          const SizedBox(height: 20),
                          const _FieldLabel('Repeat Password'),
                          const SizedBox(height: 8),
                          _buildTextField(
                            controller: repeatPasswordController,
                            hintText: "Repeat password",
                            prefixIcon: Icons.password_outlined,
                            keyboardType: TextInputType.visiblePassword,
                            isPassword: true,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Please repeat the password';
                              }
                              if (value != passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            }
                          ),
                          const SizedBox(height: 28),
                          SizedBox(
                            height: 52,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: _RegisterGradient.button,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: _RegisterGradient.deepTeal.withValues(alpha: 0.35),
                                    blurRadius: 16,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(14),
                                  onTap: () async {
                      // Handle login logic here
                      // Navigator.pushReplacementNamed(context, HomeNavigation.id);
                      if(!mounted)return;

                      if (_formKey.currentState?.validate() ?? false) {
                        showLoading(context);
                        String? selectedCorporation;
                        bool corpExists = false;
                        if (corporatives_ != null) {
                          debugPrint("Corporatives are not null");
                          debugPrint(
                              "About to check with ${_clientCodeController
                                  .text}");
                          for (CorporativeModel cm in userBloc.corporatives) {
                            debugPrint("Each corporative is ${cm.id}, ${cm
                                .clientCode}");
                            if (cm.clientCode!.trim() ==
                                _clientCodeController.text.trim()) {
                              debugPrint("Got the code. Assigning...");
                              selectedCorporation = cm.id;
                              corpExists = true;
                            }
                          }
                        }
                        Navigator.pop(context);

                        if(!corpExists){
                          return informationDialogWithButton(context, "Error", "Unrecognized Coop ID. Please check and try again.", BrandColors.danger, BrandColors.black, "Try again", ()=>Navigator.pop(context), true);
                        }
                        int selectedCorporationInt = int.parse(
                            selectedCorporation ?? "0");

                        showLoading(context);
                        var registerUser = await ApiFetcher.instance.signUp(
                            clientId: selectedCorporationInt,
                            name: nameController.text,
                            phoneNumber: phoneNumberController.text,
                            email: emailController.text,
                            password: passwordController.text,
                            username: usernameController.text,
                            roleId: "2"
                        );
                        Navigator.pop(context);

                        if (registerUser['Success'] == true) {
                          if (!mounted) return;
                          informationDialogWithButton(
                              context,
                              "Registration Successful",
                              registerUser['StatusDesc'],
                              BrandColors.successColor,
                              BrandColors.black,
                              "Ok",
                                  () =>
                                  Navigator.pushNamed(context, LoginScreen.id),
                              true
                          );
                        } else {
                          if (!mounted) return;
                          informationDialogWithButton(
                              context,
                              "ERROR",
                              "Sorry. An error occurred. ${registerUser['StatusDesc']}",
                              BrandColors.danger,
                              BrandColors.black,
                              "Retry",
                                  () => Navigator.pop(context),
                              false);
                        }
                      } else {
                        if (!mounted) return;
                        informationDialogWithButton(
                            context,
                            "Invalid Input",
                            "Please ensure all fields are filled out correctly.",
                            BrandColors.danger,
                            BrandColors.black,
                            "Ok",
                                () => Navigator.pop(context),
                            false);
                      }

                                  },
                                  child: const Center(
                                    child: Text(
                                      'Sign Up',
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.only(bottom: 28),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BodyTextGrey(text: "Already have an account?"),
                    TextButton(
                      onPressed: () {
                        // Navigate to the registration screen
                        Navigator.pushNamed(context, LoginScreen.id);
                      },
                      child: BodyTextBlack(
                        text: "Login",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SafeArea(child: Container(),)
            ],
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
      validator: validator,
      obscureText: isPassword,
      style: const TextStyle(fontSize: 15, color: Colors.black87),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
        prefixIcon: Icon(prefixIcon, color: _RegisterGradient.teal, size: 21),
        filled: true,
        fillColor: const Color(0xFFF4FBFA),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
          borderSide: const BorderSide(color: _RegisterGradient.deepTeal, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
        ),
      ),
    );
  }
}

class _RegisterGradient {
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

