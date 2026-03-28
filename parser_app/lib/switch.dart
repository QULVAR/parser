import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Switcher extends StatefulWidget {
  final Function onPress;
  final double height;
  final double width;
  final bool isOn;
  final String animationName;

  Switcher({
    super.key,
    required this.onPress,
    required this.height,
    required this.width,
    required this.animationName,
    this.isOn = false
  });

  @override
  State<Switcher> createState() => SwitcherState();
}

class SwitcherState extends State<Switcher> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  bool isOn = false;
  late String lottieAnimationAsset;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this);
    isOn = widget.isOn;
    lottieAnimationAsset = 'assets/animations/${widget.animationName}.json';
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Future<void> _onPressed() async {
    if (_c.isAnimating) return;
    if (_c.duration == null) return;

    widget.onPress(isOn);

    final target = isOn ? 0.0 : 1.0;
    final curve = target > _c.value
        ? Curves.easeOutCubic
        : Curves.easeInCubic;

    await _c.animateTo(
      target,
      duration: _c.duration,
      curve: curve,
    );

    if (!mounted) return;
    setState(() => isOn = !isOn);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _onPressed,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      icon: Lottie.asset(
        lottieAnimationAsset,
        height: widget.height,
        width: widget.width,
        controller: _c,
        animate: false,
        repeat: false,
        onLoaded: (comp) {
          _c.duration = comp.duration * 0.25;
          _c.value = isOn ? 1.0 : 0.0;
        },
        options: LottieOptions(enableMergePaths: true),
      ),
    );
  }
}