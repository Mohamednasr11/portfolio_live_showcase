import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/localization/language_controller.dart';
import '../widgets/common/section_header.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LanguageController.instance,
      builder: (context, _) {
        final isAr = LanguageController.instance.isArabic;

        final services = [
          (
            Icons.phone_android_rounded,
            isAr ? 'تطوير تطبيقات الجوال' : 'Flutter Mobile Development',
            isAr
                ? 'تطوير تطبيقات جوال جاهزة للإنتاج لـ iOS وAndroid بكود نظيف وقابل للصيانة.'
                : 'Production-ready iOS & Android mobile apps engineered with Flutter and Dart.'
          ),
          (
            Icons.layers_outlined,
            isAr ? 'تطبيق المعمارية النظيفة' : 'Clean Architecture Implementation',
            isAr
                ? 'فصل طبقات الكود (Domain/Data/Presentation) لإدارة المستندات والبيانات بسهولة.'
                : 'Separating Domain, Data, and Presentation layers for highly testable code bases.'
          ),
          (
            Icons.cloud_outlined,
            isAr ? 'ربط Firebase وواجهات REST' : 'Firebase & API Integrations',
            isAr
                ? 'مصادقة المستخدمين، مزامنة البيانات السحابية، تنبيهات FCM، والاتصال بـ Dio REST APIs.'
                : 'Authentication, Firestore database, FCM push notifications, and Dio REST API clients.'
          ),
          (
            Icons.auto_awesome_rounded,
            isAr ? 'تجهيز وإشراف النشر' : 'App Store Release & Testing',
            isAr
                ? 'اختبار واجهات المستخدم، معالجة الأخطاء، وإعداد التطبيقات للنشر على App Store وPlay Store.'
                : 'UI testing, performance optimization, and store submission readiness.'
          ),
        ];

        return Container(
          color: const Color(0xFF0A1B26),
          child: SectionWrapper(
            number: '06',
            eyebrow: isAr ? 'مجالات العمل والمساهمة' : 'HOW I CAN CONTRIBUTE',
            title: isAr ? 'من الفكرة' : 'From Concept',
            accent: isAr ? 'إلى المتاجر.' : 'To Store Release.',
            description: isAr
                ? 'نهج مهني منظم لبناء وتطوير تطبيقات الجوال يركز على جودة الكود واستقرار الأداء.'
                : 'A structured, engineering-focused process that produces maintainable mobile applications.',
            child: LayoutBuilder(
              builder: (context, constraints) {
                final cols = constraints.maxWidth > 900
                    ? 4
                    : (constraints.maxWidth > 560 ? 2 : 1);
                final width = (constraints.maxWidth - 18 * (cols - 1)) / cols;

                return Wrap(
                  spacing: 18,
                  runSpacing: 18,
                  children: services
                      .map(
                        (item) => SizedBox(
                          width: width,
                          child: Container(
                            padding: const EdgeInsets.all(21),
                            constraints: const BoxConstraints(minHeight: 200),
                            decoration: BoxDecoration(
                              color: AppColors.panel,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(item.$1, size: 24, color: AppColors.lime),
                                const SizedBox(height: 22),
                                Text(
                                  item.$2,
                                  style: const TextStyle(
                                    color: AppColors.paper,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  item.$3,
                                  style: const TextStyle(
                                    color: AppColors.muted,
                                    fontSize: 12,
                                    height: 1.7,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
