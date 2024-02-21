import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/constants.dart';

class SaveDownloadButtonsRow extends StatelessWidget {
  final VoidCallback onSavePressed;
  final VoidCallback onDownloadPressed;
  final bool isUpdateCV;

  const SaveDownloadButtonsRow({
    super.key,
    required this.onSavePressed,
    required this.onDownloadPressed,
     this.isUpdateCV=false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: onSavePressed,
              style: kElevatedButtonWhiteOpacityBG.copyWith(
                side: const MaterialStatePropertyAll(BorderSide(color: kHighlightedColor)),
                backgroundColor: const MaterialStatePropertyAll(Colors.white),
              ),
              child:isUpdateCV? const Text(
                'Update',
                style:
                TextStyle(color: Color(0xFFFF5E59), fontWeight: FontWeight.w500, fontSize: 16),
              ):const Text(
                'Save',
                style:
                    TextStyle(color: Color(0xFFFF5E59), fontWeight: FontWeight.w500, fontSize: 16),
              ),
            ),
            const SizedBox(width: 20.0),
            ElevatedButton(
              onPressed: onDownloadPressed,
              style: kElevatedButtonWhiteOpacityBG.copyWith(
                backgroundColor: const MaterialStatePropertyAll(kHighlightedColor),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/download.png', // Replace with your image path
                    width: 16.0,
                    height: 16.0,
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  const Text(
                    'Download',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16), // Replace with your color
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

class EmploymentHistoryWidget extends StatelessWidget {
  final TextEditingController title;
  final TextEditingController from;
  final TextEditingController till;
  final TextEditingController description;
  final TextEditingController city;
  final TextEditingController country;
  final TextEditingController companyName;
  final double titleFontSize;
  final double durationFontSize;
  final Color backgroundColor;
  final VoidCallback onRemoveTap;

  const EmploymentHistoryWidget({
    super.key,
    required this.title,
    required this.from,
    required this.till,
    required this.description,
    this.titleFontSize = 8,
    this.durationFontSize = 6,
    this.backgroundColor = Colors.white,
    required this.onRemoveTap,
    required this.city,
    required this.country,
    required this.companyName,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    CustomEditableText(
                      horizontalPadding: 0,
                      rightMargin: 0,
                      backgroundColor: backgroundColor,
                      controller: title,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: const Color(0xFF4E4949),
                        fontSize: titleFontSize,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(" at ",style: TextStyle(
                      color: const Color(0xFF4E4949),
                      fontSize: titleFontSize,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),),
                    CustomEditableText(
                      horizontalPadding: 0,
                      rightMargin: 0,
                      backgroundColor: backgroundColor,
                      controller: companyName,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: const Color(0xFF4E4949),
                        fontSize: titleFontSize,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),Text(", ",style: TextStyle(
                      color: const Color(0xFF4E4949),
                      fontSize: titleFontSize,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),),
                    CustomEditableText(
                      horizontalPadding: 0,
                      rightMargin: 0,
                      backgroundColor: backgroundColor,
                      controller: city,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: const Color(0xFF4E4949),
                        fontSize: titleFontSize,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(", ",style: TextStyle(
                      color: const Color(0xFF4E4949),
                      fontSize: titleFontSize,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),),
                    CustomEditableText(
                      horizontalPadding: 0,
                      rightMargin: 0,
                      backgroundColor: backgroundColor,
                      controller: country,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: const Color(0xFF4E4949),
                        fontSize: titleFontSize,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: onRemoveTap,
                  child: const Icon(
                    Icons.remove_circle_outline,
                    size: 12,
                    color: Color(0XFFFF5E59),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 6,
                child: CustomEditableText(
                  backgroundColor: backgroundColor,
                  controller: from,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: const Color(0xFF4E4949),
                    fontSize: durationFontSize,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Text(
                    '_',
                    style: TextStyle(
                      color: const Color(0xFF4E4949),
                      fontSize: durationFontSize,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  )),
              Expanded(
                flex: 6,
                child: CustomEditableText(
                  backgroundColor: backgroundColor,
                  controller: till,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: const Color(0xFF4E4949),
                    fontSize: durationFontSize,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const Expanded(flex: 10, child: SizedBox())
            ],
          ),
          CustomEditableText(
            backgroundColor: backgroundColor,
            controller: description,
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: Color(0xFF4E4949),
              fontSize: 7,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class EducationHistoryWidget extends StatelessWidget {
  final TextEditingController title;
  final TextEditingController from;
  final TextEditingController till;
  final TextEditingController description;
  final TextEditingController city;
  final TextEditingController country;
  final TextEditingController instituteName;
  final double titleFontSize;
  final double durationFontSize;
  final Color backgroundColor;
  final VoidCallback onRemoveTap;

  const EducationHistoryWidget({
    super.key,
    required this.title,
    required this.from,
    required this.till,
    required this.description,
    this.titleFontSize = 8,
    this.durationFontSize = 6,
    this.backgroundColor = Colors.white,
    required this.onRemoveTap,
    required this.city,
    required this.country,
    required this.instituteName,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    CustomEditableText(
                      backgroundColor: backgroundColor,
                      controller: title,
                      textAlign: TextAlign.start,
                      horizontalPadding: 0,
                      rightMargin: 0,
                      style: TextStyle(
                        color: const Color(0xFF4E4949),
                        fontSize: titleFontSize,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(" from ",style: TextStyle(
                      color: const Color(0xFF4E4949),
                      fontSize: titleFontSize,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),),
                    CustomEditableText(
                      backgroundColor: backgroundColor,
                      controller: instituteName,
                      textAlign: TextAlign.start,
                      horizontalPadding: 0,
                      rightMargin: 0,
                      style: TextStyle(
                        color: const Color(0xFF4E4949),
                        fontSize: titleFontSize,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(", ",style: TextStyle(
                      color: const Color(0xFF4E4949),
                      fontSize: titleFontSize,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),),
                    CustomEditableText(
                      backgroundColor: backgroundColor,
                      controller: city,
                      textAlign: TextAlign.start,
                      horizontalPadding: 0,
                      rightMargin: 0,
                      style: TextStyle(
                        color: const Color(0xFF4E4949),
                        fontSize: titleFontSize,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(", ",style: TextStyle(
                      color: const Color(0xFF4E4949),
                      fontSize: titleFontSize,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),),
                    CustomEditableText(
                      horizontalPadding: 0,
                      rightMargin: 0,
                      backgroundColor: backgroundColor,
                      controller: country,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: const Color(0xFF4E4949),
                        fontSize: titleFontSize,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: onRemoveTap,
                  child: const Icon(
                    Icons.remove_circle_outline,
                    size: 12,
                    color: Color(0XFFFF5E59),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 6,
                child: CustomEditableText(
                  backgroundColor: backgroundColor,
                  controller: from,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: const Color(0xFF4E4949),
                    fontSize: durationFontSize,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Text(
                    '_',
                    style: TextStyle(
                      color: const Color(0xFF4E4949),
                      fontSize: durationFontSize,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  )),
              Expanded(
                flex: 6,
                child: CustomEditableText(
                  backgroundColor: backgroundColor,
                  controller: till,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: const Color(0xFF4E4949),
                    fontSize: durationFontSize,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const Expanded(flex: 10, child: SizedBox())
            ],
          ),
          CustomEditableText(
            backgroundColor: backgroundColor,
            controller: description,
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: Color(0xFF4E4949),
              fontSize: 7,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

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
                      onTapOutside:  (event) {
                        saveChanges();
                      },
                      maxLength:widget.maxLength,
                      controller: widget.controller,
                      decoration:null,
                      minLines: null,
                      maxLines: null,
                      expands: true,
                      textAlign: TextAlign.justify,
                      focusNode: _focusNode,
                      style: const TextStyle(fontSize: 14,color: Colors.black,wordSpacing: 0.1,letterSpacing: 0.1),
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
        margin: EdgeInsets.only(right: widget.rightMargin, bottom: widget.bottomMargin,),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: _borderColor,
          ),
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
        child:widget.controller.text.isNotEmpty? Text(
          widget.controller.text,
          style: widget.style,
          textAlign: widget.textAlign,
        ): Text(
         'Please enter text',
          style: widget.style,
          textAlign: widget.textAlign,
        ),
      ),
      // ),
    );
  }
}

class CvAddButton extends StatelessWidget {
  const CvAddButton({super.key, required this.onTap,  this.buttonText="Add"});

  final VoidCallback onTap;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child:  Padding(
        padding: const EdgeInsets.only(right: 4),
        child: Row(
          children: [
            Text(buttonText,
                style: const TextStyle(
                  color: Color(0XFFC6A4FF),
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                )),
            const SizedBox(width: 5),
            const Icon(
              Icons.add_circle_outline,
              color: Color(0XFFC6A4FF),
              size: 15,
            ),
          ],
        ),
      ),
    );
  }
}

class ReferenceWidget extends StatelessWidget {
  const ReferenceWidget({
    super.key,
    required this.personName,
    required this.contactNumber,
    required this.referenceText,
    required this.onRemoveTap,
  });

  final TextEditingController personName;
  final TextEditingController contactNumber;
  final TextEditingController referenceText;
  final VoidCallback onRemoveTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomEditableText(
          horizontalPadding: 0,
          rightMargin: 0,
          controller: personName,
          style: const TextStyle(
            color: Color(0XFF4E4949),
            fontSize: 8,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: GestureDetector(
              onTap: onRemoveTap,
              child: const Icon(
                Icons.remove_circle_outline,
                size: 12,
                color: Color(0XFFFF5E59),
              ),
            ),
          ),

        ],),
        CustomEditableText(
          horizontalPadding: 0,
          rightMargin: 0,
          controller: contactNumber,
          style: const TextStyle(
            color: Color(0XFF4E4949),
            fontSize: 8,
            fontFamily: 'Inter',
          ),
        ),
        CustomEditableText(
          horizontalPadding: 0,
          rightMargin: 0,
          controller: referenceText,
          style: const TextStyle(
            color: Color(0XFF4E4949),
            fontSize: 7,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class ProjectWidget extends StatelessWidget {
  const ProjectWidget({
    super.key,
    required this.title,
    required this.description,
    required this.onRemoveTap,
  });

  final TextEditingController title;
  final TextEditingController description;
  final VoidCallback onRemoveTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomEditableText(
              horizontalPadding: 0,
              rightMargin: 0,
              controller: title,
              style: const TextStyle(
                color: Color(0XFF4E4949),
                fontSize: 8,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: GestureDetector(
                onTap: onRemoveTap,
                child: const Icon(
                  Icons.remove_circle_outline,
                  size: 12,
                  color: Color(0XFFFF5E59),
                ),
              ),
            ),

          ],),
        const SizedBox(height: 5),
        CustomEditableText(
          horizontalPadding: 0,
          rightMargin: 0,
          controller: description,
          style: const TextStyle(
            color: Color(0XFF4E4949),
            fontSize: 7,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class SkillCircullarWidget extends StatelessWidget {
  const SkillCircullarWidget({
    super.key,
    required this.skill,
    required this.onButtonTap,  this.leftPadding=10,

  });

  final TextEditingController skill;
  final double leftPadding;
  final VoidCallback onButtonTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: leftPadding),
        Container(
          width: 3,
          height: 3,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0XFF2E2D2D),
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: CustomEditableText(bottomMargin: 0,
            maxLength: 50,
            backgroundColor: const Color(0XFFe7e7fb),
            controller: skill,
            style: const TextStyle(
              color: Color(0XFF4E4949),
              fontSize: 8,
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
            ),
          ),
        ),
        GestureDetector(
          onTap: onButtonTap,
          child: const Icon(
            Icons.remove_circle_outline,
            size: 12,
            color: Color(0XFFFF5E59),
          ),
        ),
      ],
    );
  }
}

