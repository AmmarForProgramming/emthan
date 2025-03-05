import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './screens/auth/login_screen.dart'; // تأكد من استيراد صفحة تسجيل الدخول

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              _buildPage(
                image: 'assets/images/٢٠٢٢٠٨١٥_١٦٥٩١٥.jpg', // استبدل بصورة مناسبة
                title: "مرحبًا بك في تطبيقنا!",
                description: "تجربة رائعة لإدارة متجرك بكل سهولة وكفاءة.",
              ),
              _buildPage(
                image: 'assets/images/onboarding2.png', // استبدل بصورة مناسبة
                title: "إدارة متقدمة!",
                description: "قم بإدارة منتجاتك ومبيعاتك بسهولة تامة عبر التطبيق.",
              ),
            ],
          ),

          // **أزرار التنقل (التالي / تخطي)**
          Positioned(
            bottom: 50,
            left: 20,
            child: _currentPage > 0
                ? TextButton(
                    onPressed: () {
                      _pageController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Text("السابق", style: TextStyle(fontSize: 18)),
                  )
                : SizedBox(),
          ),
          Positioned(
            bottom: 50,
            right: 20,
            child: _currentPage == 1
                ? TextButton(
                    onPressed: () => _completeOnboarding(context),
                    child: Text("ابدأ الآن", style: TextStyle(fontSize: 18)),
                  )
                : TextButton(
                    onPressed: () {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Text("التالي", style: TextStyle(fontSize: 18)),
                  ),
          ),

          // **زر "تخطي" أعلى الشاشة**
          Positioned(
            top: 40,
            right: 20,
            child: TextButton(
              onPressed: () => _completeOnboarding(context),
              child: Text("تخطي", style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  /// **🔹 تصميم كل صفحة في Onboarding**
  Widget _buildPage({required String image, required String title, required String description}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(image, height: 250),
        SizedBox(height: 20),
        Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Text(description, textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }

  /// **🔹 إنهاء الشاشات التمهيدية وحفظ الحالة**
  Future<void> _completeOnboarding(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("onboarding_completed", true);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}