import 'package:crewdog_cv_lab/custom_widgets/rotating_image.dart';
import 'package:flutter/material.dart';
import '../utils/consts/constants.dart';

class SaveDownloadButtonsRow extends StatefulWidget {
  final Future<void> Function() onSavePressed;
  final Future<void> Function() onDownloadPressed;
  final bool isUpdateCV;

  const SaveDownloadButtonsRow({
    super.key,
    required this.onSavePressed,
    required this.onDownloadPressed,
    this.isUpdateCV = false,
  });

  @override
  _SaveDownloadButtonsRowState createState() => _SaveDownloadButtonsRowState();
}
class _SaveDownloadButtonsRowState extends State<SaveDownloadButtonsRow> {
  bool _saving = false;
  bool _downloading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: _saving
                  ? null // Disable button if downloading
                  : () async {
                setState(() {
                  _saving = true;
                  _downloading = false;
                });
                await widget.onSavePressed();
                setState(() {
                  _saving = false;
                });
              },
              style: kElevatedButtonWhiteOpacityBG.copyWith(
                side: const MaterialStatePropertyAll(BorderSide(color: kHighlightedColor)),
                backgroundColor: const MaterialStatePropertyAll(Colors.white),
              ),
              child: _saving
                  ? const RotatingImage(
                height: 30,
                width: 30,
              ) // Show indicator while saving
                  : widget.isUpdateCV
                  ? const Text(
                'Update',
                style: TextStyle(
                    color: Color(0xFFFF5E59), fontWeight: FontWeight.w500, fontSize: 16),
              )
                  : const Text(
                'Save',
                style: TextStyle(
                    color: Color(0xFFFF5E59), fontWeight: FontWeight.w500, fontSize: 16),
              ),
            ),
            const SizedBox(width: 20.0),
            ElevatedButton(
              onPressed: _downloading
                  ? null
                  : () async {
                setState(() {
                  _downloading = true;
                  _saving = false;
                });
                await widget.onDownloadPressed();
                setState(() {
                  _downloading = false;
                });
              },
              style: kElevatedButtonWhiteOpacityBG.copyWith(
                backgroundColor: const MaterialStatePropertyAll(kHighlightedColor),
              ),
              child: _downloading
                  ? const RotatingImage(
                height: 30,
                width: 30,
              ) // Show indicator while downloading
                  : Row(
                children: [
                  Image.asset(
                    'assets/images/download.png',
                    width: 16.0,
                    height: 16.0,
                  ),
                  const SizedBox(width: 10.0),
                  const Text(
                    'Download',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }
}


