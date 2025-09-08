import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dispenser/widgets/buttons.dart';
import 'package:dispenser/pages/homepage.dart';
import 'package:dispenser/pages/adminpanel.dart'; // Make sure this import exists
import '../widgets/text.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _employeeIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _employeeIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final String employeeId = _employeeIdController.text.trim();
      final String password = _passwordController.text.trim();

      // Get all documents from cecos collection
      final QuerySnapshot cecosQuery = await FirebaseFirestore.instance
          .collection('cecos')
          .get();

      bool userFound = false;
      bool isAdmin = false;
      String userName = employeeId;

      // Search through all documents for matching credentials
      for (QueryDocumentSnapshot doc in cecosQuery.docs) {
        final userData = doc.data() as Map<String, dynamic>;

        // Check if this document contains the matching employeeID and password
        if (userData['employeeID'] == employeeId &&
            userData['password'] == password) {
          userFound = true;
          isAdmin = userData['isAdmin'] ?? false;
          userName =
              userData['name'] ?? employeeId; // Use name field if available
          break;
        }
      }

      if (userFound) {
        // Save login state
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('employeeId', employeeId);
        await prefs.setString('userName', userName);
        await prefs.setBool('isAdmin', isAdmin);

        // Navigate based on role
        if (isAdmin) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AdminPanel()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MyHomePage(employeeId: employeeId),
            ),
          );
        }
      } else {
        // Show error for invalid credentials
        _showErrorDialog(
          'Invalid credentials',
          'Please check your Employee ID and password.',
        );
      }
    } catch (e) {
      // Handle any errors
      _showErrorDialog(
        'Login Error',
        'An error occurred during login. Please try again.',
      );
      print('Login error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;
    final EdgeInsets padding = MediaQuery.of(context).padding;

    // Responsive sizing
    final bool isSmallScreen = screenWidth < 360;
    final bool isMediumScreen = screenWidth >= 360 && screenWidth < 600;
    final bool isLargeScreen = screenWidth >= 600;

    // Dynamic sizing based on screen size
    final double imageWidth = isSmallScreen
        ? screenWidth * 0.7
        : isMediumScreen
        ? screenWidth * 0.8
        : 300.0;

    final double containerWidth = isSmallScreen
        ? screenWidth * 0.85
        : isMediumScreen
        ? screenWidth * 0.85
        : isLargeScreen
        ? 400.0
        : 310.0;

    final double horizontalPadding = isSmallScreen ? 16.0 : 30.0;
    final double verticalSpacing = isSmallScreen ? 8.0 : 10.0;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEA91A0), Color(0xFFF1748E), Color(0xFFFF386A)],
            stops: [0.0, 0.63, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: padding.top > 0 ? 0 : 20.0,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: screenHeight - padding.top - padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Flexible spacing at top
                      const Spacer(flex: 1),

                      // Image with responsive sizing
                      Image.asset(
                        "asset/icons/females.png",
                        width: imageWidth,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: imageWidth,
                            height: imageWidth * 0.6,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.image,
                              size: 50,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),

                      // Login form container
                      Container(
                        width: containerWidth,
                        constraints: BoxConstraints(
                          maxWidth: isLargeScreen ? 400 : double.infinity,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: const Color(0xFFFDF5F5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              spreadRadius: 0,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(horizontalPadding),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Title
                                Text(
                                  "Add your login credentials",
                                  style: CustomTextStyles.subheading(),
                                ),

                                SizedBox(height: verticalSpacing * 1.5),

                                // Employee ID field
                                Text(
                                  "Employee ID",
                                  style: CustomTextStyles.normal(),
                                ),
                                SizedBox(height: verticalSpacing * 0.8),

                                SizedBox(
                                  height: 38,
                                  child: TextFormField(
                                    controller: _employeeIdController,
                                    enabled: !_isLoading,
                                    decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      hintText: "Employee ID",
                                      hintStyle: CustomTextStyles.hint(),
                                      filled: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 12,
                                          ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          8.0,
                                        ),
                                        borderSide: const BorderSide(
                                          color: Color(0xFFACAAAA),
                                          width: 1.0,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          8.0,
                                        ),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF504E4F),
                                          width: 2.0,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          8.0,
                                        ),
                                        borderSide: const BorderSide(
                                          color: Colors.red,
                                          width: 1.0,
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          8.0,
                                        ),
                                        borderSide: const BorderSide(
                                          color: Colors.red,
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'Please enter your Employee ID/Name';
                                      }
                                      return null;
                                    },
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),

                                SizedBox(height: verticalSpacing * 1.2),

                                // Password field
                                Text(
                                  "Password",
                                  style: CustomTextStyles.normal(),
                                ),
                                SizedBox(height: verticalSpacing * 0.8),

                                SizedBox(
                                  height: 38,
                                  child: TextFormField(
                                    controller: _passwordController,
                                    obscureText: true,
                                    enabled: !_isLoading,
                                    decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      hintText: "Password",
                                      hintStyle: CustomTextStyles.hint(),
                                      filled: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 12,
                                          ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          8.0,
                                        ),
                                        borderSide: const BorderSide(
                                          color: Color(0xFFACAAAA),
                                          width: 1.0,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          8.0,
                                        ),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF504E4F),
                                          width: 2.0,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          8.0,
                                        ),
                                        borderSide: const BorderSide(
                                          color: Colors.red,
                                          width: 1.0,
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          8.0,
                                        ),
                                        borderSide: const BorderSide(
                                          color: Colors.red,
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your password';
                                      }

                                      return null;
                                    },
                                    textInputAction: TextInputAction.done,
                                    onFieldSubmitted: (_) => _handleLogin(),
                                  ),
                                ),

                                SizedBox(height: verticalSpacing * 2),

                                // Login button
                                SizedBox(
                                  width: double.infinity,
                                  child: _isLoading
                                      ? Container(
                                          height: 45,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            color: Colors.grey[300],
                                          ),
                                          child: const Center(
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Color(0xFFFF386A),
                                                  ),
                                            ),
                                          ),
                                        )
                                      : CustomButton(
                                          text: "Login",
                                          onPressed: _handleLogin,
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Flexible spacing at bottom
                      const Spacer(flex: 1),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
