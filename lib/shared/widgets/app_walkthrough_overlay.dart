import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum AppWalkthroughTarget {
  bottomNav,
  settingsButton,
  themeButton,
}

class AppWalkthroughStep {
  const AppWalkthroughStep({
    required this.title,
    required this.description,
    this.assetPath,
    this.icon,
    this.navSlot = 2,
    this.target = AppWalkthroughTarget.bottomNav,
  });

  final String title;
  final String description;
  final String? assetPath;
  final IconData? icon;
  final int navSlot;
  final AppWalkthroughTarget target;
}

class AppWalkthroughOverlay extends StatelessWidget {
  const AppWalkthroughOverlay({
    super.key,
    required this.steps,
    required this.currentStep,
    required this.onNext,
    required this.onBack,
    required this.onSkip,
  });

  final List<AppWalkthroughStep> steps;
  final int currentStep;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final VoidCallback onSkip;

  static const Color _accent = Color(0xFF12BFF3);
  static const Color _surface = Color(0xF2181B20);

  @override
  Widget build(BuildContext context) {
    final step = steps[currentStep];
    final isFirst = currentStep == 0;
    final isLast = currentStep == steps.length - 1;

    return Material(
      color: Colors.transparent,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;
          final topInset = MediaQuery.paddingOf(context).top;
          final bottomInset = MediaQuery.paddingOf(context).bottom;
          final slotWidth = width / 5;
          final target = _TargetMetrics.fromStep(
            step: step,
            width: width,
            height: height,
            topInset: topInset,
            bottomInset: bottomInset,
            slotWidth: slotWidth,
          );
          final cardWidth = (width - 32).clamp(0.0, 360.0);
          final cardLeft = ((width - cardWidth) / 2).clamp(16.0, width);
          final pointerLeft = (target.pointerCenterX - cardLeft - 12).clamp(
            22.0,
            cardWidth - 46.0,
          );

          return Stack(
            children: [
              Positioned.fill(
                child: ColoredBox(color: Colors.black.withOpacity(0.66)),
              ),
              Positioned(
                left: target.left,
                top: target.top,
                width: target.width,
                height: target.height,
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: _accent, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: _accent.withOpacity(0.55),
                          blurRadius: 28,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: cardLeft,
                right: width - cardLeft - cardWidth,
                top: target.cardOnTop ? target.cardTop : null,
                bottom: target.cardOnTop ? null : target.cardBottom,
                child: _WalkthroughCard(
                  step: step,
                  stepNumber: currentStep + 1,
                  totalSteps: steps.length,
                  isFirst: isFirst,
                  isLast: isLast,
                  pointerLeft: pointerLeft,
                  pointerOnTop: target.cardOnTop,
                  onBack: onBack,
                  onNext: onNext,
                  onSkip: onSkip,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TargetMetrics {
  const _TargetMetrics({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.pointerCenterX,
    required this.cardOnTop,
    required this.cardTop,
    required this.cardBottom,
  });

  final double left;
  final double top;
  final double width;
  final double height;
  final double pointerCenterX;
  final bool cardOnTop;
  final double cardTop;
  final double cardBottom;

  factory _TargetMetrics.fromStep({
    required AppWalkthroughStep step,
    required double width,
    required double height,
    required double topInset,
    required double bottomInset,
    required double slotWidth,
  }) {
    if (step.target == AppWalkthroughTarget.settingsButton) {
      return _TargetMetrics(
        left: 14,
        top: topInset + 4,
        width: 54,
        height: 54,
        pointerCenterX: 41,
        cardOnTop: true,
        cardTop: topInset + 76,
        cardBottom: 0,
      );
    }

    if (step.target == AppWalkthroughTarget.themeButton) {
      return _TargetMetrics(
        left: width - 68,
        top: topInset + 4,
        width: 54,
        height: 54,
        pointerCenterX: width - 41,
        cardOnTop: true,
        cardTop: topInset + 76,
        cardBottom: 0,
      );
    }

    final focusWidth = step.navSlot == 2 ? 72.0 : 66.0;
    final focusHeight = step.navSlot == 2 ? 66.0 : 58.0;
    final focusLeft = slotWidth * step.navSlot + (slotWidth - focusWidth) / 2;
    final focusBottom = step.navSlot == 2 ? 16.0 + bottomInset : 7.0 + bottomInset;

    return _TargetMetrics(
      left: focusLeft,
      top: height - focusBottom - focusHeight,
      width: focusWidth,
      height: focusHeight,
      pointerCenterX: slotWidth * step.navSlot + slotWidth / 2,
      cardOnTop: false,
      cardTop: 0,
      cardBottom: 98 + bottomInset,
    );
  }
}

class _WalkthroughCard extends StatelessWidget {
  const _WalkthroughCard({
    required this.step,
    required this.stepNumber,
    required this.totalSteps,
    required this.isFirst,
    required this.isLast,
    required this.pointerLeft,
    required this.pointerOnTop,
    required this.onBack,
    required this.onNext,
    required this.onSkip,
  });

  final AppWalkthroughStep step;
  final int stepNumber;
  final int totalSteps;
  final bool isFirst;
  final bool isLast;
  final double pointerLeft;
  final bool pointerOnTop;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  static const Color _accent = Color(0xFF12BFF3);
  static const Color _surface = Color(0xF2181B20);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _accent.withOpacity(0.65)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.38),
                blurRadius: 32,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF101317),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: _WalkthroughVisual(step: step),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            height: 1.1,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          step.description,
                          style: const TextStyle(
                            color: Color(0xFFE2F3FA),
                            fontSize: 13,
                            height: 1.35,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Text(
                    '$stepNumber/$totalSteps',
                    style: const TextStyle(
                      color: Color(0xFF95DFF6),
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  if (isFirst)
                    _WalkthroughButton(label: 'Bỏ qua', onTap: onSkip)
                  else
                    _WalkthroughButton(label: 'Quay lại', onTap: onBack),
                  const SizedBox(width: 10),
                  _WalkthroughButton(
                    label: isLast ? 'Xong' : 'Tiếp',
                    isPrimary: true,
                    onTap: onNext,
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          left: pointerLeft,
          top: pointerOnTop ? -11 : null,
          bottom: pointerOnTop ? null : -11,
          child: Transform.rotate(
            angle: 0.785398,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: _surface,
                border: Border(
                  right: BorderSide(color: _accent.withOpacity(0.65)),
                  bottom: BorderSide(color: _accent.withOpacity(0.65)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _WalkthroughVisual extends StatelessWidget {
  const _WalkthroughVisual({required this.step});

  final AppWalkthroughStep step;

  @override
  Widget build(BuildContext context) {
    final assetPath = step.assetPath;
    if (assetPath != null) {
      return SvgPicture.asset(assetPath);
    }

    return Icon(
      step.icon ?? Icons.info_rounded,
      color: const Color(0xFF12BFF3),
      size: 42,
    );
  }
}

class _WalkthroughButton extends StatelessWidget {
  const _WalkthroughButton({
    required this.label,
    required this.onTap,
    this.isPrimary = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: isPrimary ? const Color(0xFF071317) : Colors.white,
          backgroundColor: isPrimary
              ? const Color(0xFF12BFF3)
              : const Color(0xFF303741),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
        ),
        child: Text(label),
      ),
    );
  }
}
