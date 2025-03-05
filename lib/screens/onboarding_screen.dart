import 'package:flutter/material.dart';
import 'intro_screen.dart';
import 'feature_screen.dart';
import 'decision_screen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // 更新颜色常量，添加第三个颜色
  final Color _purpleColor = Color(0xFFC4B5FD);  // 第一页的紫色
  final Color _blueColor = Color(0xFF93C5FD);    // 第二页的蓝色
  final Color _greenColor = Color(0xFF86EFAC);   // 第三页的绿色

  // 更新获取颜色的方法
  Color _getIndicatorColor(bool isActive) {
    if (!isActive) return Colors.white.withOpacity(0.3);
    
    double page = _pageController.hasClients ? _pageController.page ?? 0 : 0;
    
    if (page < 1) {
      return Color.lerp(_purpleColor, _blueColor, page) ?? _purpleColor;
    } else {
      return Color.lerp(_blueColor, _greenColor, page - 1) ?? _blueColor;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            // 禁用手动滑动
            physics: NeverScrollableScrollPhysics(),
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: [
              IntroScreen(onNext: () {
                _pageController.animateToPage(
                  1,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              }),
              FeatureScreen(onNext: () {
                _pageController.animateToPage(
                  2,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              }),
              DecisionScreen(),
            ],
          ),
          // 统一的指示器
          AnimatedBuilder(
            animation: _pageController,
            builder: (context, child) {
              return Positioned(
                bottom: MediaQuery.of(context).padding.bottom + 80,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildIndicator(0),
                    SizedBox(width: 8),
                    _buildIndicator(1),
                    SizedBox(width: 8),
                    _buildIndicator(2),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: _currentPage == index ? 32 : 24,
      height: 4,
      decoration: BoxDecoration(
        color: _getIndicatorColor(_currentPage == index),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
} 