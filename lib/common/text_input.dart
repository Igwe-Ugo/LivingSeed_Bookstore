import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CustomTextInput extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  IconData? icon;
  bool isPassword;
  bool isEmail;
  bool showEnter;
  bool isPhone;
  bool obscureText;
  bool isTitleNotNecessary;
  bool isNumber;
  Function? validator;
  int? maxLine;
  int? maxLength;
  bool isIcon;
  Color? textColor;
  CustomTextInput(
      {super.key,
      required this.label,
      required this.controller,
      this.icon,
      this.maxLine,
      this.showEnter = true,
      this.textColor,
      this.isEmail = false,
      this.isPassword = false,
      this.isPhone = false,
      this.isTitleNotNecessary = false,
      this.isNumber = false,
      this.validator,
      this.maxLength,
      this.isIcon = true,
      this.obscureText = true});

  @override
  State<CustomTextInput> createState() => _CustomTextInputState();
}

class _CustomTextInputState extends State<CustomTextInput> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        !widget.isTitleNotNecessary
            ? Text(
                widget.label,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: widget.textColor),
              )
            : SizedBox.shrink(),
        const SizedBox(height: 7),
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            border: Border.all(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.transparent
                  : Theme.of(context).disabledColor.withOpacity(0.1),
            ),
          ),
          child: TextFormField(
            controller: widget.controller,
            obscureText: widget.isPassword ? widget.obscureText : false,
            maxLines: widget.maxLine,
            maxLength: widget.maxLength,
            keyboardType: widget.isEmail
                ? TextInputType.emailAddress
                : widget.isPhone
                    ? TextInputType.phone
                    : widget.isNumber
                        ? TextInputType.number
                        : TextInputType.text,
            style: TextStyle(color: widget.textColor),
            decoration: InputDecoration(
              hoverColor: Theme.of(context).disabledColor.withOpacity(0.1),
              filled: true,
              fillColor: Theme.of(context).disabledColor.withOpacity(0.1),
              prefixIcon: widget.isIcon
                  ? Icon(
                      widget.icon,
                      size: 17,
                      color: widget.textColor,
                    )
                  : null,
              hintText: widget.showEnter == true
                  ? 'Enter ${widget.label}'
                  : widget.label,
              hintStyle: TextStyle(fontSize: 12, color: widget.textColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              suffixIcon: widget.isPassword
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.obscureText = !widget.obscureText;
                        });
                      },
                      child: Icon(
                        widget.obscureText ? Iconsax.eye : Iconsax.eye_slash,
                        size: 17,
                        color: widget.textColor!.withOpacity(0.7),
                      ),
                    )
                  : null,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
