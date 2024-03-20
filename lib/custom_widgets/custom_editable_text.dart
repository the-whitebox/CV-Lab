import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/constants.dart';

class CustomEditableText extends StatefulWidget {
  final TextEditingController controller;
  final TextAlign textAlign;
  final TextStyle style;
  final double horizontalPadding;
  final double verticalPadding;
  final Color backgroundColor;
  final double rightMargin;
  final double bottomMargin;
  final Color borderColor;
  final int? maxLength;

  const CustomEditableText({
    Key? key,
    required this.controller,
    this.textAlign = TextAlign.start,
    required this.style,
    this.horizontalPadding = 0,
    this.verticalPadding = 0,
    this.backgroundColor = Colors.white,
    this.rightMargin = 5,
    this.borderColor = Colors.transparent,
    this.bottomMargin = 0,
    this.maxLength,
  }) : super(key: key);

  @override
  _CustomEditableTextState createState() => _CustomEditableTextState();
}

class _CustomEditableTextState extends State<CustomEditableText> {
  final FocusNode _focusNode = FocusNode();
  final Color _borderColor = Colors.transparent;
  final double _borderRadius = 0;
  String originalText = "";
  bool isFocused = false;

  @override
  void initState() {
    super.initState();
    originalText = widget.controller.text;
  }

  void saveChanges() {
    setState(() {
      originalText = widget.controller.text;
      Get.back();
    });
  }

  void cancelChanges() {
    Get.back();
    setState(() {
      widget.controller.text = originalText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        showMenu(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
              side: const BorderSide(color: kHighlightedColor),
            ),
            color: Colors.white,
            surfaceTintColor: Colors.white,
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width * 0.65,
              maxWidth: MediaQuery.of(context).size.width * 0.85,
              maxHeight: MediaQuery.of(context).size.height * 0.3,
            ),
            context: context,
            position: RelativeRect.fromLTRB(
              MediaQuery.of(context).size.width * 0.075,
              MediaQuery.of(context).size.height * 0.3,
              MediaQuery.of(context).size.height * 0.25,
              0,
            ),
            items: [
              PopupMenuItem(
                enabled: false,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    TextField(
                      onTapOutside: (event) {
                        saveChanges();
                      },
                      maxLength: widget.maxLength,
                      controller: widget.controller,
                      decoration: null,
                      minLines: null,
                      maxLines: null,
                      expands: true,
                      textAlign: TextAlign.justify,
                      focusNode: _focusNode,
                      style: const TextStyle(
                          fontSize: 14, color: Colors.black, wordSpacing: 0.1, letterSpacing: 0.1),
                      cursorColor: Colors.purple,
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 25,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              cancelChanges();
                            },
                            style: kElevatedButtonWhiteOpacityBG,
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                  color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),
                            ),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: () {
                              saveChanges();
                            },
                            style: kElevatedButtonWhiteOpacityBG.copyWith(
                              backgroundColor: const MaterialStatePropertyAll(kHighlightedColor),
                            ),
                            child: const Text(
                              'Save',
                              style: TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ]);
      },

      // child: InteractiveViewer(
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: widget.horizontalPadding, vertical: widget.verticalPadding),
        margin: EdgeInsets.only(
          right: widget.rightMargin,
          bottom: widget.bottomMargin,
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: _borderColor,
          ),
          borderRadius: BorderRadius.circular(_borderRadius),
        ),

        child: widget.controller.text.isNotEmpty
            ? Text(
                widget.controller.text,
                style: widget.style,
                textAlign: widget.textAlign,
              )
            : Text(
                'Please enter text',
                style: widget.style,
                textAlign: widget.textAlign,
              ),

      ),
      // ),
    );
  }
}






