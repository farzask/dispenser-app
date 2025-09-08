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

// // import 'package:flutter/material.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:taptocare/pages/addEmp.dart';
// // import 'package:taptocare/pages/changePassword.dart';
// // import 'package:taptocare/pages/deleteEmp.dart';
// // import 'package:taptocare/pages/login.dart';
// // import 'package:taptocare/widgets/buttons.dart';
// // import '../widgets/text.dart';

// // class AdminPanel extends StatelessWidget {
// //   const AdminPanel({super.key});

// //   // Function to get current counter and calculate next ID (without saving)
// //   Future<int> _getNextCounterId() async {
// //     try {
// //       // List of error codes to avoid
// //       List<int> errorCodes = [0, 9];

// //       // Get admin document (assuming there's only one admin or you have a specific admin ID)
// //       // You might need to modify this query based on your admin document structure
// //       QuerySnapshot adminQuery = await FirebaseFirestore.instance
// //           .collection('cecos')
// //           .where('isAdmin', isEqualTo: true)
// //           .limit(1)
// //           .get();

// //       if (adminQuery.docs.isEmpty) {
// //         throw Exception('Admin document not found');
// //       }

// //       DocumentSnapshot adminDoc = adminQuery.docs.first;
// //       Map<String, dynamic>? adminData =
// //           adminDoc.data() as Map<String, dynamic>?;

// //       // Get current counter value, default to 0 if not exists
// //       int currentCounter = adminData?['counter'] ?? 0;

// //       // Increment counter
// //       int nextCounter = currentCounter + 1;

// //       // Keep incrementing until we find a value not in error codes
// //       while (errorCodes.contains(nextCounter)) {
// //         nextCounter++;
// //       }

// //       return nextCounter;
// //     } catch (e) {
// //       print('Error getting counter ID: $e');
// //       throw Exception('Failed to get counter ID: ${e.toString()}');
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         backgroundColor: Color(0xFFFDF5F5),
// //         centerTitle: true,
// //         title: Text("Admin", style: CustomTextStyles.subheading()),
// //       ),
// //       body: Container(
// //         decoration: const BoxDecoration(
// //           gradient: LinearGradient(
// //             begin: Alignment.topCenter,
// //             end: Alignment.bottomCenter,
// //             colors: [Color(0xFFFDF5F5), Color(0xFFF9EFEF), Color(0xFFF4E7E7)],
// //             stops: [0.0, 0.59, 1.0],
// //           ),
// //         ),
// //         child: SafeArea(
// //           child: Center(
// //             child: SingleChildScrollView(
// //               child: Column(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   CustomButton(
// //                     text: 'Add Employee',
// //                     onPressed: () async {
// //                       try {
// //                         // Show loading indicator
// //                         showDialog(
// //                           context: context,
// //                           barrierDismissible: false,
// //                           builder: (BuildContext context) {
// //                             return const Center(
// //                               child: CircularProgressIndicator(
// //                                 valueColor: AlwaysStoppedAnimation<Color>(
// //                                   Color(0xFFFF386A),
// //                                 ),
// //                               ),
// //                             );
// //                           },
// //                         );

// //                         // Get next counter ID (without saving)
// //                         int counterId = await _getNextCounterId();

// //                         // Close loading dialog
// //                         Navigator.of(context).pop();

// //                         // Navigate to AddEmployee page with counter ID
// //                         Navigator.push(
// //                           context,
// //                           MaterialPageRoute(
// //                             builder: (context) =>
// //                                 AddEmployee(context, counterId: counterId),
// //                           ),
// //                         );
// //                       } catch (e) {
// //                         // Close loading dialog if still open
// //                         Navigator.of(context).pop();

// //                         // Show error message
// //                         ScaffoldMessenger.of(context).showSnackBar(
// //                           SnackBar(
// //                             content: Text(
// //                               "Error generating ID: ${e.toString()}",
// //                             ),
// //                             backgroundColor: Colors.red,
// //                           ),
// //                         );
// //                       }
// //                     },
// //                   ),

// //                   SizedBox(height: 20),

// //                   CustomButton(
// //                     text: 'Delete Employee',
// //                     onPressed: () {
// //                       Navigator.push(
// //                         context,
// //                         MaterialPageRoute(
// //                           builder: (context) => DeleteEmployee(context),
// //                         ),
// //                       );
// //                     },
// //                   ),

// //                   SizedBox(height: 20),

// //                   CustomButton(
// //                     text: 'Change Password',
// //                     onPressed: () {
// //                       Navigator.push(
// //                         context,
// //                         MaterialPageRoute(
// //                           builder: (context) => ChangePassword(context),
// //                         ),
// //                       );
// //                     },
// //                   ),

// //                   SizedBox(height: 20),

// //                   CustomButton(
// //                     text: 'Log out',
// //                     onPressed: () {
// //                       showDialog<void>(
// //                         context: context,
// //                         barrierDismissible: false,
// //                         builder: (BuildContext context) {
// //                           return AlertDialog(
// //                             title: const Text('Logout'),
// //                             content: const Text(
// //                               'Are you sure you want to logout?',
// //                             ),
// //                             actions: <Widget>[
// //                               TextButton(
// //                                 child: Text(
// //                                   'Cancel',
// //                                   style: CustomTextStyles.normal(),
// //                                 ),
// //                                 onPressed: () => Navigator.of(context).pop(),
// //                               ),
// //                               TextButton(
// //                                 child: Text(
// //                                   'Logout',
// //                                   style: CustomTextStyles.normal(
// //                                     color: Color.fromARGB(255, 15, 5, 8),
// //                                   ),
// //                                 ),

// //                                 onPressed: () async {
// //                                   Navigator.of(context).pop();
// //                                   final prefs =
// //                                       await SharedPreferences.getInstance();
// //                                   await prefs.clear();
// //                                   Navigator.pushAndRemoveUntil(
// //                                     context,
// //                                     MaterialPageRoute(
// //                                       builder: (context) => const Login(),
// //                                     ),
// //                                     (route) => false,
// //                                   );
// //                                 },
// //                               ),
// //                             ],
// //                           );
// //                         },
// //                       );
// //                     },
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
