import 'package:flutter/material.dart';

//API
const baseUrl = 'https://api-cvlab.crewdog.ai';

// Colors
const Color kPrimaryColor = Color(0xFF161717);
const Color kHighlightedColor = Color(0xFFFF5E59);
const Color kPurple = Color(0xFFC6A4FF);
const Color kLightOrange = Color(0xFFFFEFEE);
const Color kLightPurple = Color(0xFFF8F5FE);
const Color kLightGrey = Color(0xFF95969D);
const Color kBlue = Color(0xFF06A3F5);

// Text Styles
const TextStyle kHeadingTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 24.0,
  fontWeight: FontWeight.bold,
);
const TextStyle kHeadingTextStyleSmallScreen = TextStyle(
  color: Colors.black,
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
);
const TextStyle kHeadingTextStyle600 = TextStyle(
  color: Color(0xFF263238),
  fontSize: 24.0,
  fontWeight: FontWeight.w600,
);

const TextStyle kFadedText = TextStyle(
  fontSize: 10,
  color: Color(0xFFA1A1A1),
);

const TextStyle kSubHeadingTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 10.0,

  //letterSpacing: 2.5,
  fontWeight: FontWeight.w400,
);

const TextStyle kButtonTextStyle = TextStyle(
  fontSize: 20,
  color: Color(0xFFFFFFFF),
);
const TextStyle kButtonTextStyleSmallScreen = TextStyle(
  fontSize: 16,
  color: Color(0xFFFFFFFF),
);

const TextStyle kDividerTextStyle = TextStyle(
  fontSize: 15,
  color: Colors.white,
);

const TextStyle kGoogleButtonTextStyle = TextStyle(
  fontSize: 15,
  color: Colors.white,
);

const TextStyle kLoginSignupOptionTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 15.0,
  fontWeight: FontWeight.w500,
);

const TextStyle kForgetPasswordTextStyle = TextStyle(
  color: kHighlightedColor,
  fontSize: 10.0,
  fontWeight: FontWeight.w500,
);

const TextStyle kTextFieldTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 15.0,
  fontWeight: FontWeight.w500,
);

const TextStyle kHintTextStyle = TextStyle(
  fontSize: 15,
  color: Colors.white,
);
//super user
const TextStyle kSuperUserMainScreenHeading = TextStyle(
  fontSize: 20,
  color: Colors.white,
);

const TextStyle kSuperUserMainScreenCardTextStyle = TextStyle(
  fontSize: 14,
  color: Colors.white,
);
const TextStyle kFont11 = TextStyle(
  fontSize: 11,
  color: Colors.white,
);

const TextStyle kFont12 = TextStyle(
  fontSize: 12,
  color: Colors.white,
);
const TextStyle kFont12Grey = TextStyle(
  fontSize: 12,
  color: Color(0xFF95969D),
);
const TextStyle kFont12GreySmallScreen = TextStyle(
  fontSize: 10,
  color: Color(0xFF95969D),
);
const TextStyle kFont13black500 =
TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w500);

const TextStyle kFont14 = TextStyle(
  fontSize: 14,
  color: Colors.white,
);
const TextStyle kFont14black600 =
    TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w600);
const TextStyle kFont24Username = TextStyle(
  fontSize: 24,
  color: kHighlightedColor,
  fontWeight: FontWeight.bold,
);
const TextStyle kFont24 = TextStyle(
  fontSize: 24,
  color: Colors.black,
  fontWeight: FontWeight.bold,
);
const TextStyle kFont24SmallScreen = TextStyle(
  fontSize: 20,
  color: Colors.black,
  fontWeight: FontWeight.bold,
);
const TextStyle kFont20White = TextStyle(
  fontSize: 20,
  color: Colors.white,
);
const TextStyle kFont14Black = TextStyle(
  fontSize: 14,
  color: Colors.black,
);
const TextStyle dialogButtonTextStyle = TextStyle(
  fontSize: 16,
// fontWeight: FontWeight.w500
);

const TextStyle kFont8 = TextStyle(
  fontSize: 8,
  color: Colors.white,
);
const TextStyle kFont8Black = TextStyle(
  fontSize: 8,
  color: Colors.black,
);

const TextStyle kFont10 = TextStyle(
  fontSize: 10,
  color: Colors.white,
);
const TextStyle kFont7 = TextStyle(
  fontSize: 7,
  color: Color(0xFFB1B1B1),
);

const TextStyle kSuperUserHeadings = TextStyle(
  fontSize: 15,
  color: Colors.white,
);

const TextStyle kDrawerItemTextStyle = TextStyle(color: Colors.white);

const TextStyle kBottomLoginSignupTextStyle = TextStyle(
  color: Color(0xff1D90F5),
  fontSize: 15.0,
  fontWeight: FontWeight.w500,
);

const TextStyle kPageNameTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 14.0,
  fontWeight: FontWeight.w400,
);

const TextStyle kWelcomeUserTextStyle = TextStyle(
  color: Color(0xFFD1000B),
  fontSize: 20.0,
  fontWeight: FontWeight.w400,
);

const TextStyle kEmployeeNameMainScreen = TextStyle(
  color: Colors.white,
  fontSize: 20.0,
  fontWeight: FontWeight.w500,
);

const kTextFieldDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  hintStyle: TextStyle(color: Color(0xFF95969D)),
  hintText: 'Enter a value',
  contentPadding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFF1F1F1), width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFFFFFFF), width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
  ),
);

const kCalendarStyle = ButtonStyle(
  elevation: MaterialStatePropertyAll(4.0),
  backgroundColor: MaterialStatePropertyAll(Colors.white),
);

/// button styles here

ButtonStyle kInitialChatButton = ElevatedButton.styleFrom(
  backgroundColor: Colors.white,
  shape: const RoundedRectangleBorder(
    side: BorderSide(color: kPurple),
    borderRadius: BorderRadius.only(
      topRight: Radius.circular(10.0),
      bottomLeft: Radius.circular(10.0),
      bottomRight: Radius.circular(10.0),
    ),
  ),
);

ButtonStyle kElevatedButtonStyle = ElevatedButton.styleFrom(
  elevation: 5,
  shadowColor: const Color(0x9696BEE7),
  backgroundColor: const Color(0xFFFF5E59),
  padding: const EdgeInsets.symmetric(
    vertical: 10,
    horizontal: 10,
  ),
  minimumSize: const Size(double.infinity, 0),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5.0),
    side: const BorderSide(color: Color(0xFFFF5E59)),
  ),
);

ButtonStyle kElevatedButtonWithWhiteColor = ElevatedButton.styleFrom(
  backgroundColor: Colors.white,
  padding: const EdgeInsets.symmetric(
    vertical: 10,
    horizontal: 10,
  ),
  minimumSize: const Size(double.infinity, 0),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5.0),
    side: const BorderSide(color: Color(0xFFFF5E59)),
  ),
);

ButtonStyle kElevatedButtonGreyBG = ElevatedButton.styleFrom(
  backgroundColor: const Color(0x4E494933),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5.0),
    side: const BorderSide(color: Color(0xFFFF5E59)),
  ),
);

ButtonStyle kElevatedButtonWhiteOpacityBG = ElevatedButton.styleFrom(
  backgroundColor: const Color(0x99FFFFFF),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5.0),
  ),
);
ButtonStyle kElevatedButtonPrimaryBG = ElevatedButton.styleFrom(
  backgroundColor: const Color(0xFFFF5E59),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5.0),
    side: const BorderSide(color: Color(0xFFFF5E59)),
  ),
);

ButtonStyle kCheckIn = ElevatedButton.styleFrom(
  backgroundColor: Colors.white,
  padding: const EdgeInsets.symmetric(
    vertical: 8,
    horizontal: 50,
  ),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5.0),
    side: const BorderSide(color: Colors.black),
  ),
);

ButtonStyle kUserCheckOut = ElevatedButton.styleFrom(
  backgroundColor: const Color(0x1A000000),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5.0),
    side: const BorderSide(
      color: Color(0x1AFFFFFF),
    ),
  ),
);

ButtonStyle kApplyLeave = ElevatedButton.styleFrom(
  backgroundColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5.0),
    side: const BorderSide(color: Colors.black),
  ),
);
