class Project {
  final String id;
  final String nameEn;
  final String nameAr;
  final String categoryEn;
  final String categoryAr;
  final String image;
  final String descriptionEn;
  final String descriptionAr;
  final String? headlineEn;
  final String? headlineAr;
  final String? subtitleEn;
  final String? subtitleAr;
  final List<String> tags;
  final List<String> gallery;
  final String? githubUrl;
  final String? liveUrl;

  // Case Study Details
  final String problemEn;
  final String problemAr;
  final String solutionEn;
  final String solutionAr;
  final String architectureEn;
  final String architectureAr;
  final String stateManagementEn;
  final String stateManagementAr;
  final String apiBackendEn;
  final String apiBackendAr;
  final String keyFeaturesEn;
  final String keyFeaturesAr;

  final bool isFeatured;
  final bool isWebProject;

  const Project({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.categoryEn,
    required this.categoryAr,
    required this.image,
    required this.descriptionEn,
    required this.descriptionAr,
    this.headlineEn,
    this.headlineAr,
    this.subtitleEn,
    this.subtitleAr,
    required this.tags,
    required this.gallery,
    this.githubUrl,
    this.liveUrl,
    required this.problemEn,
    required this.problemAr,
    required this.solutionEn,
    required this.solutionAr,
    required this.architectureEn,
    required this.architectureAr,
    required this.stateManagementEn,
    required this.stateManagementAr,
    required this.apiBackendEn,
    required this.apiBackendAr,
    required this.keyFeaturesEn,
    required this.keyFeaturesAr,
    this.isFeatured = false,
    this.isWebProject = false,
  });

  String name(bool isArabic) => isArabic ? nameAr : nameEn;
  String category(bool isArabic) => isArabic ? categoryAr : categoryEn;
  String description(bool isArabic) => isArabic ? descriptionAr : descriptionEn;
  String? headline(bool isArabic) => isArabic ? headlineAr : headlineEn;
  String? subtitle(bool isArabic) => isArabic ? subtitleAr : subtitleEn;

  String problem(bool isArabic) => isArabic ? problemAr : problemEn;
  String solution(bool isArabic) => isArabic ? solutionAr : solutionEn;
  String architecture(bool isArabic) =>
      isArabic ? architectureAr : architectureEn;
  String stateManagement(bool isArabic) =>
      isArabic ? stateManagementAr : stateManagementEn;
  String apiBackend(bool isArabic) => isArabic ? apiBackendAr : apiBackendEn;
  String keyFeatures(bool isArabic) => isArabic ? keyFeaturesAr : keyFeaturesEn;
}
