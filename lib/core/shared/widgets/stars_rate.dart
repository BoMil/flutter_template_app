import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_template_app/theme/theme_color.dart';

class StarsRate extends StatefulWidget {
  final Function(int starIndex) starSelected;
  const StarsRate({super.key, required this.starSelected});

  @override
  State<StarsRate> createState() => _StarsRateState();
}

class _StarsRateState extends State<StarsRate> {
  final stars = List.generate(5, (index) => index);
  int? selectedStar;
  final double borderRadius = 100;

  _isStarColored(int index) {
    if (selectedStar == null) {
      return false;
    }
    if (index <= selectedStar!) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint(' ----- StarsRate build called ---');
    return Row(
      children: stars
          .map(
            (index) => Expanded(
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(borderRadius),
                child: InkWell(
                  borderRadius: BorderRadius.circular(borderRadius),
                  onTap: () {
                    setState(() {
                      selectedStar = index;
                      widget.starSelected(index);
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    child: SvgPicture.asset(
                      'assets/svg/star.svg',
                      colorFilter: ColorFilter.mode(
                        _isStarColored(index) ? AppColors.baseYellow : Colors.white60,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
