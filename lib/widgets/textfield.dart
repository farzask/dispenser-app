import 'package:flutter/material.dart';
import '../widgets/text.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int maxLines;
  final double height;
  final EdgeInsets? contentPadding;
  final Color? fillColor;
  final Color? enabledBorderColor;
  final Color? focusedBorderColor;
  final double borderRadius;
  final double enabledBorderWidth;
  final double focusedBorderWidth;
  final int? maxLength;
  final String? initialValue;
  final String? Function(String?)? validator;

  // New parameters for enhanced functionality
  final String? topLabel;
  final bool isRequired;
  final bool useFixedHeight;
  final double fixedHeightSize;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.labelText,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.height = 38,
    this.contentPadding,
    this.fillColor,
    this.enabledBorderColor,
    this.focusedBorderColor,
    this.borderRadius = 8.0,
    this.enabledBorderWidth = 1.0,
    this.focusedBorderWidth = 2.0,
    this.maxLength,
    this.initialValue,
    this.validator,
    // New parameters
    this.topLabel,
    this.isRequired = false,
    this.useFixedHeight = false,
    this.fixedHeightSize = 50.0,
  });

  Widget _buildTopLabel() {
    if (topLabel == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: RichText(
        text: TextSpan(
          text: topLabel!,
          style: CustomTextStyles.normal(),
          children: isRequired
              ? [
                  const TextSpan(
                    text: " *",
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ]
              : [],
        ),
      ),
    );
  }

  Widget _buildTextField() {
    if (initialValue != null && controller.text.isEmpty) {
      controller.text = initialValue!;
    }

    return SizedBox(
      height: maxLines == 1 ? height : null,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        enabled: enabled,
        readOnly: readOnly,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        maxLines: maxLines,
        maxLength: maxLength,
        onChanged: onChanged,
        onTap: onTap,
        validator: validator,
        decoration: InputDecoration(
          fillColor: fillColor ?? Colors.white,
          hintText: hintText,
          labelText: labelText,
          hintStyle: CustomTextStyles.hint(),
          filled: true,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          counterText: maxLength != null ? null : "",
          contentPadding:
              contentPadding ??
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: enabledBorderColor ?? const Color(0xFFACAAAA),
              width: enabledBorderWidth,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: focusedBorderColor ?? const Color(0xFF504E4F),
              width: focusedBorderWidth,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(color: Colors.red, width: 1.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(color: Colors.red, width: 2.0),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
              width: enabledBorderWidth,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!useFixedHeight && topLabel == null) {
      // Original behavior - just return the text field
      return _buildTextField();
    }

    // Enhanced behavior with top label and/or fixed height
    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildTopLabel(),
        if (useFixedHeight)
          SizedBox(
            height: fixedHeightSize,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Expanded(child: _buildTextField())],
            ),
          )
        else
          _buildTextField(),
      ],
    );

    return content;
  }
}
