import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pki_frontend_app/auth.dart';
import 'package:pki_frontend_app/calendar_pop_up.dart';
import 'package:pki_frontend_app/cart.dart';
import 'package:pki_frontend_app/cart_page_item.dart';
import 'package:pki_frontend_app/date_picker_field.dart';
import 'package:pki_frontend_app/discount_text_field.dart';
import 'package:pki_frontend_app/resizer.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => CartPageState();
}

class CartPageState extends State<CartPage> {
  double _left = 390.w;
  late List<List<String>> userCart;
  double sum = 0;

  void updatePage() {setState(() {});}

  void moveToX (double left) {
    setState(() {
      _left = left;
    });
  }

  @override
  void initState() {
    super.initState();
    userCart = Cart.getCart();
  }

  void getUserCart() {
    setState(() {
      userCart = Cart.getCart();
    });
  }

  String convetationDateToString(DateTime? value) {
    if (value == null) {
      return '';
    }
    return '${value.day}-${value.month}-${value.year}';
  }

  Future<void> buttonPress() async {
    String promocode = (_discountTextFieldKey.currentState?.controller.text ?? '').trim();
    final resp = await Api.I.getCost(
      Cart.getCartRequest(),
      convetationDateToString(_datePickerValue1),
      convetationDateToString(_datePickerValue2),
      promocode
    );
    setState(() {
      sum = resp['result'].toDouble();
    });
    if (resp['promo_status'] == 'promo_404') {
      _discountTextFieldKey.currentState?.showMiniToast("Отсутствует");
    }
  }

  final _datePickerKey1 = GlobalKey<DatePickerFieldState>();
  final _datePickerKey2 = GlobalKey<DatePickerFieldState>();
  final _discountTextFieldKey = GlobalKey<DiscountTextFieldState>();
  DateTime? _datePickerValue1;
  DateTime? _datePickerValue2;
  Color backgroundColorButton = Color(0xFFE6E6E6);
  Color fieldColor = Color(0xFFF5F5F5);
  String calendarIcon = 'calendar_icon';

  void showDateRange(List<DateTime> dateRange) {
    _datePickerKey1.currentState?.showPickedDate(dateRange[0]);
    _datePickerKey2.currentState?.showPickedDate(dateRange[1]);
  }

  void clear() {
    setState(() {
      _datePickerKey1.currentState?.clear();
      _datePickerKey2.currentState?.clear();
      _datePickerValue1 = null;
      _datePickerValue2 = null;
      backgroundColorButton = Color(0xFFE6E6E6);
      fieldColor = Color(0xFFF5F5F5);
      calendarIcon = 'calendar_icon';
    });
  }

  void dateChanged1(DateTime? val) {
    _datePickerValue1 = val;
    buttonColorSelector();
  }

  void dateChanged2(DateTime? val) {
    _datePickerValue2 = val;
    buttonColorSelector();
  }

  void buttonColorSelector() {
    final Color buttonColor;
    final Color fieldColorLocal;
    if (
      _datePickerValue1 != null
      && _datePickerValue2 != null
      && _datePickerValue1!.isBefore(_datePickerValue2!)
    ) {
      fieldColorLocal = Color.fromARGB(50, 0, 158, 58);
      if (Cart.isNotEmpty()) {
        buttonColor = Color.fromARGB(150, 0, 158, 58);
      } else {
        buttonColor = Color(0xFFE6E6E6);
      }
      calendarIcon = 'calendar_icon_green';
    } else {
      buttonColor = Color(0xFFE6E6E6);
      fieldColorLocal = Color(0xFFF5F5F5);
      calendarIcon = 'calendar_icon';
    }
    if (buttonColor != backgroundColorButton) {
      setState(() {
        backgroundColorButton = buttonColor;
      });
    }
    if (fieldColorLocal != fieldColor) {
      setState(() {
        fieldColor = fieldColorLocal;
      });
    }
  }

  void _pickDate() {
    showGeneralDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.2),
      barrierDismissible: true,
      barrierLabel: "Закрыть", 
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, _, __) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: DatePickerCalendar(
            mode: 'range',
            selectedDateRange: [
              _datePickerKey1.currentState?.selectedDate,
              _datePickerKey2.currentState?.selectedDate
            ],
            showDateRange: showDateRange,
          ),
        );
      },
      transitionBuilder: (context, animation, _, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(curved),
          child: FadeTransition(opacity: curved, child: child),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final sorted = List<List<String>>.from(userCart, growable: false)
      ..sort((a, b) {
        final c = a[0].compareTo(b[0]); // категория
        return c != 0 ? c : a[1].compareTo(b[1]); // товар
      });
    List<List<String>> userCartView = [];
    if (sorted.isNotEmpty) {
      var prev = List.of(sorted[0]);
      userCartView.add(List.of(prev));
      userCartView[0].add("1");
      if (sorted.length > 1) {
        for (int index = 1; index < sorted.length; index++) {
          if (listEquals(prev, sorted[index])) {
            userCartView[userCartView.length - 1][3] =
                (int.parse(userCartView[userCartView.length - 1][3]) + 1).toString();
          } else {
            userCartView.add(List.of(sorted[index]));
            userCartView[userCartView.length - 1].add('1');
            prev = List.of(sorted[index]);
          }
        }
      }
    }
    return AnimatedPositioned(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      top: 20,
      left: _left + 20,
      child: Container(
        width: 350.w,
        height: 700.h,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.sp)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: EdgeInsets.only(top: 12.h, bottom: 12.h, right: 14.w),
              height: 48.h,
              width: 342.w,
              decoration: BoxDecoration(
                color: fieldColor,
                borderRadius: BorderRadius.circular(12.sp),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 270.w,
                    height: 48.h,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        DatePickerField(
                          key: _datePickerKey1,
                          onChanged: dateChanged1,
                          right: true,
                        ),
                        Text(
                          ' - ',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 13.sp,
                            height: (20/16),
                            letterSpacing: 0,
                            color: Color(0xFF404040)
                          ),
                        ),
                        DatePickerField(
                          key: _datePickerKey2,
                          onChanged: dateChanged2,
                          right: false,
                        ),
                      ]
                    ),
                  ),
                  SizedBox(
                    width: 24.sp,
                    height: 24.sp,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _pickDate,
                      child: SvgPicture.asset(
                        'assets/icons/$calendarIcon.svg',
                        width: 24.sp,
                        height: 24.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h,),
            Container(
              height: 430.h,
              padding: EdgeInsets.only(left: 15.w),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 335.w,
                      height: 1,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 203, 203, 203)
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: (userCartView as List)
                        .map<Widget>(
                          (item) => CartPageItem(
                            key: ValueKey('${item[0]}|${item[1]}'),
                            item: item,
                            updatePage: updatePage,
                          )
                        ).toList(),
                    ),
                  ],
                ) 
              ),
            ),
            Container(
              height: 57.h,
              padding: EdgeInsets.only(top: 10.h, left: 15.w),
              child:Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Промокод',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                      DiscountTextField(
                        key: _discountTextFieldKey,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Всего: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                      Text(
                        '$sum ₽',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                if (backgroundColorButton == Color.fromARGB(150, 0, 158, 58)) {
                  FocusScope.of(context).unfocus();
                  buttonPress();
                }
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size(342.w, 44.h),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.transparent,
                splashFactory: NoSplash.splashFactory,
              ),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: 342.w,
                height: 44.h,
                padding: EdgeInsets.only(top: 12.h, bottom: 12.h),
                decoration: BoxDecoration(
                  color: backgroundColorButton,
                  borderRadius: BorderRadius.circular(10.sp)
                ),
                child: Text(
                  'Рассчитать',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp,
                    fontStyle: FontStyle.normal,
                    height: 1.25,
                    letterSpacing: 0.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}