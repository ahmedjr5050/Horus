import 'package:apps/core/helper/extention.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/routing/routes.dart';

class CustomTypeContainer extends StatelessWidget {
  const CustomTypeContainer(
      {super.key,
      required this.textAPPBAR,
      required this.imagess,
      required this.description});
  final String textAPPBAR;
  final String imagess;
  final String description;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(left: 10.px, right: 10.px, bottom: 8.px, top: 1.px),
      child: GestureDetector(
        onTap: () {
          context.pushNamed(Routes.closestPlacesView);
        },
        child: Container(
          width: 408.px,
          height: 149.px,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.px),
          ),
          child: Row(
            children: [
              Container(
                width: 147.px,
                height: 149.px,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.px),
                    bottomLeft: Radius.circular(10.px),
                  ),
                  image: DecorationImage(
                    image: AssetImage(imagess),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15.px),
                    child: Text(
                      textAPPBAR,
                      style: TextStyle(
                          fontFamily: 'Koh',
                          fontWeight: FontWeight.w700,
                          fontSize: 18.px,
                          color: const Color(0xff9B5D01)),
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      text: description,
                      style: TextStyle(
                          fontFamily: 'Koh',
                          fontWeight: FontWeight.w700,
                          fontSize: 12.px,
                          color: const Color(0xff51504D)),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
