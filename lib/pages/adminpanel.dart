import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dispenser/pages/addEmp.dart';
import 'package:dispenser/pages/changePassword.dart';
import 'package:dispenser/pages/deleteEmp.dart';
import 'package:dispenser/pages/login.dart';
import 'package:dispenser/widgets/buttons.dart';
import '../widgets/text.dart';

class AdminPanel extends StatelessWidget {
  const AdminPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFDF5F5),
        centerTitle: true,
        title: Text("Admin", style: CustomTextStyles.subheading()),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFDF5F5), Color(0xFFF9EFEF), Color(0xFFF4E7E7)],
            stops: [0.0, 0.59, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    text: 'Add Employee',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddEmployee(context),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 20),

                  CustomButton(
                    text: 'Delete Employee',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DeleteEmployee(context),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 20),

                  CustomButton(
                    text: 'Change Password',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangePassword(context),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 20),

                  CustomButton(
                    text: 'Log out',
                    onPressed: () {
                      showDialog<void>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Logout'),
                            content: const Text(
                              'Are you sure you want to logout?',
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text(
                                  'Cancel',
                                  style: CustomTextStyles.normal(),
                                ),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              TextButton(
                                child: Text(
                                  'Logout',
                                  style: CustomTextStyles.normal(
                                    color: Color.fromARGB(255, 15, 5, 8),
                                  ),
                                ),

                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.clear();
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Login(),
                                    ),
                                    (route) => false,
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
