// // import 'package:flutter/material.dart';
// // import 'package:taptocare/widgets/buttons.dart';
// // import 'package:taptocare/widgets/textfield.dart';
// // import '../widgets/text.dart';

// // class AddEmployee extends StatelessWidget {
// //   final TextEditingController _employeeIdController = TextEditingController();
// //   final TextEditingController _nameController = TextEditingController();

// //   AddEmployee(BuildContext context, {super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         backgroundColor: Color(0xFFFDF5F5),
// //         centerTitle: true,
// //         leading: IconButton(
// //           icon: Icon(Icons.arrow_back, color: Colors.black),
// //           onPressed: () => {Navigator.pop(context)},
// //         ),
// //         title: Text("Add Employee", style: CustomTextStyles.subheading()),
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
// //               child: Padding(
// //                 padding: const EdgeInsets.all(30.0),
// //                 child: Column(
// //                   mainAxisAlignment: MainAxisAlignment.center,

// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text("Name", style: CustomTextStyles.normal()),
// //                     SizedBox(height: 7),
// //                     CustomTextField(
// //                       controller: _nameController,
// //                       hintText: "Name",
// //                     ),

// //                     SizedBox(height: 13),

// //                     Text("Employee ID", style: CustomTextStyles.normal()),
// //                     SizedBox(height: 7),
// //                     CustomTextField(
// //                       controller: _employeeIdController,
// //                       hintText: "Employee ID",
// //                     ),

// //                     SizedBox(height: 13),

// //                     Text("Password", style: CustomTextStyles.normal()),
// //                     SizedBox(height: 7),
// //                     CustomTextField(
// //                       controller: _employeeIdController,
// //                       hintText: "Password",
// //                       obscureText: true,
// //                     ),
// //                     SizedBox(height: 13),

// //                     Text("Confirm Password", style: CustomTextStyles.normal()),
// //                     SizedBox(height: 7),
// //                     CustomTextField(
// //                       controller: _employeeIdController,
// //                       hintText: "Confirm Password",
// //                       obscureText: true,
// //                     ),

// //                     SizedBox(height: 20),

// //                     Center(
// //                       child: CustomButton(
// //                         text: "Add Employee",
// //                         onPressed: () {},
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:taptocare/widgets/buttons.dart';
// import 'package:taptocare/widgets/textfield.dart';
// import '../widgets/text.dart';

// class AddEmployee extends StatefulWidget {
//   const AddEmployee(BuildContext context, {super.key});

//   @override
//   State<AddEmployee> createState() => _AddEmployeeState();
// }

// class _AddEmployeeState extends State<AddEmployee> {
//   final TextEditingController _employeeIdController = TextEditingController();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();

//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   bool _isLoading = false;

//   // Function to add employee to Firestore
//   Future<void> _addEmployee() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }

//     if (_passwordController.text != _confirmPasswordController.text) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       // Add employee to Firestore collection 'cecos'
//       await FirebaseFirestore.instance.collection('cecos').add({
//         'employeeId': _employeeIdController.text.trim(),
//         'name': _nameController.text.trim(),
//         'password': _passwordController.text, //
//         'createdAt': FieldValue.serverTimestamp(),
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Employee added successfully")),
//       );

//       // Clear the form
//       _employeeIdController.clear();
//       _nameController.clear();
//       _passwordController.clear();
//       _confirmPasswordController.clear();
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Error adding employee: $e")));
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xFFFDF5F5),
//         centerTitle: true,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text("Add Employee", style: CustomTextStyles.subheading()),
//         elevation: 0,
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Color(0xFFFDF5F5), Color(0xFFF9EFEF), Color(0xFFF4E7E7)],
//             stops: [0.0, 0.59, 1.0],
//           ),
//         ),
//         child: SafeArea(
//           child: Center(
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(30.0),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Name", style: CustomTextStyles.normal()),
//                       SizedBox(height: 7),
//                       CustomTextField(
//                         controller: _nameController,
//                         hintText: "Full Name",
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter employee name';
//                           }
//                           return null;
//                         },
//                       ),

//                       SizedBox(height: 13),

//                       Text("Employee ID", style: CustomTextStyles.normal()),
//                       SizedBox(height: 7),
//                       CustomTextField(
//                         controller: _employeeIdController,
//                         hintText: "Employee ID",
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter employee ID';
//                           }
//                           return null;
//                         },
//                       ),

//                       SizedBox(height: 13),

//                       Text("Password", style: CustomTextStyles.normal()),
//                       SizedBox(height: 7),
//                       CustomTextField(
//                         controller: _passwordController,
//                         hintText: "Password",
//                         obscureText: true,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter password';
//                           }
//                           return null;
//                         },
//                       ),
//                       SizedBox(height: 13),

//                       Text(
//                         "Confirm Password",
//                         style: CustomTextStyles.normal(),
//                       ),
//                       SizedBox(height: 7),
//                       CustomTextField(
//                         controller: _confirmPasswordController,
//                         hintText: "Confirm Password",
//                         obscureText: true,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please confirm password';
//                           }
//                           return null;
//                         },
//                       ),

//                       SizedBox(height: 30),

//                       Center(
//                         child: _isLoading
//                             ? CircularProgressIndicator(
//                                 valueColor: AlwaysStoppedAnimation<Color>(
//                                   Color(0xFFD32F2F),
//                                 ),
//                               )
//                             : CustomButton(
//                                 text: "Add Employee",
//                                 onPressed: _addEmployee,
//                               ),
//                       ),

//                       SizedBox(height: 20),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _employeeIdController.dispose();
//     _nameController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taptocare/widgets/buttons.dart';
import 'package:taptocare/widgets/textfield.dart';
import '../widgets/text.dart';

class AddEmployee extends StatefulWidget {
  const AddEmployee(BuildContext context, {super.key});

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  final TextEditingController _employeeIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isAdmin = false; // Default to false (No)

  // Function to check if employee ID already exists
  Future<bool> _checkEmployeeIdExists(String employeeId) async {
    try {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('cecos')
          .where('employeeID', isEqualTo: employeeId)
          .limit(1)
          .get();

      return result.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Function to add employee to Firestore
  Future<void> _addEmployee() async {
    // First validate the form
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all required fields"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Check if passwords match
    if (_passwordController.text.trim() !=
        _confirmPasswordController.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Passwords do not match"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Check if employee ID already exists
      bool employeeExists = await _checkEmployeeIdExists(
        _employeeIdController.text.trim(),
      );

      if (employeeExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Employee ID already exists. Please use a different ID.",
            ),
            backgroundColor: Colors.orange,
          ),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Add employee to Firestore collection 'cecos'
      await FirebaseFirestore.instance.collection('cecos').add({
        'employeeID': _employeeIdController.text.trim(),
        'name': _nameController.text.trim(),
        'password': _passwordController.text.trim(),
        'isAdmin': _isAdmin,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Employee added successfully!"),
          backgroundColor: Colors.green,
        ),
      );

      // Clear the form after successful submission
      _employeeIdController.clear();
      _nameController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
      setState(() {
        _isAdmin = false; // Reset to default
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error adding employee: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Show confirmation dialog before adding employee
  void _showConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Employee Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Name: ${_nameController.text.trim()}'),
                const SizedBox(height: 8),
                Text('Employee ID: ${_employeeIdController.text.trim()}'),
                const SizedBox(height: 8),
                Text('Admin Access: ${_isAdmin ? "Yes" : "No"}'),
                const SizedBox(height: 16),
                const Text(
                  'Are you sure you want to add this employee?',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Add Employee'),
              onPressed: () {
                Navigator.of(context).pop();
                _addEmployee();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDF5F5),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Add Employee", style: CustomTextStyles.subheading()),
        elevation: 0,
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
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name Field
                      CustomTextField(
                        controller: _nameController,
                        hintText: "Enter full name",
                        topLabel: "Name",
                        isRequired: true,
                        useFixedHeight: true,
                        fixedHeightSize: 60,
                        enabled: !_isLoading,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Name is required';
                          }
                          if (value.trim().length < 2) {
                            return 'Name must be at least 2 characters';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Employee ID Field
                      CustomTextField(
                        controller: _employeeIdController,
                        hintText: "Enter unique employee ID",
                        topLabel: "Employee ID",
                        isRequired: true,
                        useFixedHeight: true,
                        fixedHeightSize: 60,
                        enabled: !_isLoading,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Employee ID is required';
                          }
                          if (value.trim().length < 3) {
                            return 'Employee ID must be at least 3 characters';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Password Field
                      CustomTextField(
                        controller: _passwordController,
                        hintText: "Enter secure password",
                        topLabel: "Password",
                        isRequired: true,
                        useFixedHeight: true,
                        fixedHeightSize: 60,
                        obscureText: true,
                        enabled: !_isLoading,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Password is required';
                          }
                          // if (value.length < 6) {
                          //   return 'Password must be at least 6 characters';
                          // }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Confirm Password Field
                      CustomTextField(
                        controller: _confirmPasswordController,
                        hintText: "Re-enter password",
                        topLabel: "Confirm Password",
                        isRequired: true,
                        useFixedHeight: true,
                        fixedHeightSize: 60,
                        obscureText: true,
                        enabled: !_isLoading,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Admin Access Field
                      RichText(
                        text: TextSpan(
                          text: "Grant Admin Privileges",
                          style: CustomTextStyles.normal(),
                          children: const [
                            TextSpan(
                              text: " *",
                              style: TextStyle(color: Colors.red, fontSize: 16),
                            ),
                          ],
                        ),
                      ),

                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Yes Radio Button
                            Radio<bool>(
                              value: true,
                              groupValue: _isAdmin,
                              onChanged: _isLoading
                                  ? null
                                  : (bool? value) {
                                      setState(() {
                                        _isAdmin = value ?? false;
                                      });
                                    },
                              activeColor: const Color(0xFFFF386A),
                            ),
                            const Text("Yes"),
                            const SizedBox(width: 25),

                            // No Radio Button
                            Radio<bool>(
                              value: false,
                              groupValue: _isAdmin,
                              onChanged: _isLoading
                                  ? null
                                  : (bool? value) {
                                      setState(() {
                                        _isAdmin = value ?? false;
                                      });
                                    },
                              activeColor: const Color(0xFFFF386A),
                            ),
                            const Text("No"),
                          ],
                        ),
                      ),

                      const SizedBox(height: 5),

                      // Submit Button
                      Center(
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFFFF386A),
                                ),
                              )
                            : CustomButton(
                                text: "Add Employee",
                                onPressed: () {
                                  // Validate form before showing confirmation
                                  if (_formKey.currentState!.validate()) {
                                    _showConfirmationDialog();
                                  }
                                },
                              ),
                      ),

                      const SizedBox(height: 10),

                      // Required fields note
                      Center(
                        child: Text(
                          "* Required fields",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
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

  @override
  void dispose() {
    _employeeIdController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
