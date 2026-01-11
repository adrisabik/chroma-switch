import 'dart:ui';

/// Creates a Paint with neon glow effect using MaskFilter.blur
///
/// This is the core visual effect for the "Cyberpunk Zen" aesthetic.
/// All colored game elements MUST use this paint configuration.
///
/// Parameters:
/// - [color]: The neon color to use
/// - [fill]: If true, fills the shape; if false, strokes it
/// - [strokeWidth]: Width of the stroke (only applies when fill is false)
/// - [blurRadius]: Intensity of the glow effect
Paint getNeonPaint(
  Color color, {
  bool fill = false,
  double strokeWidth = 4.0,
  double blurRadius = 6.0,
}) {
  return Paint()
    ..color = color
    ..style = fill ? PaintingStyle.fill : PaintingStyle.stroke
    ..strokeWidth = strokeWidth
    ..maskFilter = MaskFilter.blur(BlurStyle.outer, blurRadius);
}

/// Creates a solid fill Paint without glow (for inner core of objects)
Paint getCorePaint(Color color) {
  return Paint()
    ..color = color
    ..style = PaintingStyle.fill;
}
