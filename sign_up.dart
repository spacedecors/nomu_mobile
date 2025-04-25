import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login.dart';

class SignUpScreen extends StatefulWidget {
  final String userType;
  final Map userData;

  const SignUpScreen({Key? key, required this.userData, required this.userType}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final Color myColor = const Color(0xFF242c5b);
  bool _isObscurePassword = true;
  bool _isObscureConfirmPassword = true;
  bool _acceptedTerms = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? _nameError;
  String? _emailError;
  String? _phoneError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _termsError;

  bool _isValidPhoneNumber(String phone) => RegExp(r'^(?:\+63|0)\d{10}$').hasMatch(phone);
  bool _isValidEmail(String email) => RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  bool _isValidPassword(String password) => RegExp(r'^(?=.*[A-Z])(?=.*\W).{8,}$').hasMatch(password);

  void _togglePasswordVisibility() => setState(() => _isObscurePassword = !_isObscurePassword);
  void _toggleConfirmPasswordVisibility() => setState(() => _isObscureConfirmPassword = !_isObscureConfirmPassword);

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Registration Successful'),
        content: const Text('You have successfully registered. You can now log in.'),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
            },
          ),
        ],
      ),
    );
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Privacy Policy"),
        content: const SingleChildScrollView(
          child: Text(
            "Privacy Policy for Nomu Cafe\n\nEffective Date: October 27, 2024\n\n"
            "At Nomu Cafe, we value your privacy. This policy outlines how we handle your personal data...\n",
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Close'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _registerUser() {
    final name = _nameController.text;
    final email = _emailController.text;
    final phone = _phoneController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    setState(() {
      _nameError = name.isEmpty ? 'Name is required' : null;
      _emailError = email.isEmpty ? 'Email is required' : !_isValidEmail(email) ? 'Enter a valid email' : null;
      _phoneError = phone.isEmpty ? 'Phone number is required' : !_isValidPhoneNumber(phone) ? 'Enter a valid phone number' : null;
      _passwordError = password.isEmpty ? 'Password is required' : !_isValidPassword(password)
          ? 'At least 8 characters, 1 uppercase & 1 special character' : null;
      _confirmPasswordError = confirmPassword.isEmpty
          ? 'Please confirm your password'
          : confirmPassword != password
              ? 'Passwords do not match'
              : null;
      _termsError = !_acceptedTerms ? 'You must accept the terms' : null;
    });

    if (_nameError == null && _emailError == null && _phoneError == null &&
        _passwordError == null && _confirmPasswordError == null && _termsError == null) {
      _showSuccessDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: myColor,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: mediaSize.height * 0.05), // Adjusted height for mobile fit
            _buildTop(mediaSize),
            const Spacer(),
            _buildBottom(mediaSize),
          ],
        ),
      ),
    );
  }

  Widget _buildTop(Size mediaSize) {
    return Column(
      children: [
        Image.asset("assets/images/nomulogo.jpg", height: mediaSize.height * 0.12), // Reduced logo size
        const SizedBox(height: 8),
        const Text(
          "NOMU CAFE",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22, // Further reduced font size
            letterSpacing: 1.5, // Adjusted letter spacing for smaller screens
            fontFamily: "Montserrat",
          ),
        ),
      ],
    );
  }

  Widget _buildBottom(Size mediaSize) {
    return Container(
      width: mediaSize.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Reduced padding to fit mobile
        child: Column(
          children: [
            const Text(
              "SIGN UP",
              style: TextStyle(
                fontSize: 20, // Reduced font size for the heading
                fontWeight: FontWeight.bold,
                color: Color(0xFF242c5b),
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(child: _buildForm()),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _field("Full Name", _nameController, _nameError),
        _field("Email", _emailController, _emailError),
        _field("Phone Number", _phoneController, _phoneError, inputType: TextInputType.phone, formatter: [FilteringTextInputFormatter.digitsOnly]),
        _field("Password", _passwordController, _passwordError, isPassword: true, obscure: _isObscurePassword, toggleObscure: _togglePasswordVisibility),
        _field("Confirm Password", _confirmPasswordController, _confirmPasswordError,
            isPassword: true, obscure: _isObscureConfirmPassword, toggleObscure: _toggleConfirmPasswordVisibility),
        _terms(),
        const SizedBox(height: 12), // Reduced spacing
        ElevatedButton(
          onPressed: _registerUser,
          style: ElevatedButton.styleFrom(
            backgroundColor: myColor,
            minimumSize: const Size.fromHeight(50), // Further reduced button height
          ),
          child: const Text("SIGN UP", style: TextStyle(fontSize: 16)), // Smaller button text
        ),
      ],
    );
  }

  Widget _field(String label, TextEditingController controller, String? error,
      {bool isPassword = false, bool obscure = false, VoidCallback? toggleObscure, TextInputType inputType = TextInputType.text, List<TextInputFormatter>? formatter}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.black, fontSize: 12)), // Reduced label font size
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: inputType,
          inputFormatters: formatter,
          decoration: InputDecoration(
            suffixIcon: isPassword ? IconButton(
              icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
              onPressed: toggleObscure,
            ) : null,
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12), // Smaller padding
          ),
        ),
        if (error != null) Text(error, style: const TextStyle(color: Colors.red, fontSize: 10)), // Smaller error text
        const SizedBox(height: 10), // Reduced spacing
      ],
    );
  }

  Widget _terms() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
              value: _acceptedTerms,
              onChanged: (val) => setState(() {
                _acceptedTerms = val!;
                _termsError = null;
              }),
            ),
            Expanded(
              child: GestureDetector(
                onTap: _showTermsDialog,
                child: const Text("I accept the Privacy Policy.",
                    style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue, fontSize: 12)),
              ),
            ),
          ],
        ),
        if (_termsError != null) Text(_termsError!, style: const TextStyle(color: Colors.red, fontSize: 10)),
      ],
    );
  }
}
