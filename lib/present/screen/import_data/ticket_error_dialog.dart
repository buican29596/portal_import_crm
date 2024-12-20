import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:portal_hotel/res/colors.dart';
import 'package:portal_hotel/res/icons.dart';

class ImportErrorDialog extends StatelessWidget {
  final String title;
  final String mess;
  const ImportErrorDialog({
    super.key, this.mess = 'Tải lên thất bại',this.title = '',
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        width: 440,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 56),
            SvgPicture.asset(NSGIcons.error, width: 80, height: 80),
            const SizedBox(height: 24),
            if(title.isNotEmpty)...[
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
            ],
            Text(
              mess,
              style: const TextStyle(
                fontSize: 16,
                color: grey,
              ),
            ),
            const SizedBox(height: 42),
            const Divider(),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey.shade300,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 56),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(8), // Đặt border radius là 8
                ),
              ),
              child: const Text(
                'Đóng',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
