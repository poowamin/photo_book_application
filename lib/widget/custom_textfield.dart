import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final Widget? prefix;
  final Widget? suffix;
  final int? maxLine;
  final double? contentPadding;
  final TextInputType inputType;
  final ValueSetter<String>? onChanged;
  final Function(String)? onFieldSubmitted;
  final Function(String)? validator;
  final Function? onTab;
  final double radiusSize;
  final bool obscureText;
  final bool shouldShowErrorText;
  final bool? readOnly;
  final TextAlign textAlign;
  final TextStyle? style;
  final String? initialValue;
  final String? errorText;
  final Color cursorColor;
  final Color? focusedBorderColor;
  final int? maxLength;

  const CustomTextField({
    Key? key,
    this.controller,
    this.hintText,
    this.prefix,
    this.suffix,
    this.maxLine = 1,
    this.onChanged,
    this.contentPadding,
    this.onFieldSubmitted,
    this.errorText,
    this.validator,
    this.radiusSize = 16,
    this.obscureText = false,
    this.shouldShowErrorText = true,
    this.inputType = TextInputType.text,
    this.textAlign = TextAlign.start,
    this.style,
    this.initialValue,
    this.focusedBorderColor,
    this.cursorColor = Colors.black26,
    this.maxLength,
    this.readOnly = false,
    this.onTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: (value) => onChanged?.call(value),
      validator: (value) {
        return validator?.call(value ?? '');
      },
      onTap: () => onTab?.call(),
      onFieldSubmitted: onFieldSubmitted,
      controller: controller,
      keyboardType: inputType,
      cursorColor: cursorColor,
      obscureText: obscureText,
      style: style ?? const TextStyle(fontSize: 16),
      enableSuggestions: false,
      autocorrect: false,
      textAlign: textAlign,
      maxLines: maxLine,
      readOnly: readOnly!,
      maxLength: maxLength,
      decoration: InputDecoration(
        isDense: true,
        prefixIcon: prefix,
        suffixIcon: suffix,
        counterText: '',
        focusColor: Colors.black38,
        errorStyle: shouldShowErrorText
            ? const TextStyle(fontSize: 14, color: Colors.red)
            : const TextStyle(height: 0),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(radiusSize)),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(radiusSize)),
          borderSide: BorderSide(color: focusedBorderColor ?? Colors.black38),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(radiusSize)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(radiusSize),
          ),
          borderSide: const BorderSide(color: Colors.black45),
        ),
        hintStyle: const TextStyle(fontSize: 16, color: Colors.black26),
        hintText: hintText,
        errorText: errorText,
      ),
    );
  }
}
