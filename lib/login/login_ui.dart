// login_page_ui.dart
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:solveathon/login/login_method.dart';
import 'package:solveathon/widgets/buttons/sign_in_button.dart';

class CarouselItem {
  final String imagePath;
  final String title;
  final String description;

  CarouselItem({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}

class LoginPageUI extends StatelessWidget {
  final LoginPageLogic logic;

  const LoginPageUI({super.key, required this.logic});

  @override
  Widget build(BuildContext context) {
    logic.checkLoggedIn(context);

    final List<CarouselItem> carouselItems = [
      CarouselItem(
        imagePath: 'assets/laundry_icon.png',
        title: 'Chhota Dhobi',
        description: 'Manage your laundry schedule with ease and convenience.',
      ),
      CarouselItem(
        imagePath: 'assets/complaint_icon.png',
        title: 'Hostel Complaint',
        description:
            'Raise any maintenance issues quickly and get them resolved.',
      ),
      CarouselItem(
        imagePath: 'assets/mess_icon.png',
        title: 'Mess Management',
        description:
            'Order food from the mess and manage your meal plans effortlessly.',
      ),
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2C2C2E),
              Color(0xFF1B1B1D),
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 20),
                Image.asset(
                  'assets/vit_logo.png',
                  width: 330,
                  height: 130,
                ),
                // Image.asset(
                //   'assets/DEVSHOUSE.png',
                //   width: 250,
                //   height: 130,
                // ),
                const SizedBox(height: 40),
                CarouselSlider(
                  options: CarouselOptions(
                    height: 200,
                    viewportFraction: 0.8,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    aspectRatio: 2.0,
                  ),
                  items: carouselItems.map((item) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(15), // Rounded corners
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                spreadRadius: 0,
                                blurRadius: 10,
                                offset: const Offset(2, 4),
                              ),
                            ],
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.black.withOpacity(0.7),
                                Colors.grey[900]!,
                              ],
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                        item.imagePath,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.title,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 7),
                                      Text(
                                        item.description,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 40),
                CustomSignInButton(
                  onPressed: () async {
                    await logic.signInWithGoogle(context);
                    await logic.checkLoggedIn(context);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
