import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'resizer.dart';


class DatePickerField extends StatefulWidget {
  final void Function(DateTime?) onChanged;
  final bool right;

  const DatePickerField({
    super.key,
    required this.onChanged,
    required this.right
  });

  @override
  DatePickerFieldState createState() => DatePickerFieldState();
}

class DatePickerFieldState extends State<DatePickerField> {
  final TextEditingController _controller = TextEditingController();
  final _dateFormatter = MaskTextInputFormatter(
    mask: '##.##.#### ##:##',
    filter: { "#": RegExp(r'\d') },
  );
  DateTime? selectedDate;
  bool filledField = false;
  double _textWidth = 0.0;
  double _hintWidth = 0.0;

  double _measureTextWidth(String text, TextStyle style, TextDirection td) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: td,
      maxLines: 1,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return tp.size.width;
  }

  void _recalcMetrics() {
    final style = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 13.sp,
      height: (20/16),
      letterSpacing: 0,
      color: Color(0xFF404040)
    );
    final td = widget.right ? TextDirection.rtl : TextDirection.ltr;

    final text = _controller.text;
    _textWidth = _measureTextWidth(text, style, td);
  }

  void _recalcHintWidth() {
    final style = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 13.sp,
      height: (20/16),
      letterSpacing: 0,
      color: Color(0xFFA7A7A7)
    );
    final td = widget.right ? TextDirection.rtl : TextDirection.ltr;
    _hintWidth = _measureTextWidth('дд.мм.гггг чч:мм', style, td);
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final digitsOnly = _dateFormatter.getUnmaskedText();
      setState(() {
        filledField = digitsOnly != '';
      });
      final maskedDateTime = _dateFormatter.getMaskedText();
      final maskedDateTimeSplitted = maskedDateTime.split(' ');
      final maskedDateSplitted = maskedDateTimeSplitted[0].split('.');
      late final List<String> maskedTimeSplitted;
      try {
        maskedTimeSplitted = maskedDateTimeSplitted[1].split(':');
      } catch (_) {
        maskedTimeSplitted = [];
      }
      bool flag = false;
      if (maskedDateSplitted.isNotEmpty) {
        // ignore: prefer_is_empty
        if ((maskedDateSplitted.length >= 1)
          && (maskedDateSplitted[0].length == 2)
          && (int.parse(maskedDateSplitted[0]) > 31)) {
          maskedDateSplitted[0] = '31';
          flag = true;
        } else if ((maskedDateSplitted.length >= 2)
                && (maskedDateSplitted[1].length == 2)
                && (int.parse(maskedDateSplitted[1]) > 12)) {
          maskedDateSplitted[1] = '12';
          flag = true;
        } else if ((maskedDateSplitted.length == 3)
                && (maskedDateSplitted[2].length == 4)
                && (int.parse(maskedDateSplitted[2]) < 1970)) {
          maskedDateSplitted[2] = '1970';
          flag = true;
          //ignore: prefer_is_empty
        } else if ((maskedTimeSplitted.length >= 1)
                && (maskedTimeSplitted[0].length == 2)
                && (int.parse(maskedTimeSplitted[0]) > 23)) {
          maskedTimeSplitted[0] = '23';
          flag = true;
        } else if ((maskedTimeSplitted.length == 2)
                && (maskedTimeSplitted[1].length == 2)
                && (int.parse(maskedTimeSplitted[1]) > 59)) {
          maskedTimeSplitted[1] = '59';
          flag = true;
        } else {
          if (digitsOnly.length == 12) {
            DateTime? candidate = DateTime(
              int.parse(maskedDateSplitted[2]),
              int.parse(maskedDateSplitted[1]),
              int.parse(maskedDateSplitted[0]),
              int.parse(maskedTimeSplitted[0]),
              int.parse(maskedTimeSplitted[1])
            );
            if (candidate.isAfter(DateTime.now())) {
              candidate = DateTime.now();
            }
            if (!(candidate.year == int.parse(maskedDateSplitted[2])
                && candidate.month == int.parse(maskedDateSplitted[1])
                && candidate.day == int.parse(maskedDateSplitted[0])
                && candidate.hour == int.parse(maskedTimeSplitted[0])
                && candidate.minute == int.parse(maskedTimeSplitted[1]))) {
              flag = true;
              maskedDateSplitted[2] = '${candidate.year}';
              maskedDateSplitted[1] = candidate.month.toString().padLeft(2, '0');
              maskedDateSplitted[0] = candidate.day.toString().padLeft(2, '0');
              maskedTimeSplitted[0] = candidate.hour.toString().padLeft(2, '0');
              maskedTimeSplitted[1] = candidate.minute.toString().padLeft(2, '0');
            }
            setState(() {
              widget.onChanged(candidate);
              selectedDate = candidate;
            });
          } else {
            setState(() {
              widget.onChanged(null);
              selectedDate = null;
            });
          }
        }
      }
      if (flag) {
        final newText = '${maskedDateSplitted.join('.')} ${maskedTimeSplitted.join(':')}';
        _dateFormatter.clear(); 
        final formatted = _dateFormatter.formatEditUpdate(
          TextEditingValue.empty,
          TextEditingValue(text: newText),
        );
        _controller.value = formatted;
      }
      _recalcMetrics();
    });
    _recalcHintWidth();
    WidgetsBinding.instance.addPostFrameCallback((_) => _recalcMetrics());
  }

  @override
  void didUpdateWidget(covariant DatePickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.right != widget.right) {
      _recalcHintWidth();
      WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
    }
  }

  void clear() {
    setState(() {
      selectedDate = null;
      widget.onChanged(null);
      _dateFormatter.clear();
      _controller.clear();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void showPickedDate(DateTime value) {
    String newText = '';
    newText += value.day.toString().padLeft(2, '0');
    newText += '.';
    newText += value.month.toString().padLeft(2, '0');
    newText += '.';
    newText += '${value.year}';
    newText += ' ';
    newText += value.hour.toString().padLeft(2, '0');
    newText += ':';
    newText += value.minute.toString().padLeft(2, '0');
    _dateFormatter.clear(); 
    final formatted = _dateFormatter.formatEditUpdate(
      TextEditingValue.empty,
      TextEditingValue(text: newText),
    );
    _controller.value = formatted;
  }


  @override
  Widget build(BuildContext context) {
    late final double targetWidth;
    if ((_textWidth > 0) && (_textWidth <= 94.sp)) {
      targetWidth = 94.sp;
    } else if (_textWidth > 94.sp) {
      targetWidth = _textWidth + 2.sp;
    }
    else {
      targetWidth = _hintWidth;
    }
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
      width: targetWidth,
      height: 48.h,
      alignment: Alignment.center,
      child: TextField(
        keyboardType: TextInputType.number,
        controller: _controller,
        inputFormatters: [_dateFormatter],
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'дд.мм.гггг чч:мм',
          hintStyle: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 13.sp,
            height: (20/16),
            letterSpacing: 0,
            color: Color(0xFFA7A7A7)
          ),
          hintFadeDuration: Duration(milliseconds: 300),
          hintTextDirection: widget.right ? TextDirection.rtl : TextDirection.ltr,
          isCollapsed: true,
          contentPadding: EdgeInsets.zero,
        ),
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 13.sp,
          height: (20/16),
          letterSpacing: 0,
          color: Color(0xFF404040)
        ),
      )
    );
  }
}
