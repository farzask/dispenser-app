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
//   bool _isAdmin = false; // Default to false (No)

//   // Function to check if employee ID already exists
//   Future<bool> _checkEmployeeIdExists(String employeeId) async {
//     try {
//       final QuerySnapshot result = await FirebaseFirestore.instance
//           .collection('cecos')
//           .where('employeeID', isEqualTo: employeeId)
//           .limit(1)
//           .get();

//       return result.docs.isNotEmpty;
//     } catch (e) {
//       return false;
//     }
//   }

//   // Function to add employee to Firestore
//   Future<void> _addEmployee() async {
//     // First validate the form
//     if (!_formKey.currentState!.validate()) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Please fill in all required fields"),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }

//     // Check if passwords match
//     if (_passwordController.text.trim() !=
//         _confirmPasswordController.text.trim()) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Passwords do not match"),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       // Check if employee ID already exists
//       bool employeeExists = await _checkEmployeeIdExists(
//         _employeeIdController.text.trim(),
//       );

//       if (employeeExists) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text(
//               "Employee ID already exists. Please use a different ID.",
//             ),
//             backgroundColor: Colors.orange,
//           ),
//         );
//         setState(() {
//           _isLoading = false;
//         });
//         return;
//       }

//       // Add employee to Firestore collection 'cecos'
//       await FirebaseFirestore.instance.collection('cecos').add({
//         'employeeID': _employeeIdController.text.trim(),
//         'name': _nameController.text.trim(),
//         'password': _passwordController.text.trim(),
//         'isAdmin': _isAdmin,
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Employee added successfully!"),
//           backgroundColor: Colors.green,
//         ),
//       );

//       // Clear the form after successful submission
//       _employeeIdController.clear();
//       _nameController.clear();
//       _passwordController.clear();
//       _confirmPasswordController.clear();
//       setState(() {
//         _isAdmin = false; // Reset to default
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Error adding employee: ${e.toString()}"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   // Show confirmation dialog before adding employee
//   void _showConfirmationDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Confirm Employee Details'),
//           content: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text('Name: ${_nameController.text.trim()}'),
//                 const SizedBox(height: 8),
//                 Text('Employee ID: ${_employeeIdController.text.trim()}'),
//                 const SizedBox(height: 8),
//                 Text('Admin Access: ${_isAdmin ? "Yes" : "No"}'),
//                 const SizedBox(height: 16),
//                 const Text(
//                   'Are you sure you want to add this employee?',
//                   style: TextStyle(fontWeight: FontWeight.w500),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               child: const Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             ElevatedButton(
//               child: const Text('Add Employee'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _addEmployee();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFFDF5F5),
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
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
//                       // Name Field
//                       CustomTextField(
//                         controller: _nameController,
//                         hintText: "Enter full name",
//                         topLabel: "Name",
//                         isRequired: true,
//                         useFixedHeight: true,
//                         fixedHeightSize: 60,
//                         enabled: !_isLoading,
//                         validator: (value) {
//                           if (value == null || value.trim().isEmpty) {
//                             return 'Name is required';
//                           }
//                           if (value.trim().length < 2) {
//                             return 'Name must be at least 2 characters';
//                           }
//                           return null;
//                         },
//                       ),

//                       const SizedBox(height: 16),

//                       // Employee ID Field
//                       CustomTextField(
//                         controller: _employeeIdController,
//                         hintText: "Enter unique employee ID",
//                         topLabel: "Employee ID",
//                         isRequired: true,
//                         useFixedHeight: true,
//                         fixedHeightSize: 60,
//                         enabled: !_isLoading,
//                         validator: (value) {
//                           if (value == null || value.trim().isEmpty) {
//                             return 'Employee ID is required';
//                           }
//                           if (value.trim().length < 3) {
//                             return 'Employee ID must be at least 3 characters';
//                           }
//                           return null;
//                         },
//                       ),

//                       const SizedBox(height: 16),

//                       // Password Field
//                       CustomTextField(
//                         controller: _passwordController,
//                         hintText: "Enter secure password",
//                         topLabel: "Password",
//                         isRequired: true,
//                         useFixedHeight: true,
//                         fixedHeightSize: 60,
//                         obscureText: true,
//                         enabled: !_isLoading,
//                         validator: (value) {
//                           if (value == null || value.trim().isEmpty) {
//                             return 'Password is required';
//                           }
//                           // if (value.length < 6) {
//                           //   return 'Password must be at least 6 characters';
//                           // }
//                           return null;
//                         },
//                       ),

//                       const SizedBox(height: 16),

//                       // Confirm Password Field
//                       CustomTextField(
//                         controller: _confirmPasswordController,
//                         hintText: "Re-enter password",
//                         topLabel: "Confirm Password",
//                         isRequired: true,
//                         useFixedHeight: true,
//                         fixedHeightSize: 60,
//                         obscureText: true,
//                         enabled: !_isLoading,
//                         validator: (value) {
//                           if (value == null || value.trim().isEmpty) {
//                             return 'Please confirm your password';
//                           }
//                           if (value != _passwordController.text) {
//                             return 'Passwords do not match';
//                           }
//                           return null;
//                         },
//                       ),

//                       const SizedBox(height: 16),

//                       // Admin Access Field
//                       RichText(
//                         text: TextSpan(
//                           text: "Grant Admin Privileges",
//                           style: CustomTextStyles.normal(),
//                           children: const [
//                             TextSpan(
//                               text: " *",
//                               style: TextStyle(color: Colors.red, fontSize: 16),
//                             ),
//                           ],
//                         ),
//                       ),

//                       Center(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             // Yes Radio Button
//                             Radio<bool>(
//                               value: true,
//                               groupValue: _isAdmin,
//                               onChanged: _isLoading
//                                   ? null
//                                   : (bool? value) {
//                                       setState(() {
//                                         _isAdmin = value ?? false;
//                                       });
//                                     },
//                               activeColor: const Color(0xFFFF386A),
//                             ),
//                             const Text("Yes"),
//                             const SizedBox(width: 25),

//                             // No Radio Button
//                             Radio<bool>(
//                               value: false,
//                               groupValue: _isAdmin,
//                               onChanged: _isLoading
//                                   ? null
//                                   : (bool? value) {
//                                       setState(() {
//                                         _isAdmin = value ?? false;
//                                       });
//                                     },
//                               activeColor: const Color(0xFFFF386A),
//                             ),
//                             const Text("No"),
//                           ],
//                         ),
//                       ),

//                       const SizedBox(height: 5),

//                       // Submit Button
//                       Center(
//                         child: _isLoading
//                             ? const CircularProgressIndicator(
//                                 valueColor: AlwaysStoppedAnimation<Color>(
//                                   Color(0xFFFF386A),
//                                 ),
//                               )
//                             : CustomButton(
//                                 text: "Add Employee",
//                                 onPressed: () {
//                                   // Validate form before showing confirmation
//                                   if (_formKey.currentState!.validate()) {
//                                     _showConfirmationDialog();
//                                   }
//                                 },
//                               ),
//                       ),

//                       const SizedBox(height: 10),

//                       // Required fields note
//                       Center(
//                         child: Text(
//                           "* Required fields",
//                           style: TextStyle(
//                             color: Colors.grey[600],
//                             fontSize: 12,
//                             fontStyle: FontStyle.italic,
//                           ),
//                         ),
//                       ),
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
import 'package:dispenser/widgets/buttons.dart';
import 'package:dispenser/widgets/textfield.dart';
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
  int _fingerprintId = 0; // Variable to store the fingerprint ID
  bool _isLoadingFingerprintId = true; // Loading state for fingerprint ID

  // List of error codes to avoid
  final List<int> errorCodes = [0, 9];

  @override
  void initState() {
    super.initState();
    _fetchAndSetFingerprintId();
  }

  // Function to fetch counter from admin document and generate fingerprint ID
  Future<void> _fetchAndSetFingerprintId() async {
    try {
      // Fetch the admin document
      DocumentSnapshot admin = await FirebaseFirestore.instance
          .collection('cecos')
          .doc('admin') // Replace with your actual admin document ID
          .get();

      if (admin.exists) {
        Map<String, dynamic> data = admin.data() as Map<String, dynamic>;
        int counter = data['counter'] ?? 0;

        // Increment counter and check against error codes
        int nextFingerprintId = counter + 1;
        while (errorCodes.contains(nextFingerprintId)) {
          nextFingerprintId++;
        }

        setState(() {
          _fingerprintId = nextFingerprintId;
          _isLoadingFingerprintId = false;
        });
      } else {
        // If admin document doesn't exist, start with 1
        int nextFingerprintId = 1;
        while (errorCodes.contains(nextFingerprintId)) {
          nextFingerprintId++;
        }

        setState(() {
          _fingerprintId = nextFingerprintId;
          _isLoadingFingerprintId = false;
        });
      }
    } catch (e) {
      print('Error fetching counter: $e');
      // Fallback to starting with 1
      int nextFingerprintId = 1;
      while (errorCodes.contains(nextFingerprintId)) {
        nextFingerprintId++;
      }

      setState(() {
        _fingerprintId = nextFingerprintId;
        _isLoadingFingerprintId = false;
      });
    }
  }

  // Function to update counter in admin document
  Future<void> _updateAdminCounter() async {
    try {
      await FirebaseFirestore.instance.collection('cecos').doc('admin').update({
        'counter': _fingerprintId,
      });
    } catch (e) {
      print('Error updating counter: $e');
      // Handle error as needed
    }
  }

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

      // Add employee to Firestore collection 'cecos' with fingerprint ID
      await FirebaseFirestore.instance.collection('cecos').add({
        'employeeID': _employeeIdController.text.trim(),
        'name': _nameController.text.trim(),
        'password': _passwordController.text.trim(),
        'isAdmin': _isAdmin,
        'fingerprintId':
            _fingerprintId, // Add fingerprint ID to employee document
      });

      // Update the counter in admin document after successful employee addition
      await _updateAdminCounter();

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

      // Generate new fingerprint ID for next employee
      await _fetchAndSetFingerprintId();
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
                Text('Fingerprint ID: $_fingerprintId'),
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
                      // Fingerprint ID Display
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFFFF386A).withOpacity(0.3),
                            ),
                          ),
                          child: _isLoadingFingerprintId
                              ? const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Color(0xFFFF386A),
                                            ),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text("Loading Fingerprint ID..."),
                                  ],
                                )
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.fingerprint,
                                      color: Color(0xFFFF386A),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Fingerprint ID: $_fingerprintId",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFFFF386A),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),

                      const SizedBox(height: 24),

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
