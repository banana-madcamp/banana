import 'package:banana/main/views/main_bottom_button.dart';
import 'package:banana/main/views/tag_item_list.dart';
import 'package:banana/utils/values/app_colors.dart';
import 'package:banana/utils/values/app_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainProductAddView extends StatelessWidget {
  const MainProductAddView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(color: AppColors.white),
        padding: EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'Product Information',
                  style: TextStyle(
                    fontSize: 24,
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Rubik',
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(AppIcons.close),
                  style: IconButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
            SizedBox(height: 19),
            SizedBox(
              height: 64,
              width: 64,
              child: IconButton(
                onPressed: () {},
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: Icon(AppIcons.imageAdd, size: 32, color: AppColors.white),
              ),
            ),
            SizedBox(height: 15),
            TextFormField(
              decoration: InputDecoration(
                labelStyle: TextStyle(
                  fontSize: 28,
                  color: AppColors.gray,
                  fontFamily: 'Rubik',
                  fontWeight: FontWeight.normal,
                ),
                labelText: 'Title',
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                labelStyle: TextStyle(
                  fontSize: 14,
                  color: AppColors.gray,
                  fontFamily: 'Rubik',
                  fontWeight: FontWeight.normal,
                ),
                labelText: 'Subtitle',
              ),
            ),
            SizedBox(
              height: 36,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.black,
                      fontFamily: 'Rubik',
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.lightGray,
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextFormField(
                maxLines: 5,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(
                    left: 12,
                    right: 12,
                    top: 24,
                  ),
                  border: InputBorder.none,
                  hintText: '- 브랜드, 모델명, 구매 시기, 하자 유무 등 상품 설명을 최대한 자세히 적어주세요.',
                  hintStyle: TextStyle(
                    wordSpacing: -0.02,
                    fontSize: 14,
                    color: AppColors.gray,
                    fontFamily: 'Rubik',
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 36,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Tags',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.black,
                      fontFamily: 'Rubik',
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            TagItemList(),
            SizedBox(
              height: 36,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Price',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.black,
                      fontFamily: 'Rubik',
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: Container()),
            MainBottomButton(onPressed: () {}, text: "LIST A PRODUCT"),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
