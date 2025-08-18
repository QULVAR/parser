import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

import 'calendar_time_pop_up.dart';
import 'resizer.dart';
import 'text_styles.dart';


class DatePickerCalendar extends StatefulWidget {
  final DateTime startDate;
  final String mode;
  final void Function(DateTime) showDateSingle;
  final DateTime? selectedDateSingle;
  final Function(List<DateTime>) showDateRange;
  final PickerDateRange? selectedDateRange;

  DatePickerCalendar({
    super.key,
    DateTime? startDate,
    String? mode,
    this.selectedDateSingle,
    void Function(DateTime)? showDateSingle,
    void Function(List<DateTime>)? showDateRange,
    List<DateTime?>? selectedDateRange
  }):
  startDate = startDate ?? DateTime.now(),
  mode = mode ?? 'single',
  showDateSingle = showDateSingle ?? ((_) {}),
  showDateRange = showDateRange ?? ((_) {}),
  selectedDateRange = selectedDateRange != null
                    ? PickerDateRange(
                      selectedDateRange[0],
                      selectedDateRange[1]
                    )
                    : null;


  @override
  DatePickerCalendarState createState() => DatePickerCalendarState();
}

class DatePickerCalendarState extends State<DatePickerCalendar> {
  String headerText = '';
  late final DateTime _initialDisplayDate;
  final DateRangePickerController _controller = DateRangePickerController();
  bool useSelectedRange = true;
  late DateTime selectedTimeStart;
  late DateTime selectedTimeEnd;
  late DateTime selectedDateStart;
  late DateTime selectedDateEnd;

  void getTimeStart(DateTime value) {
    selectedTimeStart = value;
    try {
      selectedDateStart = DateTime(
        selectedDateStart.year,
        selectedDateStart.month,
        selectedDateStart.day,
        selectedTimeStart.hour,
        selectedTimeStart.minute,
      );
      widget.showDateSingle(selectedDateStart);
      widget.showDateRange([
        selectedDateStart,
        selectedDateEnd
      ]);
    } catch (_) {}
  }

  void getTimeEnd(DateTime value) {
    selectedTimeEnd = value;
    try {
      selectedDateEnd = DateTime(
        selectedDateEnd.year,
        selectedDateEnd.month,
        selectedDateEnd.day,
        selectedTimeEnd.hour,
        selectedTimeEnd.minute,
      );
      widget.showDateRange([
        selectedDateStart,
        selectedDateEnd
      ]);
    } catch (_) {}
  }

  void getSelectedDataRanged(DateRangePickerSelectionChangedArgs args) {
    selectedDateStart = DateTime(
      args.value.startDate.year,
      args.value.startDate.month,
      args.value.startDate.day,
      selectedTimeStart.hour,
      selectedTimeStart.minute,
    );
    if (args.value.endDate != null) {
      selectedDateEnd = DateTime(
        args.value.endDate.year,
        args.value.endDate.month,
        args.value.endDate.day,
        selectedTimeEnd.hour,
        selectedTimeEnd.minute,
      );
      widget.showDateRange([
        selectedDateStart,
        selectedDateEnd
      ]);
    }
  }

  void getSelectedDataSingle(DateRangePickerSelectionChangedArgs args) {
    selectedDateStart = DateTime(
      args.value.year,
      args.value.month,
      args.value.day,
      selectedTimeStart.hour,
      selectedTimeStart.minute,
    );
    widget.showDateSingle(selectedDateStart);
  }


  String getCapitalizedMonth(DateTime date) {
    final formatterMonth = DateFormat('MMMM', 'ru');
    final formatterYear = DateFormat('yyyy', 'ru');
    String month = formatterMonth.format(date);
    String year = formatterYear.format(date);
    return '${month[0].toUpperCase()}${month.substring(1)} $year';
  }



  @override
  void initState() {
    super.initState();
    _initialDisplayDate = widget.startDate;
    if (widget.selectedDateSingle != null) {
      selectedDateStart = widget.selectedDateSingle!;
      selectedTimeStart = widget.selectedDateSingle!;
    }
    if (widget.selectedDateRange != null) {
      if (widget.selectedDateRange!.startDate != null) {
        selectedDateStart = widget.selectedDateRange!.startDate!;
        selectedTimeStart = widget.selectedDateRange!.startDate!;
        if (widget.selectedDateRange!.endDate != null) {
          selectedDateEnd = widget.selectedDateRange!.endDate!;
          selectedTimeEnd = widget.selectedDateRange!.endDate!;
        }
      } else if (widget.selectedDateRange!.endDate != null) {
          useSelectedRange = false;
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetAnimationDuration: Duration(milliseconds: 300),
      insetAnimationCurve: Curves.easeInOut,
      insetPadding: EdgeInsets.zero,
      child: Container(
        padding: EdgeInsets.only(top: 8.h),
        height: widget.mode == 'single' ? 380.h : 424.h,
        width: 343.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13.sp),
          color: Colors.white
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 311.w,
              height: 44.h,
              margin: EdgeInsets.only(left: 16.w, right: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 156.w,
                    padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                    child: Text(
                      headerText.isEmpty
                      ? getCapitalizedMonth(DateTime.now())
                      : headerText,
                      style: context.addProgramDialog20W500(24/20),
                    ),
                  ),
                  Container(
                    width: 155.w,
                    height: 44.h,
                    padding: EdgeInsets.only(top: 13.34.h, bottom: 13.34.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 9.97.sp,
                          height: 17.32.sp,
                          child: IconButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            splashRadius: null,
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              setState(() {
                                _controller.backward!();
                              });
                            },
                            icon: SvgPicture.asset(
                              'assets/icons/left_arrow.svg',
                              width: 9.97.sp,
                              height: 17.32.sp,
                            ),
                          ),
                        ),
                        SizedBox(width: 31.06.h),
                        SizedBox(
                          width: 9.97.sp,
                          height: 17.32.sp,
                          child: IconButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            splashRadius: null,
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              _controller.forward!();
                            },
                            icon: SvgPicture.asset(
                              'assets/icons/right_arrow.svg',
                              width: 9.97.sp,
                              height: 17.32.sp,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 268.h,
              width: 311.w,
              margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 4.h),
              child: SfDateRangePicker(
                headerHeight: 0,
                todayHighlightColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                initialSelectedDate: widget.selectedDateSingle,
                initialSelectedRange: useSelectedRange ? widget.selectedDateRange : null,
                enablePastDates: true,
                showNavigationArrow: true,
                selectionShape: DateRangePickerSelectionShape.circle,
                navigationDirection: DateRangePickerNavigationDirection.horizontal,
                allowViewNavigation: false,
                navigationMode: DateRangePickerNavigationMode.snap,
                controller: _controller,
                onViewChanged: (dateRangePickerViewChangedArgs) {
                  final DateTime startDate = dateRangePickerViewChangedArgs.visibleDateRange.startDate!;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!mounted) return;
                    setState(() {
                      headerText = getCapitalizedMonth(startDate);
                    });
                  });
                },
                onSelectionChanged: widget.mode == 'single'
                                    ? getSelectedDataSingle
                                    : getSelectedDataRanged,
                monthViewSettings: DateRangePickerMonthViewSettings(
                  firstDayOfWeek: 1,
                  dayFormat: 'EEE',
                  enableSwipeSelection: true,
                  viewHeaderStyle: DateRangePickerViewHeaderStyle(
                    textStyle: AppText.calendarPopUpViewHeader
                  )
                ),
                monthCellStyle: DateRangePickerMonthCellStyle(
                  textStyle: context.calendarPopUpViewNumbers(Color(0xFF4DABEE)),
                  todayTextStyle: context.calendarPopUpViewNumbers(Color(0xFF4DABEE)),
                  disabledDatesTextStyle: context.calendarPopUpViewNumbers(Color(0x3C3C434D))
                ),
                minDate: DateTime(1970),
                maxDate: DateTime.now(),
                initialDisplayDate: _initialDisplayDate,
                selectionRadius: -1,
                rangeSelectionColor: Color.fromARGB(80, 77, 171, 238),
                selectionColor: Color(0xFF4DABEE),
                startRangeSelectionColor: Color(0xFF4DABEE),
                endRangeSelectionColor: Color(0xFF4DABEE),
                selectionTextStyle: context.calendarPopUpViewNumbers(Colors.white, FontWeight.w600),
                rangeTextStyle: context.calendarPopUpViewNumbers(Color(0xFF4DABEE)),
                monthFormat: 'MMMM',
                extendableRangeSelectionDirection: ExtendableRangeSelectionDirection.both,
                selectionMode: widget.mode == 'single'
                ? DateRangePickerSelectionMode.single
                : DateRangePickerSelectionMode.range,
              ),
            ),
            Container(
              width: 311.w,
              height: 44.h,
              margin: EdgeInsets.only(left: 16.w, right: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 156.w,
                    padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                    child: Text(
                      widget.mode == 'single'
                      ? 'Время'
                      : 'Время начала',
                      style: context.calendarPopUpViewNumbers(Color(0xFF404040)),
                    ),
                  ),
                  Container(
                    width: 155.w,
                    height: 44.h,
                    padding: EdgeInsets.only(top: 4.h, bottom: 4.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CalendarTimePopUp(
                          time: widget.mode == 'single'
                              ? widget.selectedDateSingle ?? widget.startDate
                              : widget.selectedDateRange != null
                                ? widget.selectedDateRange!.startDate ?? widget.startDate
                                : widget.startDate,
                          selectedTime: getTimeStart,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            widget.mode == 'single'
            ? SizedBox()
            : Container(
              width: 311.w,
              height: 44.h,
              margin: EdgeInsets.only(left: 16.w, right: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 156.w,
                    padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                    child: Text(
                      'Время конца',
                      style: context.calendarPopUpViewNumbers(Color(0xFF404040)),
                    ),
                  ),
                  Container(
                    width: 155.w,
                    height: 44.h,
                    padding: EdgeInsets.only(top: 4.h, bottom: 4.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CalendarTimePopUp(
                          time: widget.selectedDateRange != null
                                ? widget.selectedDateRange!.endDate ?? widget.startDate
                                : widget.startDate,
                          selectedTime: getTimeEnd,
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ]
        )
      ),
    );
  }
}
