import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:SOAR/onboarding/constants.dart';

class Header extends StatelessWidget {
  final VoidCallback onSkip;

  const Header({
    @required this.onSkip,
  }) : assert(onSkip != null);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
     Image.asset("assets/soar.png",            height: 48.0,
),
    
    
        GestureDetector(
          onTap: onSkip,
          child: Text(
            'Skip',
            style:
                Theme.of(context).textTheme.subtitle1.copyWith(color: kWhite),
          ),
        ),
      ],
    );
  }
}