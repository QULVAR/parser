import 'package:flutter/material.dart';
import 'package:pki_frontend_app/resizer.dart';
import 'enroll_category.dart';

class CatalogListViewBuilder extends StatefulWidget {
  
  final data;

  const CatalogListViewBuilder({
    super.key,
    required this.data
  });

  @override
  State<CatalogListViewBuilder> createState() => CatalogListViewBuilderState();
}

class CatalogListViewBuilderState extends State<CatalogListViewBuilder> {

  int keyVal = 0;

  void updatePage() {setState(() { keyVal += 1;});}

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: ValueKey(keyVal),
      padding: EdgeInsets.only(
        top: 10.h,
        bottom: 10.h,
        right: 10.w,
        left: 10.w,
      ),
      itemCount: (widget.data as List).length,
      itemBuilder: (context, i) {
        return EnrollCategory(category: widget.data[i]);
      },
    );
  }
}