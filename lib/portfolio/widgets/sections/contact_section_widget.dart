import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../showcase/theme.dart';
import '../../profile_data.dart';
import '../common/link_button_widget.dart';
import '../common/section_frame_widget.dart';

class ContactSectionWidget extends StatelessWidget {
  const ContactSectionWidget({
    super.key,
    required this.narrow,
    required this.isArabic,
    required this.isDark,
  });

  final bool narrow;
  final bool isArabic;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return SectionFrameWidget(
      label: isArabic ? 'تواصل معي' : 'Contact',
      title: isArabic ? 'لنبدأ العمل معاً' : 'Get in touch',
      intro: isArabic
          ? 'البريد الإلكتروني هو أسرع طريقة للتواصل معي. يمكنك أيضاً زيارة حساباتي على لينكد إن و جيت هب.'
          : 'Email is the fastest way to reach me. You can also connect via LinkedIn or GitHub.',
      isDark: isDark,
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          LinkButton(
            label: Profile.email,
            url: 'mailto:${Profile.email}',
            icon: Icons.mail_outline_rounded,
            primary: true,
          ),
          IconButton(
            tooltip: isArabic ? 'نسخ البريد الإلكتروني' : 'Copy email address',
            onPressed: () async {
              await Clipboard.setData(const ClipboardData(text: Profile.email));

              if (!context.mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isArabic
                        ? 'تم نسخ البريد الإلكتروني'
                        : 'Email address copied',
                  ),
                ),
              );
            },
            icon: const Icon(Icons.copy_rounded, color: Show.accent),
          ),
          LinkButton(
            label: 'GitHub',
            url: Profile.githubUrl,
            icon: Icons.code_rounded,
          ),
          LinkButton(
            label: 'LinkedIn',
            url: Profile.linkedinUrl,
            icon: Icons.person_outline_rounded,
          ),
        ],
      ),
    );
  }
}
