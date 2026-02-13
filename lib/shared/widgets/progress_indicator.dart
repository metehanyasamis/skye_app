import 'package:flutter/material.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/debug_logger.dart';

/// Reusable progress indicator widget
/// Shows current step and total steps with visual progress bar
/// Uses small circles (10x10) with connecting lines
/// Includes animation when step changes
class ProgressIndicator extends StatefulWidget {
  const ProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.activeColor,
    this.inactiveColor,
  });

  final int currentStep;
  final int totalSteps;
  /// Override color for completed/current steps
  final Color? activeColor;
  /// Override color for pending steps
  final Color? inactiveColor;

  @override
  State<ProgressIndicator> createState() => _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<ProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _previousStep = 1;

  @override
  void initState() {
    super.initState();
    _previousStep = widget.currentStep;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(ProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentStep != widget.currentStep) {
      _previousStep = oldWidget.currentStep;
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DebugLogger.log('ProgressIndicator', 'build', {
      'currentStep': widget.currentStep,
      'totalSteps': widget.totalSteps,
    });

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.totalSteps, (index) {
        final stepNumber = index + 1;
        final isActive = stepNumber <= widget.currentStep;
        final wasActive = stepNumber <= _previousStep;
        
        return Row(
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                // Animate color transition
                final active = widget.activeColor ?? AppColors.navy800;
                final inactive = widget.inactiveColor ?? AppColors.borderLight;
                Color circleColor;
                if (isActive && !wasActive) {
                  circleColor = Color.lerp(inactive, active, _animation.value)!;
                } else if (isActive) {
                  circleColor = active;
                } else {
                  circleColor = inactive;
                }

                return Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: circleColor,
                  ),
                );
              },
            ),
            if (index < widget.totalSteps - 1)
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  // Animate line color transition
                  final lineIsActive = stepNumber < widget.currentStep;
                  final lineWasActive = stepNumber < _previousStep;
                  
                  final active = widget.activeColor ?? AppColors.navy800;
                  final inactive = widget.inactiveColor ?? AppColors.borderLight;
                  Color lineColor;
                  if (lineIsActive && !lineWasActive) {
                    lineColor = Color.lerp(inactive, active, _animation.value)!;
                  } else if (lineIsActive) {
                    lineColor = active;
                  } else {
                    lineColor = inactive;
                  }

                  return Container(
                    width: 15,
                    height: 1,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    color: lineColor,
                  );
                },
              ),
          ],
        );
      }),
    );
  }
}
