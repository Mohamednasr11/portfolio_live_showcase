import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/localization/language_controller.dart';
import '../core/utils/url_launcher_utils.dart';
import '../data/portfolio_data.dart';
import '../widgets/common/buttons.dart';
import '../widgets/common/section_header.dart';
import '../widgets/common/tag_chip.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LanguageController.instance,
      builder: (context, _) {
        final isAr = LanguageController.instance.isArabic;

        return Container(
          color: AppColors.panelLight,
          child: SectionWrapper(
            number: '01',
            eyebrow: isAr ? 'نبذة عني والمسار البرمجي' : 'A LITTLE ABOUT ME',
            title: isAr ? 'تطبيقات جوال' : 'Building Mobile Apps',
            accent: isAr ? 'بمعمارية نظيفة وجذابة.' : 'That Scale Elegantly.',
            description: isAr
                ? 'الجمع بين الهندسة النظيفة (Clean Architecture) والواجهات التفاعلية لتقديم منتجات جوال سلسة وعالية الكفاءة.'
                : 'Combining clean architectural patterns with intuitive mobile user interfaces for high-performance iOS & Android products.',
            child: LayoutBuilder(
              builder: (context, constraints) {
                final narrow = constraints.maxWidth < 820;

                final bioWidget = SizedBox(
                  width: narrow
                      ? constraints.maxWidth
                      : constraints.maxWidth * 0.48,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isAr
                            ? "أنا محمد نصر الدين، طالب بحاسبات ومعلومات جامعة المنصورة ومطور تطبيقات فلاتر متخصص في بناء تطبيقات الجوال باستخدام فلاتر ودارت. أركز على كتابة كود برمجي منظم، قراءة سهلة، وتجربة مستخدم متميزة مع تطبيق صارم لمعمارية Clean Architecture وإدارة الحالة بـ BLoC/Cubit."
                            : "I'm Mohamed Nasr Eldeen, a Computer Science undergraduate at Mansoura University and dedicated Flutter Developer. I focus on building scalable, cross-platform mobile apps for iOS and Android with strict Clean Architecture, modular codebases, BLoC/Cubit state management, and seamless backend integration.",
                        style: const TextStyle(
                          color: AppColors.paper,
                          fontSize: 14,
                          height: 1.9,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        isAr
                            ? "أتطلع للانضمام لفرق عمل متميزة كـ Junior Flutter Developer ومواجهة تحديات برمجية تساهم في تقديم منتجات حقيقية للمستخدمين."
                            : "I am actively seeking Junior Flutter Developer opportunities, engineering internships, and high-impact remote mobile projects where I can contribute maintainable code and continuous innovation.",
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 13,
                          height: 1.8,
                        ),
                      ),
                      const SizedBox(height: 26),
                      Wrap(
                        spacing: 12,
                        runSpacing: 10,
                        children: [
                          PrimaryButton(
                            label: isAr ? 'تواصل معي مباشرة' : 'Get in Touch',
                            icon: Icons.mail_outline_rounded,
                            onPressed: () =>
                                UrlLauncherUtils.openEmail(PortfolioData.email),
                          ),
                          QuietButton(
                            label: isAr
                                ? 'تحميل السيرة الذاتية'
                                : 'Download CV',
                            onPressed: () => UrlLauncherUtils.downloadCV(),
                          ),
                        ],
                      ),
                    ],
                  ),
                );

                final highlightsWidget = SizedBox(
                  width: narrow
                      ? constraints.maxWidth
                      : constraints.maxWidth * 0.46,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isAr
                            ? 'أبرز ركائز التطوير'
                            : 'CORE ENGINEERING PILLARS',
                        style: const TextStyle(
                          color: AppColors.lime,
                          fontSize: 11,
                          letterSpacing: 1.6,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 18),
                      _PillarItem(
                        icon: Icons.layers_outlined,
                        title: isAr
                            ? 'معمارية Clean Architecture'
                            : 'Clean Architecture & Separation',
                        desc: isAr
                            ? 'تقسيم المشروع إلى ثلاث طبقات (Domain / Data / Presentation) لضمان استقلالية الكود وسهولة الاختبار.'
                            : 'Layered architecture (Data, Domain, Presentation) isolating core business logic from UI frameworks.',
                      ),
                      _PillarItem(
                        icon: Icons.autorenew_rounded,
                        title: isAr
                            ? 'إدارة حالة متوقعة بـ BLoC/Cubit'
                            : 'Predictable BLoC/Cubit State',
                        desc: isAr
                            ? 'إدارة التدفقات التفاعلية وتحديثات الشاشات بدون تعقيد وبكفاءة عالية في استخدام الموارد.'
                            : 'Unidirectional data flow, reactive state handling, and efficient UI re-renders using BLoC and Cubit.',
                      ),
                      _PillarItem(
                        icon: Icons.api_rounded,
                        title: isAr
                            ? 'ربط الواجهات والمزامنة'
                            : 'APIs & Backend Synchronization',
                        desc: isAr
                            ? 'معالجة الاتصال بالشبكات عبر Dio REST APIs وGraphQL وخدمات Firebase الآمنة.'
                            : 'Robust API integration using Dio HTTP client, GraphQL queries, Firebase Auth, Firestore, and FCM.',
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 7,
                        runSpacing: 7,
                        children: const [
                          TagChip('Clean Architecture'),
                          TagChip('BLoC'),
                          TagChip('Cubit'),
                          TagChip('Provider'),
                          TagChip('Dio'),
                          TagChip('GraphQL'),
                          TagChip('Firebase'),
                          TagChip('Drift / SQLite'),
                          TagChip('Git & GitHub'),
                        ],
                      ),
                    ],
                  ),
                );

                return Wrap(
                  spacing: 40,
                  runSpacing: 36,
                  children: [bioWidget, highlightsWidget],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _PillarItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;

  const _PillarItem({
    required this.icon,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF14303F),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.lime, width: 0.8),
            ),
            child: Icon(icon, color: AppColors.lime, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.paper,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 12,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
