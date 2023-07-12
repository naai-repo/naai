import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CurvedBorderedCard extends StatelessWidget {
  final Function()? onTap;
  final Widget child;
  final bool removeBottomPadding;
  final bool cardSelected;
  final Color? fillColor;
  final double? borderRadius;

  const CurvedBorderedCard({
    super.key,
    required this.child,
    this.removeBottomPadding = true,
    this.cardSelected = false,
    this.onTap,
    this.fillColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        padding: removeBottomPadding
            ? EdgeInsets.only(top: 1.5.h)
            : EdgeInsets.symmetric(vertical: 1.5.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 1.h),
          boxShadow: <BoxShadow>[
            BoxShadow(
              offset: Offset(0, 2.0),
              color: Colors.grey.shade100,
              spreadRadius: 0.1,
              blurRadius: 5,
            ),
          ],
          border: Border.all(
            width: 1,
            color: Color(0xFFE7E7E7),
          ),
          color: fillColor ?? (cardSelected ? Color(0xFFEBEBEB) : Colors.white),
        ),
        child: child,
      ),
    );
  }
}
