import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/language_controller.dart';
import '../../core/utils/url_launcher_utils.dart';
import '../../data/portfolio_data.dart';
import '../common/brand_logo.dart';
import '../common/max_width_container.dart';

class FooterNavBar extends StatelessWidget {
  final ValueChanged<String> onNavigate;

  const FooterNavBar({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LanguageController.instance,
      builder: (context, _) {
        final isAr = LanguageController.instance.isArabic;

        return MaxWidthContainer(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 20, 28, 28),
            child: Column(
              children: [
                const Divider(color: Colors.white12),
                const SizedBox(height: 16),
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  runSpacing: 20,
                  spacing: 30,
                  children: [
                    const BrandLogo(),
                    Wrap(
                      spacing: 18,
                      runSpacing: 10,
                      children: [
                        _FooterLink(
                          isAr ? 'البريد الإلكتروني' : 'Email',
                          () => UrlLauncherUtils.openEmail(PortfolioData.email),
                        ),
                        _FooterLink(
                          'WhatsApp',
                          () => UrlLauncherUtils.openWhatsApp(PortfolioData.phone),
                        ),
                        _FooterLink(
                          'GitHub',
                          () => UrlLauncherUtils.launchURL(PortfolioData.githubUrl),
                        ),
                        _FooterLink(
                          'LinkedIn',
                          () => UrlLauncherUtils.launchURL(PortfolioData.linkedinUrl),
                        ),
                        _FooterLink(
                          isAr ? 'تحميل السيرة الذاتية' : 'Download CV',
                          () => UrlLauncherUtils.downloadCV(),
                        ),
                      ],
                    ),
                    Text(
                      isAr
                          ? '© 2026 · محمد نصر الدين — مطور فلاتر'
                          : '© 2026 · Mohamed Nasr Eldeen — Flutter Developer',
                      style: const TextStyle(color: AppColors.muted, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _FooterLink(this.label, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Text(
        label,
        style: const TextStyle(color: AppColors.muted, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}
