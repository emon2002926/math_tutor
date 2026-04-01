import 'package:flutter/material.dart';
import '../../constants/app_assert_image.dart';
import '../../util/screen_size.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;
  final assets = AppAssertImage.instance;

  CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'selectedIcon': assets.homeSelected,
        'unselectedIcon': assets.home,
        'label': 'Home',
      },
      {
        'selectedIcon': assets.unitsSelected,
        'unselectedIcon': assets.units,
        'label': 'Units',
      },
      {
        'selectedIcon': assets.trophySelected,
        'unselectedIcon': assets.trophy,
        'label': 'Badges',
      },
    ];

    return Material(
      color: Colors.transparent, // ← this is the key fix
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            left: context.responsiveSize(16),
            right: context.responsiveSize(16),
            bottom: context.responsiveSize(16),
            top: context.responsiveSize(8),
          ),
          child: Container(
            height: context.responsiveSize(72),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF7CDB4A), Color(0xFF4CB825)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(context.responsiveSize(50)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4CB825).withOpacity(0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: List.generate(items.length, (index) {
                final item = items[index];
                final isSelected = currentIndex == index;
                final label = item['label'] as String;

                return Expanded(
                  child: GestureDetector(
                    onTap: () => onTabSelected(index),
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: EdgeInsets.all(context.responsiveSize(6)),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white.withOpacity(0.25)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(
                          context.responsiveSize(40),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            isSelected
                                ? item['selectedIcon'] as String
                                : item['unselectedIcon'] as String,
                            width: context.responsiveSize(26),
                            height: context.responsiveSize(26),
                            color: Colors.white,
                          ),
                          SizedBox(height: context.responsiveSize(4)),
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: context.responsiveSize(12),
                              fontWeight: isSelected
                                  ? FontWeight.w800
                                  : FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}