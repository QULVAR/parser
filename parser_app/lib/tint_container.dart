import 'package:flutter/material.dart';
import 'package:pki_frontend_app/resizer.dart';

class TintContainer extends StatefulWidget {
  final VoidCallback gestureAction;
  final double width, height;

  const TintContainer ({
    super.key,
    required this.gestureAction,
    required this.height,
    required this.width
  });

  @override
  State<TintContainer> createState() => TintContainerState();
}

class TintContainerState extends State<TintContainer> {

  int _opacity = 0;
  double _left = -390.w;

  void changeOpacity (int opacity) {
    setState(() {
      _opacity = opacity;
    });
  }

  void moveToX (double left) {
    setState(() {
      _left = left;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
            top: 0,
            left: _left,
            child: GestureDetector(
      onTap: widget.gestureAction,
      child: AbsorbPointer(
        absorbing: true,
        child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              height: widget.height,
              width: widget.width,
              decoration: BoxDecoration(
                color: Color.fromARGB(_opacity, 0, 0, 0)
              ),
            ),
      )
          ),
          );
  }

}