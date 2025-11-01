import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pki_frontend_app/resizer.dart';


class DiscountTextField extends StatefulWidget {

  const DiscountTextField({super.key});

  @override
  State<DiscountTextField> createState() => DiscountTextFieldState();

}

class DiscountTextFieldState extends State<DiscountTextField> with TickerProviderStateMixin {

  void showMiniToast(String message, {Duration duration = const Duration(seconds: 2)}) {
    final overlay = Overlay.of(context);
    final renderObject = _anchorKey.currentContext?.findRenderObject();
    if (renderObject is! RenderBox) return;
    final box = renderObject;
    final origin = box.localToGlobal(Offset.zero);
    final size = box.size;
    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      reverseDuration: const Duration(milliseconds: 150),
      value: 0,
    );
    final animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );

    final entry = OverlayEntry(
      builder: (_) => Positioned(
        left: origin.dx,
        top: origin.dy,
        width: size.width,
        height: size.height,
        child: FadeTransition(
          opacity: animation,
          child: Material(
            elevation: 0,
            shadowColor: Colors.transparent,
            color: const Color(0xFFBCBCBC),
            borderRadius: BorderRadius.circular(5.sp),
            child: Center(
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15.sp, color: const Color(0xFF585858)),
              ),
            ),
          ),
        ),
      ),
    );
    overlay.insert(entry);
    controller.forward();
    Future.delayed(duration, () async {
      try {
        await controller.reverse();
      } finally {
        controller.dispose();
        entry.remove();
      }
    });
  }

  final TextEditingController controller = TextEditingController();
  final GlobalKey _anchorKey = GlobalKey();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.sp),
        color: Color(0xFFBCBCBC)
      ),
      width: 100.w,
      height: 20.h,
      child: KeyedSubtree(
        key: _anchorKey,
        child: SizedBox.expand(
          child: TextField(
            keyboardType: TextInputType.text,
            controller: controller,
            inputFormatters: [
              LengthLimitingTextInputFormatter(9)
            ],
            maxLines: 1,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Промокод',
              hintStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 15.sp,
                letterSpacing: 0,
                color: Color(0xFF929292)
              ),
              hintFadeDuration: Duration(milliseconds: 300),
            ),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15.sp,
              color: Color(0xFF585858)
            ),
          ),
        ),
      ),
    );
  }
}