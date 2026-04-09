import 'dart:math' as math;
import 'package:flutter/material.dart';

enum AppIconData {
  home, lessons, leaderboard, profile,
  notification, search, back, forward,
  check, lock, play, star, bolt,
  microscope, tech, flower, leaf, fibonacci,
  timer, trophy, book, certificate,
  email, school, calendar, logout, edit,
  info, warning, successCheck, gear,
}

class AppIcon extends StatelessWidget {
  final AppIconData data;
  final double size;
  final Color? color;

  const AppIcon(this.data, {super.key, this.size = 22, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? IconTheme.of(context).color ?? Colors.black;
    return SizedBox(
      width: size, height: size,
      child: CustomPaint(painter: _IconPainter(data, c, size)),
    );
  }
}

class _IconPainter extends CustomPainter {
  final AppIconData icon;
  final Color color;
  final double size;
  _IconPainter(this.icon, this.color, this.size);

  double s(double v) => v / 22 * size;
  double get sw => size * 0.08;

  Paint stroke({double? width, Color? c}) => Paint()
    ..color = c ?? color
    ..style = PaintingStyle.stroke
    ..strokeWidth = width ?? sw
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  Paint fill({Color? c}) => Paint()
    ..color = c ?? color
    ..style = PaintingStyle.fill;

  Offset polar(double cx, double cy, double r, double deg) {
    final rad = deg * math.pi / 180;
    return Offset(cx + r * math.cos(rad), cy + r * math.sin(rad));
  }

  Path starPath(double cx, double cy, double outer, double inner, int points) {
    final p = Path();
    for (int i = 0; i < points; i++) {
      final o = polar(cx, cy, outer, i * 360 / points - 90);
      final inn = polar(cx, cy, inner, i * 360 / points + 180 / points - 90);
      if (i == 0) p.moveTo(o.dx, o.dy); else p.lineTo(o.dx, o.dy);
      p.lineTo(inn.dx, inn.dy);
    }
    return p..close();
  }

  @override
  void paint(Canvas canvas, Size sz) {
    switch (icon) {

      case AppIconData.home:
        canvas.drawPath(Path()
          ..moveTo(s(3), s(10.5))
          ..lineTo(s(11), s(3))
          ..lineTo(s(19), s(10.5))
          ..lineTo(s(19), s(20))
          ..lineTo(s(14.5), s(20))
          ..lineTo(s(14.5), s(14.5))
          ..arcToPoint(Offset(s(13.5), s(13.5)), radius: Radius.circular(s(1)))
          ..lineTo(s(8.5), s(13.5))
          ..arcToPoint(Offset(s(7.5), s(14.5)), radius: Radius.circular(s(1)))
          ..lineTo(s(7.5), s(20))
          ..lineTo(s(3), s(20))
          ..close(), stroke());

      case AppIconData.lessons:
        canvas.drawPath(Path()
          ..moveTo(s(4.5), s(4))
          ..lineTo(s(4.5), s(19))
          ..arcToPoint(Offset(s(5.5), s(20)), radius: Radius.circular(s(1)))
          ..lineTo(s(10), s(20))
          ..lineTo(s(10), s(5))
          ..arcToPoint(Offset(s(9), s(4)), radius: Radius.circular(s(1)))
          ..close(), stroke());
        canvas.drawPath(Path()
          ..moveTo(s(11), s(5.5))
          ..lineTo(s(17.5), s(4))
          ..arcToPoint(Offset(s(18.5), s(5)), radius: Radius.circular(s(1)))
          ..lineTo(s(18.5), s(19.5))
          ..arcToPoint(Offset(s(17.5), s(20.5)), radius: Radius.circular(s(1)))
          ..lineTo(s(11), s(19))
          ..close(), stroke());

      case AppIconData.leaderboard:
        for (final r in [
          Rect.fromLTWH(s(2), s(14), s(4.5), s(6.5)),
          Rect.fromLTWH(s(8.75), s(9), s(4.5), s(11.5)),
          Rect.fromLTWH(s(15.5), s(4), s(4.5), s(16.5)),
        ]) {
          canvas.drawRRect(RRect.fromRectAndRadius(r, Radius.circular(s(1.2))), stroke());
        }
        canvas.drawPath(Path()
          ..moveTo(s(4.25), s(9))
          ..lineTo(s(9.5), s(5.5))
          ..lineTo(s(13.5), s(7.5))
          ..lineTo(s(17.75), s(2.5)), stroke(width: sw * 0.85));
        canvas.drawPath(Path()
          ..moveTo(s(15.5), s(2.5))
          ..lineTo(s(17.75), s(2.5))
          ..lineTo(s(17.75), s(4.5)), stroke(width: sw * 0.85));

      case AppIconData.profile:
        canvas.drawCircle(Offset(s(11), s(7.5)), s(3.8), stroke());
        canvas.drawPath(Path()
          ..moveTo(s(3.5), s(20.5))
          ..cubicTo(s(3.5), s(15.5), s(7), s(13), s(11), s(13))
          ..cubicTo(s(15), s(13), s(18.5), s(15.5), s(18.5), s(20.5)),
          stroke());

      case AppIconData.notification:
        canvas.drawPath(Path()
          ..moveTo(s(11), s(3))
          ..cubicTo(s(11), s(2), s(9), s(2), s(9), s(3))
          ..cubicTo(s(5.5), s(4), s(4.5), s(7), s(4.5), s(9.5))
          ..lineTo(s(4.5), s(15.5))
          ..lineTo(s(2.5), s(17.5))
          ..lineTo(s(19.5), s(17.5))
          ..lineTo(s(17.5), s(15.5))
          ..lineTo(s(17.5), s(9.5))
          ..cubicTo(s(17.5), s(7), s(16.5), s(4), s(13), s(3))
          ..cubicTo(s(13), s(2), s(11), s(2), s(11), s(3)), stroke());
        canvas.drawArc(
          Rect.fromCenter(center: Offset(s(11), s(19.5)), width: s(4), height: s(3.5)),
          0, math.pi, false, stroke());

      case AppIconData.search:
        canvas.drawCircle(Offset(s(9.5), s(9.5)), s(5.5), stroke());
        canvas.drawLine(Offset(s(13.5), s(13.5)), Offset(s(19.5), s(19.5)), stroke());

      case AppIconData.back:
        canvas.drawPath(Path()
          ..moveTo(s(14.5), s(4))
          ..lineTo(s(7), s(11))
          ..lineTo(s(14.5), s(18)), stroke());

      case AppIconData.forward:
        canvas.drawPath(Path()
          ..moveTo(s(7.5), s(4))
          ..lineTo(s(15), s(11))
          ..lineTo(s(7.5), s(18)), stroke());

      case AppIconData.check:
        canvas.drawPath(Path()
          ..moveTo(s(3.5), s(11.5))
          ..lineTo(s(9), s(17))
          ..lineTo(s(18.5), s(5.5)), stroke(width: sw * 1.2));

      case AppIconData.lock:
        canvas.drawRRect(
          RRect.fromRectAndRadius(Rect.fromLTWH(s(4), s(10.5), s(14), s(10)), Radius.circular(s(2.5))),
          stroke());
        canvas.drawPath(Path()
          ..moveTo(s(7), s(10.5))
          ..lineTo(s(7), s(7.5))
          ..arcToPoint(Offset(s(15), s(7.5)), radius: Radius.circular(s(4)), clockwise: false)
          ..lineTo(s(15), s(10.5)), stroke());
        canvas.drawCircle(Offset(s(11), s(16.5)), s(1.8), fill());

      case AppIconData.play:
        canvas.drawPath(Path()
          ..moveTo(s(6), s(4))
          ..lineTo(s(18.5), s(11))
          ..lineTo(s(6), s(18))
          ..close(), fill());

      case AppIconData.star:
        canvas.drawPath(starPath(s(11), s(11), s(9), s(4), 5), fill());

      case AppIconData.bolt:
        canvas.drawPath(Path()
          ..moveTo(s(13.5), s(2))
          ..lineTo(s(5), s(12))
          ..lineTo(s(11), s(12))
          ..lineTo(s(8.5), s(20))
          ..lineTo(s(17), s(10))
          ..lineTo(s(11), s(10))
          ..close(), fill());

      case AppIconData.microscope:
        canvas.drawCircle(Offset(s(11), s(9)), s(5.5), stroke());
        canvas.drawCircle(Offset(s(11), s(9)), s(2.8), stroke(width: sw * 0.7));
        canvas.drawLine(Offset(s(11), s(14.5)), Offset(s(11), s(19)), stroke());
        canvas.drawLine(Offset(s(7.5), s(19)), Offset(s(14.5), s(19)), stroke());
        canvas.drawLine(Offset(s(8.5), s(19)), Offset(s(8.5), s(21)), stroke());
        canvas.drawLine(Offset(s(13.5), s(19)), Offset(s(13.5), s(21)), stroke());
        canvas.drawCircle(Offset(s(18), s(5.5)), s(2.2), stroke());
        canvas.drawLine(Offset(s(15.8), s(6.8)), Offset(s(14.5), s(7.5)), stroke(width: sw * 0.7));

      case AppIconData.tech:
        canvas.drawRRect(
          RRect.fromRectAndRadius(Rect.fromLTWH(s(2), s(3), s(18), s(13)), Radius.circular(s(2))),
          stroke());
        canvas.drawLine(Offset(s(7), s(20)), Offset(s(15), s(20)), stroke());
        canvas.drawLine(Offset(s(11), s(16)), Offset(s(11), s(20)), stroke());

      case AppIconData.flower:
        canvas.drawCircle(Offset(s(11), s(11)), s(3.5), stroke());
        for (int i = 0; i < 6; i++) {
          final c2 = polar(s(11), s(11), s(5.5), i * 60 - 90);
          canvas.drawOval(
            Rect.fromCenter(center: c2, width: s(4.5), height: s(5.5)),
            stroke(c: color.withValues(alpha: 0.65)));
        }

      case AppIconData.leaf:
        canvas.drawPath(Path()
          ..moveTo(s(11), s(21))
          ..cubicTo(s(4.5), s(15.5), s(5), s(8), s(11), s(4.5))
          ..cubicTo(s(17), s(8), s(17.5), s(15.5), s(11), s(21)), stroke());
        canvas.drawLine(Offset(s(11), s(21)), Offset(s(11), s(12)), stroke(width: sw * 0.75));
        canvas.drawLine(Offset(s(11), s(13.5)), Offset(s(8.5), s(16)), stroke(width: sw * 0.65));
        canvas.drawLine(Offset(s(11), s(16)), Offset(s(13.5), s(18.5)), stroke(width: sw * 0.65));

      case AppIconData.fibonacci:
        canvas.drawPath(Path()
          ..moveTo(s(11), s(11))
          ..cubicTo(s(11), s(5.5), s(17), s(5.5), s(17), s(11))
          ..cubicTo(s(17), s(18), s(7.5), s(19), s(5.5), s(13.5))
          ..cubicTo(s(4.5), s(8), s(8.5), s(4.5), s(14), s(4.5))
          ..cubicTo(s(19.5), s(4.5), s(20.5), s(9.5), s(20.5), s(13)),
          stroke(width: sw * 0.75));
        canvas.drawCircle(Offset(s(11), s(11)), s(1.3), fill());

      case AppIconData.timer:
        canvas.drawCircle(Offset(s(11), s(12.5)), s(8), stroke());
        canvas.drawLine(Offset(s(11), s(12.5)), Offset(s(11), s(8)), stroke(width: sw * 1.1));
        canvas.drawLine(Offset(s(11), s(12.5)), Offset(s(15), s(14.5)), stroke(width: sw * 0.95));
        canvas.drawLine(Offset(s(8), s(3)), Offset(s(14), s(3)), stroke());
        canvas.drawLine(Offset(s(11), s(3)), Offset(s(11), s(4.5)), stroke());

      case AppIconData.trophy:
        canvas.drawPath(Path()
          ..moveTo(s(5), s(3))
          ..lineTo(s(17), s(3))
          ..lineTo(s(15.5), s(10))
          ..cubicTo(s(14.5), s(14.5), s(11), s(15.5), s(11), s(15.5))
          ..cubicTo(s(11), s(15.5), s(7.5), s(14.5), s(6.5), s(10))
          ..close(), stroke());
        canvas.drawLine(Offset(s(11), s(15.5)), Offset(s(11), s(19)), stroke());
        canvas.drawLine(Offset(s(7.5), s(19)), Offset(s(14.5), s(19)), stroke());
        canvas.drawLine(Offset(s(6), s(21)), Offset(s(16), s(21)), stroke());
        canvas.drawArc(Rect.fromLTWH(s(1.5), s(4), s(4), s(6)), -0.7, 1.4, false, stroke());
        canvas.drawArc(Rect.fromLTWH(s(16.5), s(4), s(4), s(6)), 1.95, 1.4, false, stroke());

      case AppIconData.book:
        canvas.drawPath(Path()
          ..moveTo(s(5), s(3))
          ..lineTo(s(5), s(19.5))
          ..arcToPoint(Offset(s(6.5), s(21)), radius: Radius.circular(s(1.5)))
          ..lineTo(s(18), s(21))
          ..arcToPoint(Offset(s(19), s(20)), radius: Radius.circular(s(1)))
          ..lineTo(s(19), s(4))
          ..arcToPoint(Offset(s(18), s(3)), radius: Radius.circular(s(1)))
          ..close(), stroke());
        canvas.drawLine(Offset(s(8.5), s(8.5)), Offset(s(15.5), s(8.5)), stroke(width: sw * 0.7));
        canvas.drawLine(Offset(s(8.5), s(12)), Offset(s(15.5), s(12)), stroke(width: sw * 0.7));
        canvas.drawLine(Offset(s(8.5), s(15.5)), Offset(s(13), s(15.5)), stroke(width: sw * 0.7));

      case AppIconData.certificate:
        canvas.drawCircle(Offset(s(11), s(8.5)), s(5.5), stroke());
        canvas.drawLine(Offset(s(8.5), s(13.5)), Offset(s(5.5), s(21.5)), stroke());
        canvas.drawLine(Offset(s(13.5), s(13.5)), Offset(s(16.5), s(21.5)), stroke());
        canvas.drawLine(Offset(s(8.5), s(21.5)), Offset(s(11), s(17.5)), stroke());
        canvas.drawLine(Offset(s(13.5), s(21.5)), Offset(s(11), s(17.5)), stroke());
        canvas.drawPath(starPath(s(11), s(8.5), s(3.3), s(1.5), 5),
            fill(c: color.withValues(alpha: 0.55)));

      case AppIconData.email:
        canvas.drawRRect(
          RRect.fromRectAndRadius(Rect.fromLTWH(s(2), s(5), s(18), s(14)), Radius.circular(s(2.5))),
          stroke());
        canvas.drawPath(Path()..moveTo(s(2), s(7))..lineTo(s(11), s(13.5))..lineTo(s(20), s(7),),
          stroke(width: sw * 0.75));

      case AppIconData.school:
        canvas.drawPath(Path()
          ..moveTo(s(11), s(2))
          ..lineTo(s(21), s(7.5))
          ..lineTo(s(1), s(7.5))
          ..close(), stroke());
        canvas.drawRect(Rect.fromLTWH(s(3.5), s(7.5), s(15), s(12.5)), stroke());
        canvas.drawRect(Rect.fromLTWH(s(8.5), s(13), s(5.5), s(7)), stroke());
        canvas.drawLine(Offset(s(11), s(2)), Offset(s(11), s(4.5)), stroke());

      case AppIconData.calendar:
        canvas.drawRRect(
          RRect.fromRectAndRadius(Rect.fromLTWH(s(2.5), s(4.5), s(17), s(16)), Radius.circular(s(2.5))),
          stroke());
        canvas.drawLine(Offset(s(2.5), s(9.5)), Offset(s(19.5), s(9.5)), stroke(width: sw * 0.75));
        for (final x in [s(7.5), s(14.5)]) {
          canvas.drawLine(Offset(x, s(2.5)), Offset(x, s(7)), stroke());
        }

      case AppIconData.logout:
        canvas.drawLine(Offset(s(10.5), s(11)), Offset(s(20.5), s(11)), stroke());
        canvas.drawPath(Path()
          ..moveTo(s(16), s(7))
          ..lineTo(s(20.5), s(11))
          ..lineTo(s(16), s(15)), stroke());
        canvas.drawPath(Path()
          ..moveTo(s(13), s(4.5))
          ..lineTo(s(4.5), s(4.5))
          ..arcToPoint(Offset(s(3.5), s(5.5)), radius: Radius.circular(s(1)))
          ..lineTo(s(3.5), s(17.5))
          ..arcToPoint(Offset(s(4.5), s(18.5)), radius: Radius.circular(s(1)))
          ..lineTo(s(13), s(18.5)), stroke());

      case AppIconData.edit:
        canvas.drawPath(Path()
          ..moveTo(s(15), s(3))
          ..lineTo(s(19), s(7))
          ..lineTo(s(8), s(18))
          ..lineTo(s(4), s(18))
          ..lineTo(s(4), s(14))
          ..close(), stroke());
        canvas.drawLine(Offset(s(4), s(21)), Offset(s(20), s(21)), stroke(width: sw * 0.7));

      case AppIconData.info:
        canvas.drawCircle(Offset(s(11), s(11)), s(9.5), stroke());
        canvas.drawCircle(Offset(s(11), s(7.5)), s(1.1), fill());
        canvas.drawLine(Offset(s(11), s(10.5)), Offset(s(11), s(16.5)), stroke(width: sw * 1.1));

      case AppIconData.warning:
        canvas.drawPath(Path()
          ..moveTo(s(11), s(1.5))
          ..lineTo(s(21.5), s(21))
          ..lineTo(s(0.5), s(21))
          ..close(), stroke());
        canvas.drawCircle(Offset(s(11), s(17.5)), s(1.1), fill());
        canvas.drawLine(Offset(s(11), s(8)), Offset(s(11), s(14.5)), stroke(width: sw * 1.1));

      case AppIconData.successCheck:
        canvas.drawCircle(Offset(s(11), s(11)), s(9.5), stroke());
        canvas.drawPath(Path()
          ..moveTo(s(5.5), s(11.5))
          ..lineTo(s(9.5), s(15.5))
          ..lineTo(s(16.5), s(7)), stroke(width: sw * 1.1));

      case AppIconData.gear:
        final gearPts = <Offset>[];
        for (int i = 0; i < 8; i++) {
          gearPts.add(polar(s(11), s(11), s(9), i * 45 - 90));
          gearPts.add(polar(s(11), s(11), s(6.5), i * 45 + 22 - 90));
        }
        final gp = Path()..moveTo(gearPts[0].dx, gearPts[0].dy);
        for (final pt in gearPts.skip(1)) gp.lineTo(pt.dx, pt.dy);
        gp.close();
        canvas.drawPath(gp, stroke());
        canvas.drawCircle(Offset(s(11), s(11)), s(3), stroke());
    }
  }

  @override
  bool shouldRepaint(_IconPainter o) =>
      o.icon != icon || o.color != color || o.size != size;
}
