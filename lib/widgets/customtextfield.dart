import 'package:flutter/material.dart';

class CustomATextField extends StatelessWidget {
  String hint;
  bool issecured;
  String type;

  CustomATextField({this.hint, this.issecured, this.type});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 25, right: 25),
        child: TextFormField(
          validator: (val) =>
              val.length == 0 ? "Please Enter A Valid Text" : null,
          obscureText: issecured,
          onSaved: (input) => type = input,
          cursorColor: Colors.white,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(25),
              ),
              hintText: hint,
              hintStyle: TextStyle(
                  fontSize: 18,
                  letterSpacing: 1.5,
                  color: Colors.white70,
                  fontWeight: FontWeight.w900),
              filled: true,
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              fillColor: Colors.white.withOpacity(.3),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(25),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(25),
              )),
        ));
  }
}
