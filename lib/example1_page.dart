import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:photo2/my_custom_icons_icons.dart';

class Example1Page extends StatefulWidget {
  const Example1Page({Key? key}) : super(key: key);

  @override
  State<Example1Page> createState() => _Example1PageState();
}

class _Example1PageState extends State<Example1Page> {
  // 처음엔 고른 파일이 없을테니 ?로 optional 하게 해준다.
  File? _pickedFile;

  Future getCameraImage(ImgSource source) async {
    // 사진 촬영 화면으로 넘어가서 이미지 선택
    final pickedFile = await ImagePickerGC.pickImage(
      context: context,
      source: source,
      cameraIcon: (
        Icon(MyCustomIcons.shutter_icon_2)
      )

    );
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
      });
    } else {
      if (kDebugMode) {
        print('이미지 선택안함');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 사이즈 조정
    final _imageSize = MediaQuery.of(context).size.width / 4;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Example1'),
        ),
        body: Column(
          children: [
            // 임의의 박스 생성
            const SizedBox(height: 20,),
            // 선택된 파일이 없으면
            if (_pickedFile == null)
              Container(
                constraints: BoxConstraints(
                  minHeight: _imageSize,
                  minWidth: _imageSize,
                ),
                // 사용자의 동작 감지
                child: GestureDetector(
                  // 탭하면
                  onTap: () {
                    // 하단에 창을 띄어줌
                    _showBottomSheet();
                  },
                  // 아이콘
                  child: Center(
                    child: Icon(
                      Icons.account_circle,
                      size: _imageSize,
                    ),
                  ),
                ),
              )
            // 선택된 파일이 있으면
            else
              Center(
                child: Container(
                  width: _imageSize,
                  height: _imageSize,
                  // BoxDecoration 위젯으로 꾸며준다.
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        width: 2, color: Theme.of(context).colorScheme.primary),
                    // BoxDecoration의 이미지는
                    image: DecorationImage(
                      // 촬영 화면에서 보내진 이미지
                        image: FileImage(File(_pickedFile!.path)),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  _showBottomSheet() {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () => getCameraImage(),
              child: const Text('사진찍기'),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              thickness: 3,
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () => _getPhotoLibraryImage(),
              child: const Text('라이브러리에서 불러오기'),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        );
      },
    );
  }

  // 사진찍기 버튼을 을 누르면


  // 라이브러리에서 가져오기 버튼을 누르면
  _getPhotoLibraryImage() async {
    // 갤러리에서 이미지 선택
    final pickedFile = await ImagePickerGC.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = _pickedFile;
      });
    } else {
      if (kDebugMode) {
        print('이미지 선택안함');
      }
    }
  }
}