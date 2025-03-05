import 'package:flutter/material.dart';
import 'dart:math' as math;

class GradientButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onTap;
  final double height;
  final BorderRadius? borderRadius;
  final List<Color> gradientColors;
  final EdgeInsets padding;
  final TextStyle? textStyle;
  final double? shadowOpacity;
  final Offset? shadowOffset;
  final double? shadowBlurRadius;
  final Widget? child;

  const GradientButton({
    Key? key,
    required this.text,
    this.icon,
    this.onTap,
    this.height = 56.0,
    this.borderRadius,
    this.gradientColors = const [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
    this.padding = const EdgeInsets.symmetric(vertical: 16),
    this.textStyle,
    this.shadowOpacity = 0.3,
    this.shadowOffset = const Offset(0, 10),
    this.shadowBlurRadius = 25,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => {},
      onExit: (_) => {},
      child: Stack(
        children: [
          // 主按钮
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: borderRadius ?? BorderRadius.circular(16),
              onTap: onTap,
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: borderRadius ?? BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: gradientColors,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: gradientColors[0].withOpacity(shadowOpacity ?? 0.3),
                      offset: shadowOffset ?? Offset(0, 10),
                      blurRadius: shadowBlurRadius ?? 25,
                    ),
                  ],
                ),
                child: Container(
                  width: double.infinity,
                  height: height,
                  padding: padding,
                  child: child ?? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, color: Colors.white),
                        SizedBox(width: 8),
                      ],
                      Text(
                        text,
                        style: textStyle ?? TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // 移除扫光效果
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