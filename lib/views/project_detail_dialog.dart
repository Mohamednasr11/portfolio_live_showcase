import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/localization/language_controller.dart';
import '../core/utils/url_launcher_utils.dart';
import '../models/project.dart';
import '../widgets/common/buttons.dart';
import '../widgets/common/tag_chip.dart';
import '../widgets/mockup/goldie_device_mockup.dart';

class ProjectDetailDialog extends StatefulWidget {
  final Project project;

  const ProjectDetailDialog({super.key, required this.project});

  @override
  State<ProjectDetailDialog> createState() => _ProjectDetailDialogState();
}

class _ProjectDetailDialogState extends State<ProjectDetailDialog> {
  late final PageController _pageController = PageController();
  int _page = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAr = LanguageController.instance.isArabic;
    final project = widget.project;
    final allImages = [project.image, ...project.gallery];

    return Dialog(
      backgroundColor: AppColors.panel,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.border),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1060, maxHeight: 860),
        child: LayoutBuilder(
          builder: (context, box) {
            final compact = box.maxWidth < 780;

            final galleryWidget = Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF07141E),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: allImages.length,
                          onPageChanged: (index) => setState(() => _page = index),
                          itemBuilder: (context, index) {
                            return Center(
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: GoldieDeviceMockup(
                                    imagePath: allImages[index],
                                    width: compact ? 200 : 230,
                                    height: compact ? 390 : 450,
                                    enableHoverEffect: false,
                                    badgeText: index == 0
                                        ? (isAr ? 'الشاشة الرئيسية' : 'Main Screen')
                                        : (isAr
                                            ? 'شاشة ${index + 1} من ${allImages.length}'
                                            : 'Screen ${index + 1} of ${allImages.length}'),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      if (_page > 0)
                        Positioned(
                          left: 10,
                          child: Material(
                            color: const Color(0xB3000000),
                            shape: const CircleBorder(),
                            clipBehavior: Clip.antiAlias,
                            child: IconButton(
                              icon: const Icon(
                                Icons.chevron_left_rounded,
                                color: AppColors.lime,
                                size: 28,
                              ),
                              tooltip: isAr ? 'الشاشة السابقة' : 'Previous Screen',
                              onPressed: _previousPage,
                            ),
                          ),
                        ),

                      if (_page < allImages.length - 1)
                        Positioned(
                          right: 10,
                          child: Material(
                            color: const Color(0xB3000000),
                            shape: const CircleBorder(),
                            clipBehavior: Clip.antiAlias,
                            child: IconButton(
                              icon: const Icon(
                                Icons.chevron_right_rounded,
                                color: AppColors.lime,
                                size: 28,
                              ),
                              tooltip: isAr ? 'الشاشة التالية' : 'Next Screen',
                              onPressed: _nextPage,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${_page + 1} / ${allImages.length}',
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        allImages.length,
                        (index) => GestureDetector(
                          onTap: () => _pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeOutCubic,
                          ),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: _page == index ? 20 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: _page == index
                                  ? AppColors.lime
                                  : Colors.white24,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );

            final infoWidget = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TagChip(project.category(isAr)),
                const SizedBox(height: 12),
                Text(
                  project.name(isAr),
                  style: const TextStyle(
                    color: AppColors.paper,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.7,
                  ),
                ),
                if (project.headline(isAr) != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    project.headline(isAr)!,
                    style: const TextStyle(
                      color: AppColors.lime,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Text(
                  project.description(isAr),
                  style: const TextStyle(
                    color: AppColors.muted,
                    height: 1.75,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 20),

                // Problem Statement Section
                _SectionTitle(isAr ? 'المشكلة والدافع' : 'PROBLEM STATEMENT'),
                const SizedBox(height: 6),
                Text(
                  project.problem(isAr),
                  style: const TextStyle(color: AppColors.paper, fontSize: 12, height: 1.7),
                ),
                const SizedBox(height: 18),

                // Solution Section
                _SectionTitle(isAr ? 'الحل الهندسي' : 'ENGINEERING SOLUTION'),
                const SizedBox(height: 6),
                Text(
                  project.solution(isAr),
                  style: const TextStyle(color: AppColors.paper, fontSize: 12, height: 1.7),
                ),
                const SizedBox(height: 18),

                // Architecture Section
                _SectionTitle(isAr ? 'المعمارية وهيكلة الكود' : 'ARCHITECTURE & PATTERNS'),
                const SizedBox(height: 6),
                Text(
                  project.architecture(isAr),
                  style: const TextStyle(color: AppColors.cyan, fontSize: 12, height: 1.6),
                ),
                const SizedBox(height: 18),

                // State Management & Backend Section
                _SectionTitle(isAr ? 'إدارة الحالة والربط البرمجي' : 'STATE & BACKEND INTEGRATION'),
                const SizedBox(height: 6),
                Text(
                  '${project.stateManagement(isAr)}\n${project.apiBackend(isAr)}',
                  style: const TextStyle(color: AppColors.paper, fontSize: 12, height: 1.7),
                ),
                const SizedBox(height: 18),

                // Key Features Section
                _SectionTitle(isAr ? 'أبرز الميزات البرمجية' : 'KEY TECHNICAL FEATURES'),
                const SizedBox(height: 6),
                Text(
                  project.keyFeatures(isAr),
                  style: const TextStyle(color: AppColors.muted, fontSize: 12, height: 1.7),
                ),
                const SizedBox(height: 20),

                // Tech Stack Tags
                _SectionTitle(isAr ? 'التقنيات المستخدمة' : 'TECHNOLOGY STACK'),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: project.tags.map((tag) => TagChip(tag)).toList(),
                ),
                const SizedBox(height: 26),

                // External Links Buttons
                Wrap(
                  spacing: 12,
                  runSpacing: 10,
                  children: [
                    if (project.githubUrl != null)
                      PrimaryButton(
                        label: 'GitHub Repository',
                        icon: Icons.code_rounded,
                        onPressed: () => UrlLauncherUtils.launchURL(project.githubUrl!),
                      ),
                    if (project.liveUrl != null)
                      QuietButton(
                        label: isAr ? 'معاينة حية' : 'Live Demo',
                        icon: Icons.open_in_new_rounded,
                        onPressed: () => UrlLauncherUtils.launchURL(project.liveUrl!),
                      ),
                  ],
                ),
              ],
            );

            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        isAr ? 'دراسة حالة تقنية مفصلة' : 'ENGINEERING CASE STUDY & DEEP DIVE',
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 10,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.close_rounded,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: compact
                        ? SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(height: 420, child: galleryWidget),
                                const SizedBox(height: 20),
                                infoWidget,
                              ],
                            ),
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 5, child: galleryWidget),
                              const SizedBox(width: 24),
                              Expanded(
                                flex: 6,
                                child: SingleChildScrollView(child: infoWidget),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.lime,
        fontSize: 11,
        letterSpacing: 1.2,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
