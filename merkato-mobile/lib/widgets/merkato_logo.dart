import 'package:flutter/material.dart';
import 'package:merkato_mobile/theme/app_theme.dart';

class MerkatoLogoText extends StatelessWidget {
  final double fontSize;
  final bool showTagline;

  const MerkatoLogoText({
    super.key,
    this.fontSize = 18,
    this.showTagline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
            children: const [
              TextSpan(
                text: 'Merkato',
                style: TextStyle(color: AppColors.textDark),
              ),
              TextSpan(
                text: 'Link',
                style: TextStyle(color: AppColors.accentGreen),
              ),
            ],
          ),
        ),
        if (showTagline)
          const Text(
            'የገበያ ቦታ በሊንክ',
            style: TextStyle(
              fontSize: 10,
              color: AppColors.textGrey,
              fontFamily: 'Poppins',
            ),
          ),
      ],
    );
  }
}

class MerkatoLogoImage extends StatelessWidget {
  final double size;

  const MerkatoLogoImage({super.key, this.size = 120});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.jpg',
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
