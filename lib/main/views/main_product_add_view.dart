import 'dart:io';

import 'package:banana/main/views/main_bottom_button.dart';
import 'package:banana/main/views/tag_item_list.dart';
import 'package:banana/utils/values/app_colors.dart';
import 'package:banana/utils/values/app_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:mime/mime.dart';
import 'package:video_player/video_player.dart';

import 'aspect_radio_video.dart';

class MainProductAddView extends StatefulWidget {
  const MainProductAddView({super.key});

  @override
  State<MainProductAddView> createState() => _MainProductAddViewState();
}

class _MainProductAddViewState extends State<MainProductAddView> {
  final titleController = TextEditingController();
  final subTitleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final tradingAreaController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _images = [];
  int? _thumbnailIndex;
  final GlobalKey<AnimatedListState> _imageListKey =
      GlobalKey<AnimatedListState>();
  final log = Get.find<Logger>(tag: 'MainLogger');

  @override
  void initState() {
    super.initState();
  }

  Widget titleTextField() {
    return TextFormField(
      controller: titleController,
      decoration: InputDecoration(
        labelStyle: TextStyle(
          fontSize: 28,
          color: AppColors.gray,
          fontFamily: 'Rubik',
          fontWeight: FontWeight.normal,
        ),
        labelText: 'Title',
      ),
    );
  }

  Widget subTitleTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelStyle: TextStyle(
          fontSize: 14,
          color: AppColors.gray,
          fontFamily: 'Rubik',
          fontWeight: FontWeight.normal,
        ),
        labelText: 'Subtitle',
      ),
    );
  }

  Widget descriptionTextField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextFormField(
        controller: descriptionController,
        maxLines: 5,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 12, right: 12, top: 24),
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
    );
  }

  Widget priceTextField() {
    return TextFormField(
      controller: priceController,
      decoration: InputDecoration(
        isDense: true,
        hintText: "enter your price",
        hintStyle: TextStyle(
          color: AppColors.gray,
          fontSize: 14,
          fontFamily: 'Rubik',
          fontWeight: FontWeight.normal,
        ),
        prefixIconConstraints: BoxConstraints(minWidth: 16, maxHeight: 16),
        prefixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(AppIcons.price, color: AppColors.gray, size: 16),
            VerticalDivider(color: AppColors.gray, thickness: 1.5),
          ],
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.gray, width: 1.5),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'please enter your price';
        if ((!value.isNum) || ((int.tryParse(value) ?? -1) < 0)) {
          return 'it is not a valid number';
        }
        return null;
      },
    );
  }

  Widget tradingAreaTextField() {
    return TextFormField(
      controller: tradingAreaController,
      decoration: InputDecoration(
        isDense: true,
        hintText: "enter your trading area",
        hintStyle: TextStyle(
          color: AppColors.gray,
          fontSize: 14,
          fontFamily: 'Rubik',
          fontWeight: FontWeight.normal,
        ),
        prefixIconConstraints: BoxConstraints(minWidth: 16, maxHeight: 16),
        prefixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(AppIcons.location, color: AppColors.gray, size: 16),
            VerticalDivider(color: AppColors.gray, thickness: 1.5),
          ],
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.gray, width: 1.5),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'please enter your price';
        if ((!value.isNum) || ((int.tryParse(value) ?? -1) < 0)) {
          return 'it is not a valid number';
        }
        return null;
      },
    );
  }

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
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                imageAddButton(),
                SizedBox(width: 8),
                Expanded(child: imageList()),
              ],
            ),
            SizedBox(height: 15),
            titleTextField(),
            subTitleTextField(),
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
            descriptionTextField(),
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
            priceTextField(),
            SizedBox(
              height: 36,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Trading Area',
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
            tradingAreaTextField(),
            Expanded(child: Container()),
            MainBottomButton(onPressed: () {}, text: "LIST A PRODUCT"),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget imageAddButton() {
    return SizedBox(
      height: 64,
      width: 64,
      child: IconButton(
        onPressed: () async {
          final List<XFile> images = await _picker.pickMultiImage();
          for (XFile image in images) {
            int index = _images.isNotEmpty ? _images.length : 0;
            _images.insert(index, image);
            _imageListKey.currentState!.insertItem(index);
          }
          if (_thumbnailIndex == null && _images.isNotEmpty) {
            setState(() {
              _thumbnailIndex = 0;
            });
          }
        },
        style: IconButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        icon: Icon(AppIcons.imageAdd, size: 32, color: AppColors.white),
      ),
    );
  }

  Widget imageList() {
    return SizedBox(
      height: 64,
      child: AnimatedList.separated(
        key: _imageListKey,
        initialItemCount: _images.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index, animation) {
          return ScaleTransition(
            scale: animation.drive(
              Tween<double>(
                begin: 0.8,
                end: 1.0,
              ).chain(CurveTween(curve: Curves.easeInOut)),
            ),
            child: imageItemContainer(_images[index], index),
          );
        },
        separatorBuilder: (
          BuildContext context,
          int index,
          Animation<double> animation,
        ) {
          return SizedBox(width: 8);
        },
        removedSeparatorBuilder: (
          BuildContext context,
          int index,
          Animation<double> animation,
        ) {
          return SizedBox(width: 8);
        },
      ),
    );
  }

  Widget imageItemContainer(XFile image, int index) {
    final String? mime = lookupMimeType(image.path);

    return kIsWeb
        ? Image.network(image.path)
        : (mime == null || mime.startsWith('image/')
            ? (_thumbnailIndex != null && _thumbnailIndex == index)
                ? thumbnailImageItem(child: imageItem(image, index))
                : imageItem(image, index)
            : _buildInlineVideoPlayer(index));
  }

  Widget imageItem(XFile image, int index) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _thumbnailIndex = index;
            });
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(
              fit: BoxFit.fitHeight,
              width: 64,
              height: 64,
              File(image.path),
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              },
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            onPressed: () {
              int? targetIndex;
              if (_thumbnailIndex == index) {
                _thumbnailIndex = null;
                targetIndex = 0;
              } else if (_thumbnailIndex != null &&
                  _thumbnailIndex! == index + 1) {
                targetIndex = _thumbnailIndex! - 1;
                _thumbnailIndex = null;
              } else {
                if (_thumbnailIndex != null && _thumbnailIndex! > index) {
                  _thumbnailIndex = _thumbnailIndex! - 1;
                }
              }
              final XFile removedImage = _images.removeAt(index);
              _imageListKey.currentState!.removeItem(index, (
                context,
                animation,
              ) {
                return ScaleTransition(
                  scale: animation.drive(
                    Tween<double>(
                      begin: 1.0,
                      end: 0.8,
                    ).chain(CurveTween(curve: Curves.easeInOut)),
                  )..addStatusListener((state) {
                    if (state == AnimationStatus.completed ||
                        state == AnimationStatus.dismissed) {
                      if (_images.isNotEmpty && targetIndex != null) {
                        setState(() {
                          _thumbnailIndex = targetIndex;
                        });
                      }
                    }
                  }),
                  child: imageItemContainer(removedImage, index),
                );
              });
            },
            icon: Icon(AppIcons.close, color: AppColors.white, size: 16),
            style: IconButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ),
      ],
    );
  }

  Widget thumbnailImageItem({required Widget child}) {
    return Stack(
      children: [
        child,
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.8),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            width: 64,
            height: 16,
            child: Icon(AppIcons.visible, color: AppColors.white, size: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildInlineVideoPlayer(int index) {
    final VideoPlayerController controller = VideoPlayerController.file(
      File(_images[index].path),
    );
    const double volume = kIsWeb ? 0.0 : 1.0;
    controller.setVolume(volume);
    controller.initialize();
    controller.setLooping(true);
    controller.play();
    return Center(child: AspectRatioVideo(controller));
  }
}
