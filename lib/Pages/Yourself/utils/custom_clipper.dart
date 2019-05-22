import 'package:flutter/material.dart';

class TabShapeClipper extends CustomClipper<Path> {
  TabShapeClipper({this.index = 0});

  final int index;

  var clipSize = 8.0;

  @override
  Path getClip(Size size) {
    double radius = 16.0;
    final path = Path();

    double midX = size.width / 2;
    if (index == 0) {
      path.lineTo(0, radius);
      path.arcToPoint(Offset(radius, 0), radius: Radius.circular(radius));
      path.lineTo(midX - radius, 0);
      path.arcToPoint(Offset(midX, radius), radius: Radius.circular(radius));

      path.lineTo(midX, size.height - radius - 1);
//    path.arcToPoint(Offset(size.width/2+radius,  size.height-1), radius: Radius.circular(radius),);

      Offset offset1 = Offset(midX + 1, size.height - 3);
      Offset offset2 = Offset(midX + 12, size.height - 1);
      path.quadraticBezierTo(offset1.dx, offset1.dy, offset2.dx, offset2.dy);

      path.lineTo(size.width, size.height - 1);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
    } else {
      path.lineTo(midX, radius);
      path.arcToPoint(Offset(midX + radius, 0),
          radius: Radius.circular(radius));
      path.lineTo(size.width - radius, 0);
      path.arcToPoint(Offset(size.width, radius),
          radius: Radius.circular(radius));

//      path.lineTo(size.width, size.height - radius - 1);
//    path.arcToPoint(Offset(size.width/2+radius,  size.height-1), radius: Radius.circular(radius),);

      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.lineTo(0, size.height - 1);
      path.lineTo(midX - 12, size.height - 1);

      Offset offset1 = Offset(midX - 1, size.height - 3);
      Offset offset2 = Offset(midX, size.height - radius - 1);

      path.quadraticBezierTo(offset1.dx, offset1.dy, offset2.dx, offset2.dy);

      path.lineTo(midX, radius);
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(TabShapeClipper oldClipper) => true;
}
