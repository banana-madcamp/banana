import 'dart:io';

import 'package:banana/login/datas/source/user_database_source.dart';
import 'package:banana/main/datas/source/database_source.dart';
import 'package:banana/main/models/product.dart';
import 'package:banana/main/models/product_information_image.dart';
import 'package:banana/main/views/main_bottom_button.dart';
import 'package:banana/main/views/tag_item_list.dart';
import 'package:banana/utils/values/app_colors.dart';
import 'package:banana/utils/values/app_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:mime/mime.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';

import '../datas/local/tags.dart';
import '../models/information_validator.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<ProductInformationImage> _productImages = [];
  int? _thumbnailIndex;
  final GlobalKey<AnimatedListState> _imageListKey =
      GlobalKey<AnimatedListState>();
  final log = Get.find<Logger>(tag: 'MainLogger');
  final List<String> _tags = Get.find<List<String>>(tag: 'SelectedTags');
  bool isUploading = false;

  DatabaseSource get _db => Get.find<DatabaseSource>();

  UserDatabaseSource get _userDb => Get.find<UserDatabaseSource>();

  @override
  void initState() {
    super.initState();
  }

  Widget titleTextField() {
    return TextFormField(
      validator: InformationValidator.validateTitle,
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
      validator: InformationValidator.validateSubtitle,
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
        validator: InformationValidator.validateDescription,
        controller: descriptionController,
        maxLines: 5,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 12, right: 12, top: 12),
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
      validator: InformationValidator.validatePrice,
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
    );
  }

  Widget tradingAreaTextField() {
    return TextFormField(
      validator: InformationValidator.validateLocation,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                height: Get.height + 100,
                decoration: BoxDecoration(color: AppColors.white),
                padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
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
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: MainBottomButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }
                  InformationValidator()
                      .validateTags(
                        _productImages
                            .map(
                              (image) =>
                                  InputImage.fromFilePath(image.image.path),
                            )
                            .toList(),
                      )
                      .then((tags) {
                        log.i("Image Labeled Tags: $tags");
                        List<int> errorIndexes = [];
                        final List<String> convertedTags =
                            _tags.map((e) => Tags().getEnglishTag(e)).toList();
                        for (int i = 0; i < tags.length; i++) {
                          bool isValid = false;
                          for (String tag in tags[i]) {
                            if (convertedTags.contains(tag)) {
                              isValid = true;
                              break;
                            }
                          }
                          if (!isValid) {
                            errorIndexes.add(i);
                          }
                        }
                        if (errorIndexes.isEmpty &&
                            _productImages.isNotEmpty &&
                            _thumbnailIndex != null) {
                          upload().then((value) {
                            log.i("Product uploaded successfully");
                            Get.back(result: true);
                          });
                        } else {
                          String errorHeader = "Unsuccessful submission";
                          String errorMessage =
                              "Please check the following errors:";
                          if (errorIndexes.isNotEmpty) {
                            errorMessage +=
                                "\n- Invalid tags at indexes: $errorIndexes";
                            setState(() {
                              for (int index in errorIndexes) {
                                _productImages[index].isValid = false;
                              }
                            });
                          }
                          if (_productImages.isEmpty) {
                            errorMessage += "\n- No images selected";
                          }
                          if (_thumbnailIndex == null) {
                            errorMessage += "\n- No thumbnail selected";
                          }
                          Get.dialog(
                            CupertinoAlertDialog(
                              title: Text(errorHeader),
                              content: Text(
                                errorMessage,
                                textAlign: TextAlign.start,
                              ),
                              actions: [
                                CupertinoDialogAction(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text("OK"),
                                ),
                              ],
                            ),
                          );
                        }
                      });
                },
                text: "LIST A PRODUCT",
              ),
            ),
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
        onPressed: _pickImage(),
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
        initialItemCount: _productImages.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index, animation) {
          return ScaleTransition(
            scale: animation.drive(
              Tween<double>(
                begin: 0.8,
                end: 1.0,
              ).chain(CurveTween(curve: Curves.easeInOut)),
            ),
            child: imageItemContainer(_productImages[index], index),
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

  Widget imageItemContainer(ProductInformationImage productImage, int index) {
    final String? mime = lookupMimeType(productImage.image.path);

    return kIsWeb
        ? Image.network(productImage.image.path)
        : (mime == null || mime.startsWith('image/')
            ? (_thumbnailIndex != null && _thumbnailIndex == index)
                ? thumbnailImageItem(child: imageItem(productImage, index))
                : imageItem(productImage, index)
            : _buildInlineVideoPlayer(index));
  }

  Widget imageItem(ProductInformationImage productImage, int index) {
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
              File(productImage.image.path),
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
              final ProductInformationImage removedImage = _productImages
                  .removeAt(index);
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
                      if (_productImages.isNotEmpty && targetIndex != null) {
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
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color:
                      productImage.isValid
                          ? AppColors.transparent
                          : AppColors.red.withValues(alpha: 0.8),
                  width: 2,
                ),
              ),
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
      File(_productImages[index].image.path),
    );
    const double volume = kIsWeb ? 0.0 : 1.0;
    controller.setVolume(volume);
    controller.initialize();
    controller.setLooping(true);
    controller.play();
    return Center(child: AspectRatioVideo(controller));
  }

  Future<bool> _permission() async {
    if (Platform.isIOS) {
      if (await Permission.photos.request().isGranted ||
          await Permission.storage.request().isGranted) {
        return true;
      }
    }
    if (Platform.isAndroid) {
      if (await Permission.storage.request().isGranted ||
          await Permission.photos.request().isGranted &&
              await Permission.videos.request().isGranted) {
        return true;
      }
    }
    Get.dialog(
      CupertinoAlertDialog(
        title: Text("Permission Denied"),
        content: Text("Please allow access to photos in settings."),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              Get.back();
            },
            child: Text("Cancel"),
          ),
          CupertinoDialogAction(
            onPressed: () {
              Get.back();
              openAppSettings();
            },
            child: Text("Settings"),
          ),
        ],
      ),
    );
    return false;
  }

  VoidCallback _pickImage() {
    return () async {
      if (context.mounted) {
        if (!await _permission()) return;
        try {
          final List<XFile> images = await _picker.pickMultiImage();
          for (XFile image in images) {
            int index = _productImages.isNotEmpty ? _productImages.length : 0;
            _productImages.insert(
              index,
              ProductInformationImage(isValid: true, image: image),
            );
            _imageListKey.currentState!.insertItem(index);
          }
          if (_thumbnailIndex == null && _productImages.isNotEmpty) {
            setState(() {
              _thumbnailIndex = 0;
            });
          }
        } catch (e) {
          log.e("Error picking images: $e");
        }
      }
    };
  }

  Future<void> upload() async {
    final user = await _userDb.getCurrentUser();
    var uuid = Uuid();
    String productId = uuid.v4();

    List<String> imageDownloadLinks = await _db.uploadImages(
      productId,
      _productImages.map((image) => File(image.image.path)).toList(),
    );
    return _db.uploadProduct(
      Product(
        userId: user.userId,
        id: productId,
        title: titleController.text,
        subTitle: subTitleController.text,
        description: descriptionController.text,
        price: double.tryParse(priceController.text) ?? 0.0,
        tag: _tags,
        location: tradingAreaController.text,
        thumbnailImageUrl: imageDownloadLinks[_thumbnailIndex ?? 0],
        createdAt: DateTime.now(),
        imageUrls: imageDownloadLinks,
      ),
    );
  }
}
