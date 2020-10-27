import 'dart:io';

import 'package:ammaratef45Flutter/utils/storage_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class ImagePrompt extends StatefulWidget {
  final TextEditingController controller;

  final _ImageController _imageController = _ImageController();

  ImagePrompt({
    Key key,
    @required this.controller,
  }) : super(key: key);

  Future<void> finish(String path) async {
    if (kIsWeb) return;
    await (StorageUtils.upload(path, _imageController.image));
    controller.text = await StorageUtils.getImage(path);
  }

  bool shouldFinish() {
    return !kIsWeb;
  }

  @override
  _ImagePromptState createState() => _ImagePromptState();
}

class _ImagePromptState extends State<ImagePrompt> {
  final ImagePicker _imagePicker = ImagePicker();

  Future<File> _getImage() async {
    final PickedFile pickedFile =
        await _imagePicker.getImage(source: ImageSource.gallery);
    return File(pickedFile.path);
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? SizedBox(
            height: 60,
            child: TextFormField(
              controller: widget.controller,
              decoration: InputDecoration(
                hintText: 'Image Url',
              ),
            ),
          )
        : Row(
            children: [
              RaisedButton(
                child: Text('Choose Image'),
                onPressed: () {
                  _getImage().then((value) {
                    setState(() {
                      widget._imageController.image = value;
                    });
                  });
                },
              ),
              Expanded(
                child: Text(
                  basename(
                      widget._imageController.image?.path ?? 'Choose file'),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );
  }
}

class _ImageController {
  File image;
}
