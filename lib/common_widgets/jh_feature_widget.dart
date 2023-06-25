import 'package:flutter/material.dart';
import 'package:parental_control/theme/theme.dart';

import 'jh_display_text.dart';

class JHFeatureWidget extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget? child;
  final IconData? icon;

  const JHFeatureWidget({
    Key? key,
    this.title,
    this.icon,
    this.child,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        boxShadow: [
          BoxShadow(
            color: CustomColors.indigoPrimary.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 2,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      padding: EdgeInsets.all(15.0),
      margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: SizedBox(
        width: 200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 10),
            if (child != null) child ?? SizedBox.shrink(),
            if (child != null) SizedBox(width: 20),
            title != null
                ? JHDisplayText(
                    text: title!,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: CustomColors.indigoLight,
                    ),
                  )
                : SizedBox.shrink(),
            Spacer(),
            if (icon != null)
              Icon(
                icon,
                size: 22,
              ),
            SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
