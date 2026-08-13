// lib/ui/components/pull_refresh/cloth_pull_refresh.dart
//
// Custom "pull to refresh" interaction: hand drops in from the top,
// content sags like fabric as you drag, springs back with a bounce,
// shows a small loading dot while refreshing.
//
// This does NOT use Flutter's built-in RefreshIndicator — wrap any
// scrollable widget (SingleChildScrollView, ListView, CustomScrollView...)
// with ClothPullRefresh and give that scrollable ClampingScrollPhysics.
//
// For the soft 3D hand from your reference video, swap _HandIcon for a
// Rive or Lottie asset and drive its progress with `_dragFraction`.

import 'dart:math' as math;
import 'package:flutter/material.dart';

class ClothPullRefresh extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final double triggerDistance;
  final Color handColor;

  const ClothPullRefresh({
    super.key,
    required this.child,
    required this.onRefresh,
    this.triggerDistance = 120,
    this.handColor = const Color(0xFFF2B9A8),
  });

  @override
  State<ClothPullRefresh> createState() => _ClothPullRefreshState();
}

class _ClothPullRefreshState extends State<ClothPullRefresh>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  double _dragOffset = 0;
  bool _dragging = false;
  bool _refreshing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _controller.addListener(() {
      setState(() => _dragOffset = _controller.value);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get _dragFraction =>
      (_dragOffset / widget.triggerDistance).clamp(0.0, 1.0);

  bool _handleScrollNotification(ScrollNotification notification) {
    if (_refreshing) return false;

    final metrics = notification.metrics;
    final atTop = metrics.pixels <= metrics.minScrollExtent;

    if (notification is ScrollUpdateNotification &&
        notification.dragDetails != null) {
      if (atTop && notification.dragDetails!.primaryDelta! > 0) {
        _dragging = true;
        setState(() {
          _dragOffset = math.max(
            0,
            _dragOffset + notification.dragDetails!.primaryDelta! * 0.55,
          );
        });
      }
    } else if (notification is OverscrollNotification) {
      if (atTop && notification.overscroll < 0) {
        _dragging = true;
        setState(() {
          _dragOffset = math.max(
            0,
            _dragOffset - notification.overscroll * 0.55,
          );
        });
      }
    } else if (notification is ScrollEndNotification) {
      if (_dragging) {
        _dragging = false;
        _onRelease();
      }
    }
    return false;
  }

  Future<void> _onRelease() async {
    if (_dragOffset >= widget.triggerDistance) {
      setState(() => _refreshing = true);
      await widget.onRefresh();
      setState(() => _refreshing = false);
    }
    _controller.value = _dragOffset;
    await _controller.animateTo(
      0,
      curve: Curves.elasticOut,
      duration: const Duration(milliseconds: 700),
    );
    _dragOffset = 0;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: Stack(
        children: [
          Transform.translate(
            offset: Offset(0, _dragOffset),
            child: ClipPath(
              clipper: _ClothSagClipper(sag: _dragOffset),
              child: widget.child,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: SizedBox(
                height: math.max(_dragOffset, 0),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    if (!_refreshing)
                      Opacity(
                        opacity: _dragFraction.clamp(0.0, 1.0),
                        child: Transform.translate(
                          offset: Offset(0, -40 * (1 - _dragFraction)),
                          child: _HandIcon(
                            pull: _dragFraction,
                            color: widget.handColor,
                          ),
                        ),
                      ),
                    if (_refreshing)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2.4),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClothSagClipper extends CustomClipper<Path> {
  final double sag;

  _ClothSagClipper({required this.sag});

  @override
  Path getClip(Size size) {
    final path = Path();
    if (sag <= 0) {
      path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));
      return path;
    }

    path.moveTo(0, 0);
    const segments = 3;
    final segWidth = size.width / segments;
    for (int i = 0; i < segments; i++) {
      final foldHeight = sag * (i == 1 ? 0.28 : 0.14);
      final x1 = segWidth * i + segWidth * 0.5;
      final x2 = segWidth * (i + 1);
      path.quadraticBezierTo(x1, -foldHeight, x2, 0);
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant _ClothSagClipper oldClipper) =>
      oldClipper.sag != sag;
}

class _HandIcon extends StatelessWidget {
  final double pull;
  final Color color;

  const _HandIcon({required this.pull, required this.color});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.15 + (0.15 * pull),
      child: Icon(
        Icons.back_hand_rounded,
        size: 40 + (10 * pull),
        color: color,
      ),
    );
  }
}
