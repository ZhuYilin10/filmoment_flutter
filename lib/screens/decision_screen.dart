import 'package:flutter/material.dart';
import 'dart:ui';
import '../widgets/gradient_button.dart';
import '../services/movie_service.dart';

// 将枚举移到类的外部
enum ButtonState {
  initial,    // 初始状态：生成推荐
  loading,    // 加载状态：正在生成推荐...
  completed   // 完成状态：开始使用
}

class DecisionScreen extends StatefulWidget {
  @override
  _DecisionScreenState createState() => _DecisionScreenState();
}

class _DecisionScreenState extends State<DecisionScreen> with TickerProviderStateMixin {
  late AnimationController _floatController1, _floatController2;
  late Animation<double> _floatAnimation1, _floatAnimation2;
  bool _isPressed = false;
  final MovieService _movieService = MovieService();
  
  // 添加加载状态
  bool _isLoading = false;
  
  // 添加按钮状态
  ButtonState _buttonState = ButtonState.initial;
  
  // 添加加载动画控制器
  late AnimationController _loadingController;
  late Animation<double> _loadingAnimation;

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

    Future.delayed(Duration(milliseconds: 800), () => _floatController1.forward());
    Future.delayed(Duration(milliseconds: 1300), () => _floatController2.forward());

    // 初始化加载动画
    _loadingController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingController,
      curve: Curves.easeInOut,
    ));

    // 让加载动画循环播放
    _loadingController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _loadingController.reset();
        _loadingController.forward();
      }
    });
  }

  @override
  void dispose() {
    _floatController1.dispose();
    _floatController2.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  // 修改按钮构建方法
  Widget _buildButton() {
    String buttonText;
    IconData? buttonIcon;
    
    switch (_buttonState) {
      case ButtonState.initial:
        buttonText = "生成推荐";
        buttonIcon = Icons.movie_outlined;
        break;
      case ButtonState.loading:
        buttonText = "正在生成推荐...";
        buttonIcon = null;
        break;
      case ButtonState.completed:
        buttonText = "开始使用";
        buttonIcon = Icons.check;
        break;
    }

    return GradientButton(
      text: buttonText,
      icon: buttonIcon,
      onTap: _buttonState == ButtonState.loading ? null : () async {
        if (_buttonState == ButtonState.initial) {
          setState(() {
            _buttonState = ButtonState.loading;
          });
          _loadingController.forward();

          try {
            print('开始获取电影数据...');
            final movies = await _movieService.getRandomPopularMovies(3);
            print('成功获取到 ${movies.length} 部电影');
            for (var movie in movies) {
              print('-------------------');
              print('电影标题: ${movie['title']}');
              print('评分: ${movie['vote_average']}');
              print('简介: ${movie['overview']}');
              print('图片: ${movie['poster_path']}');
              print('上映日期: ${movie['release_date']}');
              print('语言: ${movie['original_language']}');
              print('ID: ${movie['id']}');
            }
            
            setState(() {
              _buttonState = ButtonState.completed;
            });
          } catch (e, stackTrace) {
            print('获取电影数据失败');
            print('错误: $e');
            print('堆栈: $stackTrace');
            // 如果失败，回到初始状态
            setState(() {
              _buttonState = ButtonState.initial;
            });
          } finally {
            _loadingController.stop();
          }
        } else if (_buttonState == ButtonState.completed) {
          // TODO: 处理"开始使用"的点击事件
          print('开始使用点击');
        }
      },
      gradientColors: [Color(0xFF10B981), Color(0xFF059669)],
      child: _buttonState == ButtonState.loading ? AnimatedBuilder(
        animation: _loadingAnimation,
        builder: (context, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  value: _loadingAnimation.value,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
              ),
              SizedBox(width: 12),
              Text(
                "正在生成推荐...",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          );
        },
      ) : null,
    );
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
            top: -MediaQuery.of(context).size.height * 0.05,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF10B981).withOpacity(0.3),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.2,
            left: -150,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF10B981).withOpacity(0.3),
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
                top: MediaQuery.of(context).size.height * 0.15,
                right: MediaQuery.of(context).size.width * 0.1,
                child: Transform.translate(
                  offset: Offset(0, _floatAnimation1.value),
                  child: Transform.rotate(
                    angle: _floatAnimation1.value * 0.02,
                    child: Icon(
                      Icons.check_circle,
                      size: 70,
                      color: Colors.green[400]?.withOpacity(0.8),
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
                bottom: MediaQuery.of(context).size.height * 0.3,
                left: MediaQuery.of(context).size.width * 0.15,
                child: Transform.translate(
                  offset: Offset(0, _floatAnimation2.value),
                  child: Transform.rotate(
                    angle: _floatAnimation2.value * 0.02,
                    child: Icon(
                      Icons.thumb_up,
                      size: 50,
                      color: Colors.green[300]?.withOpacity(0.8),
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
                                      Icons.check_circle,
                                      size: 48,
                                      color: Colors.green[400],
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      "强制决定",
                                      style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.w800,
                                        foreground: Paint()
                                          ..shader = LinearGradient(
                                            colors: [Colors.white, Color(0xFF86EFAC)],
                                          ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      "告别选择困难，\n让我们为你决定今晚的电影",
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
                child: _buildButton(),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 