import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furniture_ecommerce_app/core/common/widgets/elevated_button_icon.dart';
import 'package:furniture_ecommerce_app/core/common/widgets/elevated_button_small_widget.dart';
import 'package:furniture_ecommerce_app/core/common/widgets/elevated_button_widget.dart';
import 'package:furniture_ecommerce_app/core/common/widgets/text_field_widget.dart';
import 'package:furniture_ecommerce_app/features/search/presentation/widgets/category_name.dart';
import 'package:furniture_ecommerce_app/features/search/presentation/widgets/search_field_widget.dart';

const _categories = [
  'Chairs',
  'Office Furnitures',
  'Living Room',
  'Bedroom',
  'Kitchen',
  'Dining Room',
  'Outdoor',
  'Bedroom',
  'Kitchen',
  'Dining Room',
  'Outdoor',
];

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 24.h,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          spacing: 12.w,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(child: SearchFieldWidget()),
                            ElevatedButtonIcon(
                              icon: Icons.search,
                              onPressEvent: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Wrap(
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    spacing: 12.w,
                    runSpacing: 12.h,
                    children: _categories
                        .map((name) => CategoryName(name: name))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
