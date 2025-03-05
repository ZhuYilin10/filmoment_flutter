import 'package:flutter/material.dart';
import 'dart:ui';  // Add this import for ImageFilter
import 'package:flutter/rendering.dart';
import '../widgets/gradient_button.dart';
import '../screens/feature_screen.dart';

class IntroScreen extends StatefulWidget {
  final VoidCallback onNext;
  
  const IntroScreen({Key? key, required this.onNext}) : super(key: key);

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> with TickerProviderStateMixin {
  late AnimationController _controller1, _controller2, _controller3;
  late Animation<double> _floatAnimation1, _floatAnimation2, _floatAnimation3;

  @override
  void initState() {
    super.initState();

    // 初始化三个动画控制器，分别对应三个浮动图标
    _controller1 = AnimationController(
      duration: Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: true);
    _controller2 = AnimationController(
      duration: Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: true);
    _controller3 = AnimationController(
      duration: Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: true);

    // 定义浮动动画，使用 Tween 和 CurvedAnimation
    _floatAnimation1 = Tween<double>(begin: 0, end: -30).animate(
      CurvedAnimation(parent: _controller1, curve: Curves.easeInOut),
    );
    _floatAnimation2 = Tween<double>(begin: 0, end: -30).animate(
      CurvedAnimation(parent: _controller2, curve: Curves.easeInOut),
    );
    _floatAnimation3 = Tween<double>(begin: 0, end: -30).animate(
      CurvedAnimation(parent: _controller3, curve: Curves.easeInOut),
    );

    // 设置延迟效果
    Future.delayed(Duration(seconds: 1), () => _controller2.forward());
    Future.delayed(Duration(seconds: 2), () => _controller3.forward());
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    
    return Scaffold(
      body: Stack(
        children: [
          // 背景渐变
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF070724),
                  Color(0xFF0E0E36),
                  Color(0xFF170A4D),
                ],
              ),
            ),
          ),
          
          // 圆形背景效果
          Positioned(
            top: MediaQuery.of(context).size.height * 0.2,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF8B5CF6).withOpacity(0.1),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.1,
            right: -150,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF8B5CF6).withOpacity(0.1),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          
          // 浮动图标
          AnimatedBuilder(
            animation: _floatAnimation1,
            builder: (context, child) {
              return Positioned(
                top: 100,
                right: 40,
                child: Transform.translate(
                  offset: Offset(0, _floatAnimation1.value),
                  child: Transform.rotate(
                    angle: _floatAnimation1.value * 0.02,
                    child: Icon(
                      Icons.movie,
                      size: 70,
                      color: Colors.amber.withOpacity(0.6),
                    ),
                  ),
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _floatAnimation2,
            builder: (context, child) {
              return Positioned(
                top: 250,
                left: 50,
                child: Transform.translate(
                  offset: Offset(0, _floatAnimation2.value),
                  child: Transform.rotate(
                    angle: _floatAnimation2.value * 0.02,
                    child: Icon(
                      Icons.local_activity,
                      size: 50,
                      color: Colors.indigo.withOpacity(0.6),
                    ),
                  ),
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _floatAnimation3,
            builder: (context, child) {
              return Positioned(
                bottom: 200,
                right: 60,
                child: Transform.translate(
                  offset: Offset(0, _floatAnimation3.value),
                  child: Transform.rotate(
                    angle: _floatAnimation3.value * 0.02,
                    child: Icon(
                      Icons.videocam,
                      size: 40,
                      color: Colors.purple.withOpacity(0.6),
                    ),
                  ),
                ),
              );
            },
          ),
          
          // 前景内容
          Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 特性卡片
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            padding: EdgeInsets.all(30),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(30, 30, 60, 0.2),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.05),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "片刻",
                                  style: TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    foreground: Paint()
                                      ..shader = LinearGradient(
                                        colors: [Colors.white, Color(0xFFC4B5FD)],
                                      ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
                                  ),
                                ),
                                Text(
                                  "FilMoment",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    foreground: Paint()
                                      ..shader = LinearGradient(
                                        colors: [Colors.white.withOpacity(0.9), Color(0xFFA5B4FC).withOpacity(0.8)],
                                      ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  "光影中的永恒，刹那成永恒",
                                  style: TextStyle(color: Colors.white70, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 20),
                      
                      // 附加描述
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          "不再为选择而烦忧\n每一刻，都值得被光影铭记",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            height: 1.7,
                            fontFamily: 'Noto Serif SC',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // 底部按钮
              Padding(
                padding: EdgeInsets.only(
                  left: 16, 
                  right: 16, 
                  bottom: 8 + bottomPadding
                ),
                child: GradientButton(
                  text: "开始探索",
                  icon: Icons.arrow_forward,
                  onTap: widget.onNext,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIndicatorDot(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: isActive ? 32 : 24,
      height: 4,
      decoration: BoxDecoration(
        color: isActive ? Color(0xFFC4B5FD) : Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}


