import 'package:flutter/material.dart';
import 'dart:ui';
import '../widgets/gradient_button.dart';

class FeatureScreen extends StatefulWidget {
  final VoidCallback onNext;  // 添加 onNext 回调参数
  
  const FeatureScreen({
    Key? key,
    required this.onNext,
  }) : super(key: key);

  @override
  _FeatureScreenState createState() => _FeatureScreenState();
}

class _FeatureScreenState extends State<FeatureScreen> with TickerProviderStateMixin {
  late AnimationController _floatController1, _floatController2;
  late Animation<double> _floatAnimation1, _floatAnimation2;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();

    _floatController1 = AnimationController(
      duration: Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: true);
    _floatController2 = AnimationController(
      duration: Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: true);

    _floatAnimation1 = Tween<double>(begin: 0, end: -30).animate(
      CurvedAnimation(parent: _floatController1, curve: Curves.easeInOut),
    );
    _floatAnimation2 = Tween<double>(begin: 0, end: -30).animate(
      CurvedAnimation(parent: _floatController2, curve: Curves.easeInOut),
    );

    // 设置延迟效果
    Future.delayed(Duration(seconds: 1), () => _floatController2.forward());
  }

  @override
  void dispose() {
    _floatController1.dispose();
    _floatController2.dispose();
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
            top: MediaQuery.of(context).size.height * 0.1,
            right: -150,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF3B82F6).withOpacity(0.3),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF3B82F6).withOpacity(0.3),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          
          // 浮动图标
          AnimatedBuilder(
            animation: _floatAnimation1,
            builder: (context, child) {
              return Positioned(
                top: MediaQuery.of(context).size.height * 0.2,
                left: MediaQuery.of(context).size.width * 0.15,
                child: Transform.translate(
                  offset: Offset(0, _floatAnimation1.value),
                  child: Transform.rotate(
                    angle: _floatAnimation1.value * 0.02,
                    child: Icon(
                      Icons.smart_toy,
                      size: 70,
                      color: Colors.blue[400]?.withOpacity(0.8),
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
                bottom: MediaQuery.of(context).size.height * 0.4,
                right: MediaQuery.of(context).size.width * 0.15,
                child: Transform.translate(
                  offset: Offset(0, _floatAnimation2.value),
                  child: Transform.rotate(
                    angle: _floatAnimation2.value * 0.02,
                    child: Icon(
                      Icons.psychology,
                      size: 50,
                      color: Colors.blue[300]?.withOpacity(0.8),
                    ),
                  ),
                ),
              );
            },
          ),
          
          // 主要内容
          Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 特性卡片
                      GestureDetector(
                        onTapDown: (_) => setState(() => _isPressed = true),
                        onTapUp: (_) => setState(() => _isPressed = false),
                        onTapCancel: () => setState(() => _isPressed = false),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 150),
                          transform: Matrix4.identity()
                            ..scale(_isPressed ? 0.98 : 1.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 24),
                                padding: EdgeInsets.all(30),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(30, 30, 60, 0.4),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.1),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 30,
                                      spreadRadius: -10,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.smart_toy,
                                      size: 48,
                                      color: Colors.blue[400],
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      "精准推荐",
                                      style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.w800,
                                        foreground: Paint()
                                          ..shader = LinearGradient(
                                            colors: [Colors.white, Color(0xFF93C5FD)],
                                          ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      "我们的算法每天精选三部与你\n品味相符的电影，避免选择困难",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 16,
                                        height: 1.6,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
                  text: "下一步",
                  icon: Icons.arrow_forward,
                  onTap: widget.onNext,  // 使用传入的 onNext 回调
                  gradientColors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
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
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        gradient: isActive
            ? LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
              )
            : null,
        color: isActive ? null : Colors.white.withOpacity(0.3),
      ),
    );
  }
} 