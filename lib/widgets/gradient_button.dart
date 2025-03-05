import 'package:flutter/material.dart';
import 'dart:math' as math;

class GradientButton extends StatefulWidget {
  final String text;
  final IconData? icon;
  final VoidCallback onTap;
  final double height;
  final BorderRadius? borderRadius;
  final List<Color> gradientColors;
  final EdgeInsets padding;
  final TextStyle? textStyle;
  final double? shadowOpacity;
  final Offset? shadowOffset;
  final double? shadowBlurRadius;

  const GradientButton({
    Key? key,
    required this.text,
    this.icon,
    required this.onTap,
    this.height = 56.0,
    this.borderRadius,
    this.gradientColors = const [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
    this.padding = const EdgeInsets.symmetric(vertical: 16),
    this.textStyle,
    this.shadowOpacity = 0.3,
    this.shadowOffset = const Offset(0, 10),
    this.shadowBlurRadius = 25,
  }) : super(key: key);

  @override
  _GradientButtonState createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    
    // 创建动画控制器 - 延长动画时间到4秒
    _controller = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );
    
    // 创建动画曲线
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    // 开始动画并设置重复
    _controller.repeat(reverse: false);
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: Stack(
        children: [
          // 主按钮
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
              onTap: widget.onTap,
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: widget.gradientColors,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.gradientColors[0].withOpacity(widget.shadowOpacity ?? 0.3),
                      offset: widget.shadowOffset ?? Offset(0, 10),
                      blurRadius: widget.shadowBlurRadius ?? 25,
                    ),
                  ],
                ),
                child: Container(
                  width: double.infinity,
                  height: widget.height,
                  padding: widget.padding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.text,
                        style: widget.textStyle ?? TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.0,
                          fontFamily: 'Noto Serif SC',
                        ),
                      ),
                      if (widget.icon != null) ...[
                        SizedBox(width: 8),
                        Icon(widget.icon, color: Colors.white),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // HTML风格扫光效果
          IgnorePointer(
            child: ClipRRect(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
              child: SizedBox(
                height: widget.height,
                width: double.infinity,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: SweepLightPainter(
                        progress: _animation.value,
                        isHovering: _isHovering,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SweepLightPainter extends CustomPainter {
  final double progress;
  final bool isHovering;
  
  SweepLightPainter({required this.progress, required this.isHovering});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final rect = Rect.fromLTWH(
      -size.width, 
      -size.height,
      size.width * 3,
      size.height * 3
    );
    
    // 创建45度旋转的渐变
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.transparent,
        Colors.white.withOpacity(0.1),
        Colors.transparent,
      ],
      stops: [0.35, 0.5, 0.65],
    ).createShader(rect);
    
    paint.shader = gradient;
    
    // 保存当前画布状态
    canvas.save();
    
    // 旋转画布45度
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(math.pi / 4);
    canvas.translate(-size.width / 2, -size.height / 2);
    
    // 根据动画进度移动位置
    final x = size.width * 2 * progress - size.width;
    final y = size.height * 2 * progress - size.height;
    canvas.translate(x, y);
    
    // 绘制矩形
    canvas.drawRect(rect, paint);
    
    // 恢复画布状态
    canvas.restore();
  }
  
  @override
  bool shouldRepaint(SweepLightPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isHovering != isHovering;
  }
} 