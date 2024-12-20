import 'package:flutter/material.dart';

const primaryColor = Color(0xFF5F9E45);
const secondaryColor = Color(0xFF1B5C81);
const green = Color(0xFF5CA81A);
const blue = Color(0xFF007AFF);
const yellow = Color(0xFFF39524);
const red = Color(0xFFF54133);
const pigment = Color(0xFFAB5514);
const auroMetalSaurus = Color(0xFF637381);
const grey = Color(0xFF919EAB);

class NSGColorScheme {
  final MaterialColor primary;
  final MaterialColor secondary;
  final MaterialColor success;
  final MaterialColor info;
  final MaterialColor warning;
  final MaterialColor error;
  final MaterialColor gray;
  final Color white;
  final Color gray300;
  final Color gray400;
  final Color gray500;
  final Color neutral40;
  final Color neutral50;
  final Color neutral60;

  NSGColorScheme({
    required this.primary,
    required this.secondary,
    required this.error,
    required this.warning,
    required this.info,
    required this.success,
    required this.white,
    required this.gray,
    required this.gray300,
    required this.gray400,
    required this.gray500,
    required this.neutral40,
    required this.neutral50,
    required this.neutral60,
  });

  factory NSGColorScheme.light() => NSGColorScheme(
        white: const Color(0xffffffff),
        gray300: const Color(0xFFD0D5DD),
        gray400: const Color(0xFF98A2B3),
        gray500: const Color(0xFF667085),
        neutral40: const Color(0xFFC3C8CE),
        neutral50: const Color(0xFFA0A4B0),
        neutral60: const Color(0xFF475467),
        primary: MaterialColor(primaryColor.value, const {
          10: Color(0xFFF2F8ED),
          20: Color(0xFFE1EFD8),
          30: Color(0xFF9ECE88),
          40: Color(0xFF7DB962),
          50: Color(0xFF5F9E45),
          60: Color(0xFF4C7E37),
          70: Color(0xFF395F29),
          80: Color(0xFF304D27),
          90: Color(0xFF2B4324),
          100: Color(0xFF142310),
        }),
        secondary: MaterialColor(secondaryColor.value, const {
          10: Color(0xFFF2F9FD),
          20: Color(0xFFBCD2DE),
          30: Color(0xFF87ABBF),
          40: Color(0xFF5183A0),
          50: Color(0xFF1B5C81),
          60: Color(0xFF16527A),
          70: Color(0xFF104874),
          80: Color(0xFF0B3F6D),
          90: Color(0xFF053567),
          100: Color(0xFF002B60),
        }),
        error: MaterialColor(red.value, const {
          10: Color(0xFFFFF7F6),
          20: Color(0xFFFEF2F2),
          30: Color(0xFFFBBBB6),
          40: Color(0xFFF9938B),
          50: Color(0xFFF54133),
        }),
        warning: MaterialColor(yellow.value, const {
          10: Color(0xFFFEFAF1),
          20: Color(0xFFFEF3E5),
          30: Color(0xFFFBDBB5),
          40: Color(0xFFF8C485),
          50: Color(0xFFF39524),
        }),
        success: MaterialColor(green.value, const {
          10: Color(0xFFF7FFF0),
          20: Color(0xFFECFBDF),
          30: Color(0xFFCDF3A3),
          40: Color(0xFFACE86E),
          50: Color(0xFF5CA81A),
        }),
        info: MaterialColor(blue.value, const {
          10: Color(0xFFF5FAFF),
          20: Color(0xFFEBF5FF),
          30: Color(0xFFB8DAFF),
          40: Color(0xFF5CAAFF),
          50: Color(0xFF007AFF),
        }),
        gray: const MaterialColor(0xFF667085, {
          25: Color(0xFFEDE3DB),
          50: Color(0xFFF9FAFB),
          100: Color(0xFFF2F4F7),
          200: Color(0xFFEAECF0),
          300: Color(0xFFD0D5DD),
          400: Color(0xFF707070),
          500: Color(0xFF667085),
          600: Color(0xFF475467),
          700: Color(0xFF3A773C),
          800: Color(0xFF30643C),
          900: Color(0xFF101828),
        }),
      );
}
