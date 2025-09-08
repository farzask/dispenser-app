import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dispenser/widgets/buttons.dart';
import 'package:dispenser/widgets/textfield.dart';
import '../widgets/text.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword(BuildContext context, {super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _employeeIdController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _isSearching = false;
  String? _foundEmployeeName;
  String? _foundEmployeeDocId;
  bool _isAdmin = false;
  bool _employeeFound = false;

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
      _isAdmin = false;
    });

    try {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('cecos')
          .where('employeeID', isEqualTo: _employeeIdController.text.trim())
          .limit(1)
          .get();

      if (result.docs.isNotEmpty) {
        final doc = result.docs.first;
        setState(() {
          _employeeFound = true;
          _foundEmployeeName = doc.get('name');
          _foundEmployeeDocId = doc.id;
          _isAdmin = doc.get('isAdmin') ?? false;
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

  // Function to update employee password
  Future<void> _updatePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Check if passwords match
    if (_newPasswordController.text.trim() !=
        _confirmPasswordController.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Passwords do not match"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_foundEmployeeDocId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please search for an employee first"),
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
          .update({'password': _newPasswordController.text.trim()});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password updated successfully!"),
          backgroundColor: Colors.green,
        ),
      );

      // Clear the form after successful update
      _employeeIdController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
      setState(() {
        _employeeFound = false;
        _foundEmployeeName = null;
        _foundEmployeeDocId = null;
        _isAdmin = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error updating password: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Show confirmation dialog before updating password
  void _showUpdateConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirm Password Change',
            style: CustomTextStyles.subheading(),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                const Text(
                  'You are about to change the password for:',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),

                Center(
                  child: Column(
                    children: [
                      Text('Employee ID: ${_employeeIdController.text.trim()}'),
                      const SizedBox(height: 8),
                      Text('Name: $_foundEmployeeName'),
                      const SizedBox(height: 8),
                      Text('Role: ${_isAdmin ? "Admin" : "Employee"}'),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                Text(
                  'Are you sure you want to update this employee\'s password?',
                  style: CustomTextStyles.normal(color: Color(0xFFCC1D11)),
                ),
              ],
            ),
          ),
          actions: [
            Row(
              children: [
                TextButton(
                  child: Text('Cancel', style: CustomTextStyles.normal()),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF386A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(14),
                    ),
                  ),
                  child: const Text('Update Password'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _updatePassword();
                  },
                ),
              ],
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
        _isAdmin = false;
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
        title: Text(
          "Change Employee Password",
          style: CustomTextStyles.subheading(),
        ),
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
                      Text(
                        'Enter the employee ID for which you want to change the password',
                        style: CustomTextStyles.normal(fontSize: 16),
                      ),

                      const SizedBox(height: 24),

                      // Employee ID Field
                      CustomTextField(
                        controller: _employeeIdController,
                        hintText: "Enter employee ID",
                        topLabel: "Employee ID",
                        isRequired: true,
                        useFixedHeight: true,
                        fixedHeightSize: 60,
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                "Employee Found",
                                style: CustomTextStyles.subheading(),
                              ),
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
                            const SizedBox(height: 12),
                            _buildDetailRow(
                              "Role:",
                              _isAdmin ? "Admin" : "Employee",
                            ),

                            const SizedBox(height: 24),

                            // Password fields
                            Text(
                              "Set New Password",
                              style: CustomTextStyles.subheading(),
                            ),
                            const SizedBox(height: 16),

                            // New Password Field
                            CustomTextField(
                              controller: _newPasswordController,
                              hintText: "Enter new secure password",
                              topLabel: "New Password",
                              isRequired: true,
                              useFixedHeight: true,
                              fixedHeightSize: 60,
                              obscureText: true,
                              enabled: !_isLoading,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'New password is required';
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
                              hintText: "Re-enter new password",
                              topLabel: "Confirm New Password",
                              isRequired: true,
                              useFixedHeight: true,
                              fixedHeightSize: 60,
                              obscureText: true,
                              enabled: !_isLoading,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please confirm your password';
                                }
                                if (value != _newPasswordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 15),

                            // Update Button
                            Center(
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xFFFF386A),
                                      ),
                                    )
                                  : CustomButton(
                                      text: "Update Password",
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          _showUpdateConfirmationDialog();
                                        }
                                      },
                                    ),
                            ),
                            // ),
                          ],
                        ),
                      ],

                      const SizedBox(height: 20),
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
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
