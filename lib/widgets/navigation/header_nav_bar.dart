import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/language_controller.dart';
import '../../core/utils/url_launcher_utils.dart';
import '../common/brand_logo.dart';
import 'nav_item.dart';

class HeaderNavBar extends StatelessWidget {
  final ValueChanged<String> onNavigate;

  const HeaderNavBar({super.key, required this.onNavigate});

  static const _navKeys = [
    'About',
    'Projects',
    'Web',
    'Skills',
    'Experience',
    'Contact',
  ];

  static final Map<String, String> _navLabelsAr = {
    'About': 'نبذة عني',
    'Projects': 'مشاريع فلاتر',
    'Web': 'مشاريع الويب',
    'Skills': 'المهارات',
    'Experience': 'التعليم والتدريب',
    'Contact': 'تواصل معي',
  };

  static final Map<String, String> _navLabelsEn = {
    'About': 'About',
    'Projects': 'Flutter Projects',
    'Web': 'Web Projects',
    'Skills': 'Skills',
    'Experience': 'Experience & Education',
    'Contact': 'Contact',
  };

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LanguageController.instance,
      builder: (context, _) {
        final isAr = LanguageController.instance.isArabic;
        final labels = isAr ? _navLabelsAr : _navLabelsEn;

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1180),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final compact = constraints.maxWidth < 960;
                  return Row(
                    children: [
                      const BrandLogo(),
                      const Spacer(),
                      if (!compact) ...[
                        ..._navKeys.map(
                          (key) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: NavItem(
                              name: labels[key] ?? key,
                              onTap: () => onNavigate(key),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                      ],

                      // Language Toggle Button
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          side: const BorderSide(color: AppColors.lime, width: 1.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: AppColors.panel,
                        ),
                        onPressed: () => LanguageController.instance.toggleLanguage(),
                        icon: const Icon(
                          Icons.language_rounded,
                          color: AppColors.lime,
                          size: 16,
                        ),
                        label: Text(
                          isAr ? 'English' : 'العربية',
                          style: const TextStyle(
                            color: AppColors.lime,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // CV Download Button
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          backgroundColor: AppColors.lime,
                          foregroundColor: AppColors.ink,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () => UrlLauncherUtils.downloadCV(),
                        icon: const Icon(Icons.download_rounded, size: 16),
                        label: Text(
                          isAr ? 'تحميل CV' : 'Download CV',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),

                      if (compact) ...[
                        const SizedBox(width: 8),
                        PopupMenuButton<String>(
                          tooltip: isAr ? 'القائمة' : 'Menu',
                          icon: const Icon(Icons.menu_rounded, color: AppColors.lime),
                          color: AppColors.panelLight,
                          onSelected: onNavigate,
                          itemBuilder: (context) => _navKeys
                              .map(
                                (key) => PopupMenuItem(
                                  value: key,
                                  child: Text(
                                    labels[key] ?? key,
                                    style: const TextStyle(color: AppColors.paper),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
