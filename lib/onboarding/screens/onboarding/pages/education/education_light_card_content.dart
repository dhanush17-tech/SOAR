import 'package:flutter/material.dart';

import 'package:SOAR/onboarding/constants.dart';
import 'package:SOAR/onboarding/widgets/icon_container.dart';
class EducationLightCardContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
             Image.asset("assets/slide1.png")

      ],
    );
  }
}
