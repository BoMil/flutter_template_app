import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_template_app/core/shared/widgets/progress_bar.dart';
import 'package:flutter_template_app/theme/theme_color.dart';

class LandingCarouselItem {
  final String slidePath;
  final String slideTitle;

  LandingCarouselItem({
    required this.slidePath,
    required this.slideTitle,
  });
}

// ignore: must_be_immutable
class LandingCarousel extends StatefulWidget {
  final List<LandingCarouselItem> slides;
  final int animationDuration;
  int activePage;
  double sidePadding;
  final Function(int) slideChanged;

  LandingCarousel({
    super.key,
    required this.slides,
    required this.slideChanged,
    this.animationDuration = 5,
    this.activePage = 0,
    this.sidePadding = 20,
  });

  @override
  State<LandingCarousel> createState() => _LandingCarouselState();
}

class _LandingCarouselState extends State<LandingCarousel> with TickerProviderStateMixin {
  final double _start = 0;
  final double _end = 100;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: widget.animationDuration))
      ..repeat()
      ..addStatusListener(_animationStatusListener);
    _animation = Tween<double>(begin: _start, end: _end).animate(_animationController);
    _onAnimate();
  }

  @override
  void dispose() {
    _animationController.removeStatusListener(_animationStatusListener);
    _animationController.dispose();
    super.dispose();
  }

  _animationStatusListener(AnimationStatus status) async {
    // print('ANIMATION STATUS $status');

    if (status == AnimationStatus.completed) {
      // If it is the last slide
      if (widget.activePage == widget.slides.length - 1) {
        widget.activePage = 0;
      } else {
        widget.activePage++;
      }
      // print('activePage ${widget.activePage}');
      widget.slideChanged(widget.activePage);

      _animationController.reset();
      // _pageController.animateToPage(
      //   widget.activePage,
      //   duration: const Duration(milliseconds: 300),
      //   curve: Curves.easeIn,
      // );
      await _animationController.forward();
    }
  }

  void _onAnimate() async {
    // print('_onAnimate CALLED');
    if (_animationController.isDismissed) {
      await _animationController.forward();
    } else {
      _animationController.reset();
      await _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    double heightFactor = Platform.isIOS ? 1.5 : 1.4;
    double topPosition =
        widget.activePage > 0 ? MediaQuery.of(context).size.height / 3 : MediaQuery.of(context).size.height / 3.5;
    return Stack(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / heightFactor,
          child: Column(
            children: [
              const SizedBox(height: 50),
              const Align(alignment: Alignment.topLeft, child: Icon(Icons.ac_unit)),
              const SizedBox(height: 50),
              // if (widget.slides[widget.activePage].slideTitle == AppLocalizations.of(context).harnessingNature) ...[
              Text(
                widget.slides[widget.activePage].slideTitle,
                style: const TextStyle(
                  color: AppColors.baseWhite,
                  fontSize: 36,
                  fontWeight: FontWeight.w600,
                  height: 1.1,
                ),
              ),
              // ],
              // if (widget.slides[widget.activePage].slideTitle == AppLocalizations.of(context).optimizingEnergy) ...[
              Text(
                widget.slides[widget.activePage].slideTitle,
                style: const TextStyle(
                  color: AppColors.baseWhite,
                  fontSize: 36,
                  fontWeight: FontWeight.w600,
                  height: 1.1,
                ),
              ),
              // ],
              // if (widget.slides[widget.activePage].slideTitle == AppLocalizations.of(context).seamlessUtility) ...[
              Text(
                widget.slides[widget.activePage].slideTitle,
                style: const TextStyle(
                  color: AppColors.baseWhite,
                  fontSize: 36,
                  fontWeight: FontWeight.w600,
                  height: 1.1,
                ),
              ),
              // ],
            ],
          ),
        ),
        Positioned(
          top: topPosition,
          left: 0,
          right: 0,
          child: Image.asset(widget.slides[widget.activePage].slidePath),
        ),
        if (widget.slides.length > 1) ...[
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.transparent,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (_, __) {
                  // print('ANIMAATION WORKING ${_animation.value}');
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List<Widget>.generate(
                      widget.slides.length,
                      (index) {
                        // Progress bar is empty
                        double progressValue = 0;

                        if (index == widget.activePage) {
                          progressValue = _animation.value / 100;
                        } else if (index < widget.activePage) {
                          progressValue = 1;
                        }
                        return ProgressBar(
                          height: 2,
                          barColor: AppColors.baseWhite,
                          width: MediaQuery.of(context).size.width / widget.slides.length - widget.sidePadding * 1.3,
                          progressValue: progressValue,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ],
    );
  }
}
