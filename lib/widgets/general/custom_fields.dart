import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class CustomPinField extends StatelessWidget {
  final Function onSubmit;
  final int length;

  CustomPinField(this.onSubmit, this.length);

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      backgroundColor: Colors.transparent,
      pinTheme: PinTheme.defaults(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(5),
          activeColor: Theme.of(context).primaryColor,
          selectedColor: Theme.of(context).primaryColor,
          inactiveColor: Colors.black12),
      appContext: context,
      length: length,
      obscureText: false,
      autoFocus: true,
      animationType: AnimationType.fade,
      keyboardType: TextInputType.number,
      animationDuration: Duration(milliseconds: 300),
      onChanged: (val) {},
      onCompleted: (val) {
        onSubmit(val);
      },
    );
    ;
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool isNum;

  CustomTextField({this.label, this.hint, this.controller, this.isNum = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: isNum ? TextInputType.number : TextInputType.text,
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: label,
          hintText: hint,
        ),
      ),
    );
    ;
  }
}
