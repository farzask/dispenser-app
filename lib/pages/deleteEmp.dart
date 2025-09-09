// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dispenser/widgets/buttons.dart';
// import 'package:dispenser/widgets/textfield.dart';
// import '../widgets/text.dart';

// class DeleteEmployee extends StatefulWidget {
//   const DeleteEmployee(BuildContext context, {super.key});

//   @override
//   State<DeleteEmployee> createState() => _DeleteEmployeeState();
// }

// class _DeleteEmployeeState extends State<DeleteEmployee> {
//   final TextEditingController _employeeIdController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   bool _isLoading = false;
//   bool _isSearching = false;
//   String? _foundEmployeeName;
//   String? _foundEmployeeDocId;
//   bool _employeeFound = false;

//   Future<void> _updateAdminCounter() async {
//     try {
//       // Fetch the admin document
//       DocumentSnapshot admin = await FirebaseFirestore.instance
//           .collection('cecos')
//           .doc('admin') // Replace with your actual admin document ID
//           .get();

//       if (admin.exists) {
//         Map<String, dynamic> data = admin.data() as Map<String, dynamic>;
//         int counter = data['counter'] ?? 0;
//         int fingerprintID = counter - 1;

//         try {
//           await FirebaseFirestore.instance
//               .collection('cecos')
//               .doc('admin')
//               .update({'counter': fingerprintID});
//         } catch (e) {
//           print('Error updating counter: $e');
//           // Handle error as needed
//         }
//       }
//     } catch (e) {
//       print('Error fetching counter: $e');
//     }
//   }

//   // Function to search for employee by ID
//   Future<void> _searchEmployee() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }

//     setState(() {
//       _isSearching = true;
//       _employeeFound = false;
//       _foundEmployeeName = null;
//       _foundEmployeeDocId = null;
//     });

//     try {
//       final QuerySnapshot result = await FirebaseFirestore.instance
//           .collection('cecos')
//           .where('employeeID', isEqualTo: _employeeIdController.text.trim())
//           .limit(1)
//           .get();

//       if (result.docs.isNotEmpty) {
//         final doc = result.docs.first;
//         setState(() {
//           _employeeFound = true;
//           _foundEmployeeName = doc.get('name');
//           _foundEmployeeDocId = doc.id;
//         });
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text("Employee not found with the provided ID"),
//             backgroundColor: Colors.orange,
//           ),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Error searching employee: ${e.toString()}"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } finally {
//       setState(() {
//         _isSearching = false;
//       });
//     }
//   }

//   // Function to delete employee from Firestore
//   Future<void> _deleteEmployee() async {
//     if (_foundEmployeeDocId == null) return;

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       if (isAdmin)
//       await FirebaseFirestore.instance
//           .collection('cecos')
//           .doc(_foundEmployeeDocId)
//           .delete();
//       _updateAdminCounter();
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Employee deleted successfully!"),
//           backgroundColor: Colors.green,
//         ),
//       );

//       // Clear the form after successful deletion
//       _employeeIdController.clear();
//       setState(() {
//         _employeeFound = false;
//         _foundEmployeeName = null;
//         _foundEmployeeDocId = null;
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Error deleting employee: ${e.toString()}"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   // Show confirmation dialog before deleting employee
//   void _showDeleteConfirmationDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(
//             'Confirm Employee Deletion',
//             style: CustomTextStyles.subheading(),
//           ),
//           content: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Text(
//                   'You are about to delete the following employee:',
//                   style: TextStyle(fontWeight: FontWeight.w500),
//                 ),
//                 const SizedBox(height: 16),

//                 Center(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Employee ID: ${_employeeIdController.text.trim()}'),
//                       const SizedBox(height: 8),
//                       Text('Name: $_foundEmployeeName'),
//                       const SizedBox(height: 16),
//                     ],
//                   ),
//                 ),

//                 const Text(
//                   'This action cannot be undone. Are you sure you want to delete this employee?',
//                   style: TextStyle(
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xFFCC1D11),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               child: Text('Cancel', style: CustomTextStyles.normal()),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFFCC1D11),
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadiusGeometry.circular(14),
//                 ),
//               ),
//               child: const Text('Delete Employee'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _deleteEmployee();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // Reset form when employee ID changes
//   void _onEmployeeIdChanged(String value) {
//     if (_employeeFound) {
//       setState(() {
//         _employeeFound = false;
//         _foundEmployeeName = null;
//         _foundEmployeeDocId = null;
//       });
//     }
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
//         title: Text("Delete Employee", style: CustomTextStyles.subheading()),
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
//                       const SizedBox(height: 24),

//                       // Employee ID Field
//                       CustomTextField(
//                         controller: _employeeIdController,
//                         hintText: "Enter employee ID to delete",
//                         topLabel: "Employee ID",
//                         isRequired: true,
//                         useFixedHeight: true,
//                         fixedHeightSize: 70,
//                         enabled: !_isLoading && !_isSearching,
//                         onChanged: _onEmployeeIdChanged,
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

//                       const SizedBox(height: 20),

//                       // Search Button
//                       Center(
//                         child: _isSearching
//                             ? const CircularProgressIndicator(
//                                 valueColor: AlwaysStoppedAnimation<Color>(
//                                   Color(0xFFFF386A),
//                                 ),
//                               )
//                             : CustomButton(
//                                 text: "Search Employee",
//                                 onPressed: _searchEmployee,
//                               ),
//                       ),

//                       const SizedBox(height: 24),

//                       // Employee Details Card (shown when employee is found)
//                       if (_employeeFound) ...[
//                         Container(
//                           width: double.infinity,
//                           padding: const EdgeInsets.all(20),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(
//                               color: const Color(0xFFACAAAA),
//                               width: 1.0,
//                             ),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.grey.withOpacity(0.1),
//                                 spreadRadius: 2,
//                                 blurRadius: 8,
//                                 offset: const Offset(0, 2),
//                               ),
//                             ],
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 children: [
//                                   const Icon(
//                                     Icons.person,
//                                     color: Color(0xFFFF386A),
//                                     size: 28,
//                                   ),
//                                   const SizedBox(width: 12),
//                                   Text(
//                                     "Employee Found",
//                                     style: CustomTextStyles.subheading(),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 16),

//                               // Employee Details
//                               _buildDetailRow(
//                                 "Employee ID:",
//                                 _employeeIdController.text.trim(),
//                               ),
//                               const SizedBox(height: 12),
//                               _buildDetailRow(
//                                 "Name:",
//                                 _foundEmployeeName ?? "N/A",
//                               ),

//                               const SizedBox(height: 24),

//                               // Delete Button
//                               Center(
//                                 child: _isLoading
//                                     ? const CircularProgressIndicator(
//                                         valueColor:
//                                             AlwaysStoppedAnimation<Color>(
//                                               Colors.red,
//                                             ),
//                                       )
//                                     : SizedBox(
//                                         width: double.infinity,
//                                         height: 40,
//                                         child: ElevatedButton.icon(
//                                           label: const Text("Delete Employee"),
//                                           style: ElevatedButton.styleFrom(
//                                             backgroundColor: const Color(
//                                               0xFFCC1D11,
//                                             ),
//                                             foregroundColor: Colors.white,

//                                             shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(8),
//                                             ),
//                                           ),
//                                           onPressed:
//                                               _showDeleteConfirmationDialog,
//                                         ),
//                                       ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                       SizedBox(height: 10),
//                       Row(
//                         children: [
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: Text(
//                               "Warning: This action will permanently delete the employee record and cannot be undone.",
//                               style: TextStyle(
//                                 color: Color(0xFFCC1D11),
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                         ],
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

//   Widget _buildDetailRow(String label, String value) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(
//           width: 100,
//           child: Text(
//             label,
//             style: const TextStyle(
//               fontWeight: FontWeight.w600,
//               color: Colors.grey,
//             ),
//           ),
//         ),
//         Expanded(
//           child: Text(
//             value,
//             style: const TextStyle(
//               fontWeight: FontWeight.w500,
//               color: Colors.black87,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   void dispose() {
//     _employeeIdController.dispose();
//     super.dispose();
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dispenser/widgets/buttons.dart';
import 'package:dispenser/widgets/textfield.dart';
import '../widgets/text.dart';

class DeleteEmployee extends StatefulWidget {
  const DeleteEmployee(BuildContext context, {super.key});

  @override
  State<DeleteEmployee> createState() => _DeleteEmployeeState();
}

class _DeleteEmployeeState extends State<DeleteEmployee> {
  final TextEditingController _employeeIdController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _isSearching = false;
  String? _foundEmployeeName;
  String? _foundEmployeeDocId;
  bool _employeeFound = false;

  Future<void> _updateAdminCounter() async {
    try {
      // Fetch the admin document
      DocumentSnapshot admin = await FirebaseFirestore.instance
          .collection('cecos')
          .doc('admin') // Replace with your actual admin document ID
          .get();

      if (admin.exists) {
        Map<String, dynamic> data = admin.data() as Map<String, dynamic>;
        int counter = data['counter'] ?? 0;
        int fingerprintID = counter - 1;

        try {
          await FirebaseFirestore.instance
              .collection('cecos')
              .doc('admin')
              .update({'counter': fingerprintID});
        } catch (e) {
          print('Error updating counter: $e');
          // Handle error as needed
        }
      }
    } catch (e) {
      print('Error fetching counter: $e');
    }
  }

  // Function to search for employee by ID
  Future<void> _searchEmployee() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSearching = true;
      _employeeFound = false;
      _foundEmployeeName = null;
      _foundEmployeeDocId = null;
    });

    try {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('cecos')
          .where('employeeID', isEqualTo: _employeeIdController.text.trim())
          .limit(1)
          .get();

      if (result.docs.isNotEmpty) {
        final doc = result.docs.first;

        // Check if the document ID is 'admin'
        if (doc.id == 'admin') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Cannot delete admin record. Admin records are protected.",
              ),
              backgroundColor: Colors.orange,
            ),
          );
          return;
        }

        setState(() {
          _employeeFound = true;
          _foundEmployeeName = doc.get('name');
          _foundEmployeeDocId = doc.id;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Employee not found with the provided ID"),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error searching employee: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }

  // Function to delete employee from Firestore
  Future<void> _deleteEmployee() async {
    if (_foundEmployeeDocId == null) return;

    // Double check: prevent deletion if document ID is 'admin'
    if (_foundEmployeeDocId == 'admin') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Cannot delete admin record. Admin records are protected.",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('cecos')
          .doc(_foundEmployeeDocId)
          .delete();
      _updateAdminCounter();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Employee deleted successfully!"),
          backgroundColor: Colors.green,
        ),
      );

      // Clear the form after successful deletion
      _employeeIdController.clear();
      setState(() {
        _employeeFound = false;
        _foundEmployeeName = null;
        _foundEmployeeDocId = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error deleting employee: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Show confirmation dialog before deleting employee
  void _showDeleteConfirmationDialog() {
    // Additional check before showing dialog
    if (_foundEmployeeDocId == 'admin') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Cannot delete admin record. Admin records are protected.",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirm Employee Deletion',
            style: CustomTextStyles.subheading(),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'You are about to delete the following employee:',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),

                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Employee ID: ${_employeeIdController.text.trim()}'),
                      const SizedBox(height: 8),
                      Text('Name: $_foundEmployeeName'),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),

                const Text(
                  'This action cannot be undone. Are you sure you want to delete this employee?',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFCC1D11),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel', style: CustomTextStyles.normal()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFCC1D11),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(14),
                ),
              ),
              child: const Text('Delete Employee'),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteEmployee();
              },
            ),
          ],
        );
      },
    );
  }

  // Reset form when employee ID changes
  void _onEmployeeIdChanged(String value) {
    if (_employeeFound) {
      setState(() {
        _employeeFound = false;
        _foundEmployeeName = null;
        _foundEmployeeDocId = null;
      });
    }
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
        title: Text("Delete Employee", style: CustomTextStyles.subheading()),
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
                      const SizedBox(height: 24),

                      // Employee ID Field
                      CustomTextField(
                        controller: _employeeIdController,
                        hintText: "Enter employee ID to delete",
                        topLabel: "Employee ID",
                        isRequired: true,
                        useFixedHeight: true,
                        fixedHeightSize: 70,
                        enabled: !_isLoading && !_isSearching,
                        onChanged: _onEmployeeIdChanged,
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

                      const SizedBox(height: 20),

                      // Search Button
                      Center(
                        child: _isSearching
                            ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFFFF386A),
                                ),
                              )
                            : CustomButton(
                                text: "Search Employee",
                                onPressed: _searchEmployee,
                              ),
                      ),

                      const SizedBox(height: 24),

                      // Employee Details Card (shown when employee is found)
                      if (_employeeFound) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFACAAAA),
                              width: 1.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.person,
                                    color: Color(0xFFFF386A),
                                    size: 28,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    "Employee Found",
                                    style: CustomTextStyles.subheading(),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Employee Details
                              _buildDetailRow(
                                "Employee ID:",
                                _employeeIdController.text.trim(),
                              ),
                              const SizedBox(height: 12),
                              _buildDetailRow(
                                "Name:",
                                _foundEmployeeName ?? "N/A",
                              ),

                              const SizedBox(height: 24),

                              // Delete Button
                              Center(
                                child: _isLoading
                                    ? const CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.red,
                                            ),
                                      )
                                    : SizedBox(
                                        width: double.infinity,
                                        height: 40,
                                        child: ElevatedButton.icon(
                                          label: const Text("Delete Employee"),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(
                                              0xFFCC1D11,
                                            ),
                                            foregroundColor: Colors.white,

                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          onPressed:
                                              _showDeleteConfirmationDialog,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      SizedBox(height: 10),
                      Row(
                        children: [
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "Warning: This action will permanently delete the employee record and cannot be undone. Admin records are protected from deletion.",
                              style: TextStyle(
                                color: Color(0xFFCC1D11),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
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

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _employeeIdController.dispose();
    super.dispose();
  }
}
