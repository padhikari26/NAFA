import 'package:flutter/material.dart';
import 'package:nafausa/app/theme/theme.dart';
import 'package:nafausa/app/utils/helper.dart';
import 'package:nafausa/app/utils/size_config.dart';

import '../../../app/utils/app_colors.dart';
import '../../../app/utils/constants.dart';

class CustomMaterialFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  final Widget? prefix;
  final Widget? suffix;
  final String? hintText;
  final String? labelText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final bool? isFilled;
  final Color? backgroundColor;
  final Color? borderColor;
  final double hPad;
  final bool isRequired;
  final double vPad;
  final bool isEnabled;
  final bool isReadOnly;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final Function(String)? onSubmitted;
  final int maxLength;
  final Function()? onTap;
  final double labelFontSize;
  final int minLines;
  final Color inputTextColor;
  final TextStyle? labelStyle;
  final TextStyle? inputStyle;
  final TextStyle? placeholderStyle;
  final TextCapitalization textCapitalization;

  const CustomMaterialFormField({
    super.key,
    this.controller,
    this.validator,
    this.onChanged,
    this.prefix,
    this.suffix,
    this.hintText,
    this.labelText,
    this.obscureText = false,
    this.keyboardType,
    this.isFilled = false,
    this.backgroundColor,
    this.hPad = 3,
    this.vPad = 1.6,
    this.isRequired = true,
    this.isEnabled = true,
    this.isReadOnly = false,
    this.borderColor,
    this.textInputAction = TextInputAction.next,
    this.maxLines = 1,
    this.minLines = 1,
    this.onSubmitted,
    this.maxLength = 100000,
    this.onTap,
    this.labelFontSize = 14,
    this.inputTextColor = Colors.black,
    this.labelStyle,
    this.inputStyle,
    this.placeholderStyle,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  State<CustomMaterialFormField> createState() =>
      _CustomMaterialFormFieldState();
}

class _CustomMaterialFormFieldState extends State<CustomMaterialFormField> {
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.labelText.isNotNullOrEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                widget.labelText!,
                style: widget.labelStyle ??
                    context.bodyLarge?.copyWith(
                      fontSize: widget.labelFontSize.fs,
                    ),
              ),
            ),
          TextFormField(
            textCapitalization: widget.textCapitalization,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            obscureText: widget.obscureText,
            maxLength: widget.maxLength,
            minLines: widget.minLines,
            maxLines: widget.maxLines,
            enabled: widget.isEnabled,
            validator: widget.validator,
            readOnly: widget.isReadOnly,
            textInputAction: widget.textInputAction,
            style: widget.inputStyle ??
                context.bodySmall?.copyWith(
                  height: 1.2,
                  color: widget.isReadOnly
                      ? Colors.grey[600]
                      : widget.inputTextColor,
                ),
            onChanged: (value) {
              widget.onChanged?.call(value);
            },
            onFieldSubmitted: (value) {
              addHaptics();
              widget.onSubmitted?.call(value);
            },
            onTap: widget.onTap,
            decoration: InputDecoration(
              isDense: true,
              filled: widget.isFilled,
              fillColor: widget.isFilled!
                  ? widget.backgroundColor ?? Colors.grey[200]
                  : null,
              hintText: widget.hintText,
              hintStyle: widget.placeholderStyle ??
                  context.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontSize: 14.fs,
                  ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: widget.hPad.ws,
                vertical: widget.vPad.hs,
              ),
              prefixIcon: widget.prefix != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: widget.prefix,
                    )
                  : null,
              suffixIcon: widget.suffix != null
                  ? Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: widget.suffix,
                    )
                  : null,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: widget.borderColor ?? Colors.grey.shade300,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: widget.borderColor ?? AppColors.nepalBlue,
                  width: 1.2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red.shade700, width: 1.2),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red.shade700, width: 1.5),
                borderRadius: BorderRadius.circular(12),
              ),
              errorText: _errorText,
              counterText: '', // Hide character counter
            ),
          ),
        ],
      ),
    );
  }
}
