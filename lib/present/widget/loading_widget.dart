import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:portal_hotel/res/images.dart';
import 'package:portal_hotel/res/lotties.dart';

class NLLoadingWidget extends StatelessWidget {
  final String? message;

  const NLLoadingWidget({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          width: 112,
          height: 112,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 40,
                child: Lottie.asset(NSGLottie.loading, height: 82),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 18,
                child: Image.asset(NSGImages.novaLogo, width: 52, height: 52),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
