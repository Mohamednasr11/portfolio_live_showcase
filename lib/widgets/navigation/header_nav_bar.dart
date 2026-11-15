import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/localization/language_controller.dart';
import '../../core/utils/url_launcher_utils.dart';
import '../common/app_button.dart';
import '../common/brand_logo.dart';
import 'nav_item.dart';

class HeaderNavBar extends StatelessWidget {
  final ValueChanged<String> onNavigate;
  final String activeSection;
  final bool isScrolled;

  const HeaderNavBar({
    super.key,
    required this.onNavigate,
    this.activeSection = 'Hero',
    this.isScrolled = false,
  });

  static const _navKeys = [
    'Projects',
    'Skills',
    'Contact',
  ];

  static final Map<String, String> _navLabelsAr = {
    'Projects': 'مشاريع فلاتر',
    'Skills': 'المهارات',
    'Contact': 'تواصل معي',
  };

  static final Map<String, String> _navLabelsEn = {
    'Projects': 'Case studies',
    'Skills': 'Skills',
    'Contact': 'Contact',
  };

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LanguageController.instance,
      builder: (context, _) {
        final isAr = LanguageController.instance.isArabic;
        final labels = isAr ? _navLabelsAr : _navLabelsEn;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: isScrolled
                ? AppColors.withAlphaOpacity(AppColors.background, 0.92)
                : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: isScrolled
                    ? AppColors.withAlphaOpacity(AppColors.border, 0.8)
                    : Colors.transparent,
                width: 1.0,
              ),
            ),
            boxShadow: isScrolled
                ? const [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 16,
                      offset: Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isCompact = constraints.maxWidth < 820;
                    final isVeryCompact = constraints.maxWidth < 480;

                    return Row(
                      children: [
                        Semantics(
                          label: 'Home logo button',
                          button: true,
                          child: InkWell(
                            onTap: () => onNavigate('Hero'),
                            borderRadius: BorderRadius.circular(8),
                            child: const BrandLogo(),
                          ),
                        ),
                        const Spacer(),
                        if (!isCompact) ...[
                          ..._navKeys.map((key) {
                            final isActive = activeSection == key;
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: NavItem(
                                name: labels[key] ?? key,
                                isActive: isActive,
                                onTap: () => onNavigate(key),
                              ),
                            );
                          }),
                          const SizedBox(width: 12),
                        ],

                        // Live Showcase / Download CV Button
                        if (!isVeryCompact)
                          AppButton(
                            label: isAr ? 'تحميل CV' : 'Live showcase',
                            icon: Icons.play_circle_outline_rounded,
                            style: AppButtonStyle.primary,
                            onPressed: () => UrlLauncherUtils.downloadCV(),
                            tooltip: 'Download PDF CV / Live Showcase',
                          ),
                        if (!isVeryCompact) const SizedBox(width: 8),

                        // Language Toggle Button
                        Semantics(
                          label: isAr
                              ? 'تغيير اللغة إلى الإنجليزية'
                              : 'Switch language to Arabic',
                          button: true,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                              side: const BorderSide(
                                color: AppColors.accent,
                                width: 1.0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              backgroundColor: AppColors.panel,
                            ),
                            onPressed: () =>
                                LanguageController.instance.toggleLanguage(),
                            icon: const Icon(
                              Icons.language_rounded,
                              color: AppColors.accent,
                              size: 14,
                            ),
                            label: Text(
                              isAr ? 'EN' : 'العربية',
                              style: const TextStyle(
                                color: AppColors.accent,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),

                        if (isCompact) ...[
                          const SizedBox(width: 6),
                          Semantics(
                            label: isAr
                                ? 'فتح القائمة الرئيسية'
                                : 'Open navigation drawer menu',
                            button: true,
                            child: PopupMenuButton<String>(
                              tooltip: isAr ? 'القائمة' : 'Menu',
                              icon: const Icon(
                                Icons.menu_rounded,
                                color: AppColors.accent,
                              ),
                              color: AppColors.panelLight,
                              onSelected: onNavigate,
                              itemBuilder: (context) => _navKeys
                                  .map(
                                    (key) => PopupMenuItem(
                                      value: key,
                                      child: Text(
                                        labels[key] ?? key,
                                        style: TextStyle(
                                          color: activeSection == key
                                              ? AppColors.accent
                                              : AppColors.textPrimary,
                                          fontWeight: activeSection == key
                                              ? FontWeight.w700
                                              : FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
