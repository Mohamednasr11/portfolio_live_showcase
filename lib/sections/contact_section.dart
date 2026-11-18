import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/localization/language_controller.dart';
import '../core/utils/url_launcher_utils.dart';
import '../data/portfolio_data.dart';
import '../widgets/common/buttons.dart';
import '../widgets/common/max_width_container.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LanguageController.instance,
      builder: (context, _) {
        final isAr = LanguageController.instance.isArabic;

        return MaxWidthContainer(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 70, 28, 70),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 54),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1C4548), Color(0xFF153442)],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.withAlphaOpacity(AppColors.lime, 0.35),
                  width: 1.5,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 30,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    isAr
                        ? 'هل لديك فكرة أو فرصة عمل؟'
                        : 'LOOKING FOR A FLUTTER DEVELOPER?',
                    style: const TextStyle(
                      color: AppColors.lime,
                      fontSize: 11,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: isAr
                              ? 'لنقم ببناء تطبيق جوال\n'
                              : "Let's build scalable mobile apps\n",
                        ),
                        TextSpan(
                          text: isAr ? 'متميز واحترافي.' : 'together.',
                          style: const TextStyle(color: AppColors.lime),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.paper,
                      fontSize: 42,
                      height: 1.1,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1.5,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    isAr
                        ? 'متاح للفرص الوظيفية كـ Junior Flutter Developer، ومشاريع الجوال الحرة والتعاقدية.'
                        : 'Available for Junior Flutter Developer roles, internships, and high-impact remote mobile projects.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFFB4C9BC),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      PrimaryButton(
                        label: PortfolioData.email,
                        icon: Icons.mail_outline_rounded,
                        onPressed: () =>
                            UrlLauncherUtils.openEmail(PortfolioData.email),
                      ),
                      QuietButton(
                        label: 'WhatsApp Chat',
                        icon: Icons.chat_bubble_outline_rounded,
                        onPressed: () =>
                            UrlLauncherUtils.openWhatsApp(PortfolioData.phone),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
