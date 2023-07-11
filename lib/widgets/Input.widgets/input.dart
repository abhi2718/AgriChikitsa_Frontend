import 'package:flutter/material.dart';
import 'package:agriChikitsa/res/color.dart';

class Input extends StatelessWidget {
  static const borderWidth = 2.0;
  final String labelText;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget suffixIcon;
  final TextInputAction textInputAction;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final void Function(PointerDownEvent)? onTapOutside;
  final String initialValue;
  final bool autoFocus;
  final FocusNode? focusNode;
  const Input(
      {super.key,
      required this.labelText,
      required this.validator,
      required this.onSaved,
      this.keyboardType = TextInputType.text,
      this.obscureText = false,
      this.suffixIcon = const SizedBox(),
      this.textInputAction = TextInputAction.done,
      this.onFieldSubmitted,
      this.onChanged,
      this.onEditingComplete,
      this.onTapOutside,
      this.autoFocus = false,
      this.initialValue = '',
      this.focusNode});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: keyboardType,
      focusNode: focusNode,
      autofocus: autoFocus,
      onSaved: onSaved,
      validator: validator,
      initialValue: initialValue,
      obscureText: obscureText,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      onEditingComplete: onEditingComplete,
      onChanged: onChanged,
      onTapOutside: onTapOutside,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        suffixIconColor: AppColor.darkColor,
        labelText: labelText,
        disabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColor.darkColor,
            width: borderWidth,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColor.extraDark,
            width: borderWidth,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColor.darkColor,
            width: borderWidth,
          ),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColor.errorColor,
            width: borderWidth,
          ),
        ),
        errorMaxLines: 4,
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColor.errorColor,
            width: borderWidth,
          ),
        ),
      ),
    );
  }
}
