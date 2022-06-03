import 'package:flutter/material.dart';
import 'package:flutter_omok/src/omok/bloc/omok_bloc.dart';

class OmokPainter extends CustomPainter {
  final OmokRender state;

  const OmokPainter(this.state);

  @override
  void paint(Canvas canvas, Size size) {
    final resize = size.aspectRatio < 1
        ? Size(size.width, size.width)
        : Size(size.height, size.height);
    final l = resize.width / (state.gridCount + 1);
    canvas.save();
    canvas.translate(l / 2, l / 2);
    drawGrid(canvas, l * state.gridCount);
    drawWares(canvas, l * state.gridCount);
    drawHover(canvas, l * state.gridCount);
    canvas.restore();
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke;
    canvas.drawRect(Rect.fromLTRB(0, 0, size.width, size.height), paint);
  }

  void drawGrid(Canvas canvas, double w) {
    final l = w / state.gridCount;
    final paint = Paint()..color = Colors.black;
    for (int i = 0; i <= state.gridCount; i++) {
      canvas.drawLine(Offset(0, l * i), Offset(w, l * i), paint);
    }
    for (int i = 0; i <= state.gridCount; i++) {
      canvas.drawLine(Offset(l * i, 0), Offset(l * i, w), paint);
    }
  }

  void drawWares(Canvas canvas, double w) {
    final l = w / state.gridCount;
    final white = Paint()..color = Colors.white;
    final black = Paint()..color = Colors.black;
    final line = Paint()
      ..strokeWidth = 1
      ..color = Colors.black
      ..style = PaintingStyle.stroke;

    for (final ware in state.wares.entries) {
      final c = ware.key.toOffset() * l;
      canvas.drawCircle(c, l * 0.42, ware.value.isWhite ? white : black);
      canvas.drawCircle(c, l * 0.42, line);
    }
  }

  void drawHover(Canvas canvas, double w) {
    final hover = state.hover;
    if (hover != null) {
      final line = Paint()
        ..strokeWidth = 2
        ..color = Colors.green
        ..style = PaintingStyle.stroke;
      final l = w / state.gridCount;
      final c = hover.toOffset() * l;
      canvas.drawCircle(c, l * 0.42, line);
    }
  }

  @override
  bool shouldRepaint(OmokPainter oldDelegate) {
    return state != oldDelegate.state;
  }
}
