import 'package:flutter/material.dart';

class CarAnimatedButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  final Color primaryColor;
  final Color secondaryColor;

  // 👇 Custom params
  final double width;
  final double height;
  final double borderRadius;
  final TextStyle? textStyle;
  final Widget? icon;
  final bool isEnabled;
  final EdgeInsetsGeometry? padding;
  final int time;

  const CarAnimatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.primaryColor = const Color(0xFF6C63FF),
    this.secondaryColor = const Color(0xFF4CAF50),

    this.width = 280,
    this.height = 60,
    this.borderRadius = 30,
    this.textStyle,
    this.icon,
    this.isEnabled = true,
    this.padding,
    this.time = 1000
  });

  @override
  State<CarAnimatedButton> createState() => _CarAnimatedButtonState();
}

class _CarAnimatedButtonState extends State<CarAnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _carPosition;
  late Animation<double> _scale;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: widget.time),
      vsync: this,
    );

    _carPosition = Tween<double>(begin: -0.3, end: 1.3).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _scale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.95)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.95, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 80,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    setState(() => _isPressed = true);
    await _controller.forward(from: 0);
    setState(() => _isPressed = false);
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (!widget.isEnabled || _isPressed) ? null : _handleTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scale.value,
            child: Container(
              width: widget.width,
              height: widget.height,
              padding: widget.padding,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.isEnabled
                      ? [widget.primaryColor, widget.secondaryColor]
                      : [Colors.grey, Colors.grey],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                BorderRadius.circular(widget.borderRadius),
                boxShadow: [
                  if (widget.isEnabled)
                    BoxShadow(
                      color: widget.primaryColor.withOpacity(0.5),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                ],
              ),
              child: ClipRRect(
                borderRadius:
                BorderRadius.circular(widget.borderRadius),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // 🚗 Road animation
                    if (_controller.isAnimating)
                      Positioned.fill(
                        child: CustomPaint(
                          painter: RoadLinesPainter(
                            _carPosition.value,
                          ),
                        ),
                      ),

                    // 🚗 Car icon animation
                    if (_controller.isAnimating)
                      Positioned(
                        left: _carPosition.value * widget.width,
                        child: Transform.rotate(
                          angle: 0.1 *
                              (_controller.value * 180 - 90)
                                  .clamp(-15, 15) *
                              (3.14 / 10),
                          child: const Icon(
                            Icons.two_wheeler,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),

                    // 📝 Content
                    AnimatedOpacity(
                      opacity:
                      _controller.isAnimating ? 0.3 : 1.0,
                      duration:
                      const Duration(milliseconds: 200),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          if (widget.icon != null) ...[
                            widget.icon!,
                            const SizedBox(width: 8),
                          ],
                          Text(
                            widget.text,
                            style: widget.textStyle ??
                                const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// 🚗 Road animation painter
class RoadLinesPainter extends CustomPainter {
  final double progress;

  RoadLinesPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dashWidth = 15.0;
    const dashSpace = 10.0;
    final y = size.height / 2;

    double startX =
        (progress * size.width) % (dashWidth + dashSpace) - dashWidth;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, y),
        Offset(startX + dashWidth, y),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(RoadLinesPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}