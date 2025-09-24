import 'package:flutter/material.dart';

class HeartButton extends StatefulWidget {
  final bool isLiked;
  final VoidCallback onLike;

  const HeartButton({Key? key, required this.isLiked, required this.onLike}) : super(key: key);

  @override
  _HeartButtonState createState() => _HeartButtonState();
}

class _HeartButtonState extends State<HeartButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    // Define scale animation
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3)
        .chain(CurveTween(curve: Curves.elasticOut))
        .animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!_controller.isAnimating) {
      _controller.forward().then((_) => _controller.reverse()).then((_) => widget.onLike());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Icon(
              widget.isLiked ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
              color: widget.isLiked ? Colors.red : Colors.grey,
              // size: 30,
            ),
          );
        },
      ),
    );
  }
}
