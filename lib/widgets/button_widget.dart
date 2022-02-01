import 'package:flutter/material.dart';
import 'package:todolistapp/sizeConfig/size_config.dart';

SizedBox bottomButton(
    {required BuildContext context,
    required String title,
    required Function onClick,
    isFloatingButton = false}) {
  return SizedBox(
    height: 7.5 * SizeConfig.heightMultiplier,
    width: MediaQuery.of(context).size.width,
    child: GestureDetector(
      onTap: () {
        onClick();
      },
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomRight,
                colors: [
                  Colors.teal,
                  Colors.teal[300]!,
                ]),
            borderRadius: BorderRadius.circular(10.0)),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 1.9 * SizeConfig.heightMultiplier,
            ),
          ),
        ),
      ),
    ),
  );
}
