import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:solveathon/widgets/drawer/info_row.dart';

class CustomDrawerHeader extends StatelessWidget {
  const CustomDrawerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    String avatarImage = 'assets/5024509.png';

    return Container(
      padding: const EdgeInsets.only(
          top: 48.0, bottom: 16.0, left: 16.0, right: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage(avatarImage),
            backgroundColor: Colors.transparent,
          ),
          const SizedBox(height: 10),
          AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                'Rudresh Pandey',
                textStyle: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black.withOpacity(0.5),
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                speed: const Duration(milliseconds: 70),
              ),
            ],
            totalRepeatCount: 1,
          ),
          const SizedBox(height: 10),
          InfoRow(
            icon: Icons.credit_card,
            label: 'Reg. No',
            value: '22BCE1182',
            iconColor: Colors.amber.shade400,
          ),
          InfoRow(
            icon: Icons.meeting_room,
            label: 'Room Number',
            value: 'A-519',
            iconColor: Colors.lightGreenAccent.shade400,
          ),
          InfoRow(
            icon: Icons.restaurant,
            label: 'Mess',
            value: 'Veg - CRCL',
            iconColor: Colors.blue.shade400,
          ),
          const SizedBox(height: 10),
          const Divider(color: Colors.white54, thickness: 1.0),
        ],
      ),
    );
  }
}
