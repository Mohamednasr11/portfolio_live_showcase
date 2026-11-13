class WebLink {
  const WebLink(this.label, this.url);

  final String label;
  final String url;
}

class CodeProject {
  const CodeProject({
    required this.name,
    required this.summary,
    required this.summaryAr,
    required this.points,
    required this.pointsAr,
    required this.stack,
    required this.links,
  });

  final String name;
  final String summary;
  final String summaryAr;
  final List<String> points;
  final List<String> pointsAr;
  final List<String> stack;
  final List<WebLink> links;
}

class CaseStudyInfo {
  const CaseStudyInfo({
    required this.demoId,
    required this.previewStep,
    required this.source,
    required this.sourceAr,
    this.links = const [],
  });

  final String demoId;
  final int previewStep;
  final String source;
  final String sourceAr;
  final List<WebLink> links;
}

class SkillGroup {
  const SkillGroup(this.title, this.titleAr, this.skills, this.evidence, this.evidenceAr);

  final String title;
  final String titleAr;
  final List<String> skills;
  final String evidence;
  final String evidenceAr;
}

class TimelineEntry {
  const TimelineEntry({
    required this.title,
    required this.titleAr,
    required this.place,
    required this.placeAr,
    required this.period,
    required this.periodAr,
    required this.points,
    required this.pointsAr,
  });

  final String title;
  final String titleAr;
  final String place;
  final String placeAr;
  final String period;
  final String periodAr;
  final List<String> points;
  final List<String> pointsAr;
}

class Highlight {
  const Highlight(this.title, this.titleAr, this.body, this.bodyAr);

  final String title;
  final String titleAr;
  final String body;
  final String bodyAr;
}

abstract final class Profile {
  static const name = 'Mohamed Nasr Eldeen';
  static const role = ' Flutter Developer';
  static const roleAr = 'مطور فلاتر ';
  
  static const intro =
      'Passionate Flutter Developer and Computer Science undergraduate at '
      'Mansoura University. Crafting exceptional, high-performance mobile applications '
      'with BLoC/Cubit state management, Clean Architecture, robust local/cloud data '
      'integration, and meticulous UI/UX precision.';
  
  static const introAr =
      'مطور تطبيقات فلاتر شغوف وطالب علوم حاسب بجامعة المنصورة. متخصص في بناء تطبيقات موبايل '
      'عالية الأداء مع إدارة الحالة باستخدام BLoC/Cubit والهندسة النظيفة (Clean Architecture)، '
      'مع تكامل متين للبيانات والتركيز الدقيق على تجربة المستخدم.';

  static const email = 'mohamed.nasr.flutter@gmail.com';
  static const githubUrl = 'https://github.com/Mohamednasr11';
  static const linkedinUrl =
      'https://www.linkedin.com/in/mohamed-nasr-eldeen-3057b8240/';
  static const sourceUrl =
      'https://github.com/Mohamednasr11/portfolio_live_showcase';

  static const matjarkomRepo =
      'https://github.com/Mo-Nasr-Eldeen/ITI-Final-Project';
  static const matjarkomLive = 'https://iti-final-project-w77f.vercel.app/';

  static const caseStudies = [
    CaseStudyInfo(
      demoId: 'matjarkom',
      previewStep: 2,
      source: 'ITI Final Project. Fully interactive e-commerce suite with AI shopping assistant.',
      sourceAr: 'مشروع تخرج ITI. متجر إلكتروني متكامل مع مساعد تسوق ذكي.',
      links: [
        WebLink('Source code', matjarkomRepo),
        WebLink('Web build', matjarkomLive),
      ],
    ),
    CaseStudyInfo(
      demoId: 'build_guard',
      previewStep: 0,
      source: 'UX case study for smart engineering inspection and crack detection.',
      sourceAr: 'دراسة حالة لتطبيق الفحص الهندسي الذكي والكشف عن الشقوق.',
    ),
    CaseStudyInfo(
      demoId: 'brew_and_bloom',
      previewStep: 1,
      source: 'UX case study for artisanal coffee ordering and live delivery tracking.',
      sourceAr: 'دراسة حالة لتطبيق طلب القهوة وتتبع التوصيل المباشر.',
    ),
    CaseStudyInfo(
      demoId: 'trustsafe',
      previewStep: 1,
      source: 'UX case study for secure access auditing and threat analysis.',
      sourceAr: 'دراسة حالة لتطبيق الأمان وفحص الصلاحيات المتقدم.',
    ),
  ];

  static const codeProjects = [
    CodeProject(
      name: 'Matjarkom',
      summary: 'Advanced e-commerce ecosystem featuring an integrated AI shopping assistant.',
      summaryAr: 'منصة تجارة إلكترونية متقدمة تضم مساعد تسوق ذكي مدعوم بالذكاء الاصطناعي.',
      points: [
        'AI shopping assistant chat workflow powered by n8n automation.',
        'Scalable BLoC and HydratedCubit state management with Clean Architecture.',
        'Firebase authentication, real-time database, and interactive OpenStreetMap delivery.',
      ],
      pointsAr: [
        'مساعد تسوق ذكي للدردشة مدعوم بأتمتة n8n.',
        'إدارة حالة احترافية باستخدام BLoC و HydratedCubit مع الهندسة النظيفة.',
        'مصادقة Firebase وقاعدة بيانات فورية مع خرائط OpenStreetMap تفاعلية.',
      ],
      stack: ['Flutter', 'BLoC', 'HydratedCubit', 'Firebase', 'n8n', 'OSM'],
      links: [
        WebLink('Repository', matjarkomRepo),
        WebLink('Web build', matjarkomLive),
      ],
    ),
    CodeProject(
      name: 'Fitness Tracker',
      summary: 'Offline-first professional workout logger with interactive progress charts.',
      summaryAr: 'تطبيق تمارين رياضية متقدم يعمل بدون انترنت مع رسوم بيانية تفاعلية.',
      points: [
        'Clean Architecture + MVVM pattern ensuring separation of concerns.',
        'Robust SQLite relational data persistence without backend dependency.',
        'Dynamic fl_chart statistics and persistent dark/light theme switching.',
        'Comprehensive Cubit unit testing using bloc_test and mocktail.',
      ],
      pointsAr: [
        'فصل الطبقات باستخدام Clean Architecture و MVVM.',
        'تخزين محلي قوي باستخدام SQLite بدون الاعتماد على خادم خارجي.',
        'رسوم بيانية تفاعلية باستخدام fl_chart مع دعم الوضع الليلي والنهاري.',
        'اختبارات وحدات شاملة باستخدام bloc_test و mocktail.',
      ],
      stack: ['Flutter', 'Cubit', 'get_it', 'sqflite', 'fl_chart'],
      links: [
        WebLink(
          'Repository',
          'https://github.com/Mohamednasr11/code_alpha_fitness_tracker_app',
        ),
      ],
    ),
    CodeProject(
      name: 'Meals App',
      summary: 'Gourmet meal catalog with full CRUD operations and responsive navigation.',
      summaryAr: 'كتالوج وجبات طعام فاخرة مع عمليات CRUD كاملة وتنقل سلس.',
      points: [
        'BLoC state container keeping item lists perfectly synchronized.',
        'SQFlite offline caching ensuring seamless user experience across app sessions.',
        'GoRouter navigation architecture handling deep links and parameter passing.',
      ],
      pointsAr: [
        'حاوية حالة BLoC تحافظ على مزامنة قوائم العناصر.',
        'تخزين محلي عبر SQFlite لضمان استمرارية البيانات بسلاسة.',
        'هندسة تنقل GoRouter للتعامل مع الروابط العميقة.',
      ],
      stack: ['Flutter', 'BLoC', 'sqflite', 'GoRouter'],
      links: [
        WebLink('Repository', 'https://github.com/Mohamednasr11/meals_app'),
      ],
    ),
    CodeProject(
      name: 'Smart Route Finder',
      summary: 'University AI pathfinding project comparing heuristic search algorithms.',
      summaryAr: 'مشروع خوارزميات ذكاء اصطناعي جامعي لمقارنة خوارزميات البحث الذكي.',
      points: [
        'A* utility-based algorithm benchmarked against Greedy Best-First search.',
        'Manhattan distance heuristics with step-by-step visual animation.',
        'Detailed metrics reporting explored nodes, optimal path length, and time.',
      ],
      pointsAr: [
        'مقارنة بين خوارزمية A* وخوارزمية Greedy Best-First.',
        'استخدام مسافة منهاتن مع رسوم متحركة خطوة بخطوة.',
        'تقارير تفصيلية عن العقد المستكشفة وطول المسار.',
      ],
      stack: ['Flutter', 'Dart', 'A*', 'Greedy BFS'],
      links: [
        WebLink(
          'Repository',
          'https://github.com/Mohamednasr11/smart_route_finder',
        ),
      ],
    ),
    CodeProject(
      name: 'Portfolio Showcase',
      summary: 'Interactive web showcase featuring live Flutter widgets instead of static images.',
      summaryAr: 'معرض أعمال تفاعلي يعرض ويدجتس فلاتر حية بدلاً من الصور الثابتة.',
      points: [
        'Custom presentation engine with a scriptable, testable timeline.',
        'RTL Arabic support and dynamic theme adaptation.',
        'Responsive layout running seamlessly from mobile to desktop, deployed on Vercel.',
      ],
      pointsAr: [
        'محرك عروض تقديمية مخصص مع خط زمني قابل للاختبار.',
        'دعم كامل للغة العربية (RTL) وتكيف ديناميكي مع الثيمات.',
        'تصميم متجاوب يعمل بسلاسة من الهاتف إلى سطح المكتب ومنشور على Vercel.',
      ],
      stack: ['Flutter web', 'ChangeNotifier', 'flutter_test', 'Vercel'],
      links: [WebLink('Repository', sourceUrl)],
    ),
  ];

  static const skills = [
    SkillGroup(
      'Core & Framework',
      'الأساسيات وإطار العمل',
      ['Dart', 'Flutter', 'Flutter web', 'Responsive UI', 'Custom Animations'],
      'Every project in this portfolio',
      'جميع المشاريع في هذا المعرض',
    ),
    SkillGroup(
      'State & Architecture',
      'إدارة الحالة والهندسة',
      ['BLoC', 'Cubit', 'HydratedCubit', 'Clean Architecture', 'MVVM', 'get_it'],
      'Matjarkom, Fitness Tracker, Meals App',
      'متجرك، متتبع اللياقة، تطبيق الوجبات',
    ),
    SkillGroup(
      'Data & Cloud',
      'البيانات والسحاب',
      ['Firebase Auth/Firestore', 'SQLite / sqflite', 'SharedPreferences', 'n8n AI Agents', 'OpenStreetMap'],
      'Matjarkom, Fitness Tracker',
      'متجرك، متتبع اللياقة',
    ),
    SkillGroup(
      'Navigation & UI',
      'التنقل واجهات المستخدم',
      ['GoRouter', 'Named Routes', 'fl_chart', 'Custom Painters', 'RTL / Arabic Typography'],
      'Meals App, Fitness Tracker, Portfolio',
      'تطبيق الوجبات، متتبع اللياقة، معرض الأعمال',
    ),
    SkillGroup(
      'Testing & DevOps',
      'الاختبار والنشر',
      ['flutter_test', 'bloc_test', 'mocktail', 'Git & GitHub', 'Vercel Deployment'],
      'Fitness Tracker, Portfolio',
      'متتبع اللياقة، معرض الأعمال',
    ),
    SkillGroup(
      'Computer Science',
      'علوم الحاسب',
      ['A* Search', 'Greedy Best-First', 'Heuristics', 'Algorithm Analysis'],
      'Smart Route Finder',
      'مكتشف المسارات الذكي',
    ),
  ];

  static const highlights = [
    Highlight(
      'Live Widgets over Static Mockups',
      'ويجتس حية وليست صوراً ثابتة',
      'Each case study runs live Flutter widget trees inside device frames, providing an authentic interactive experience.',
      'كل دراسة حالة تشغل شجرة ويدجتس حقيقية داخل إطار جهاز، مما يوفر تجربة تفاعلية أصيلة.',
    ),
    Highlight(
      'Testable Presentation Engine',
      'محرك عروض قابل للاختبار',
      'Driven by an injectable ChangeNotifier controller enabling robust automated verification without wall-clock dependency.',
      'مدعوم بتحكم مرن يتيح اختباراً آلياً دون الاعتماد على وقت الجهاز الفعلي.',
    ),
    Highlight(
      'Zero Layout Overflow Assurance',
      'ضمان عدم تجاوز التخطيط',
      'Rigorous widget test suites pump every screen across multiple breakpoints to guarantee absolute responsiveness.',
      'مجموعة اختبارات صارمة تفحص كل شاشة عبر مختلف المقاسات لضمان التجاوب التام.',
    ),
    Highlight(
      'Seamless Multilingual & Theme Support',
      'دعم سلس للغات والثيمات',
      'Dynamic Arabic/English localization with RTL layout switching and instant Dark/Light mode adaptation.',
      'دعم ديناميكي للعربية والإنجليزية مع تبديل الاتجاه (RTL) وتكيف فوري مع الوضع الليلي والنهاري.',
    ),
  ];

  static const experience = [
    TimelineEntry(
      title: 'Data Annotation & Customer Support Specialist',
      titleAr: 'أخصائي تعليق بيانات ودعم عملاء',
      place: 'Soualy Company · Remote',
      placeAr: 'شركة سوايلي · عن بعد',
      period: 'Jul 2024 – Aug 2024',
      periodAr: 'يوليو 2024 – أغسطس 2024',
      points: [
        'Evaluated and categorized structured machine-learning dataset samples against strict quality guidelines.',
        'Managed responsive remote client communications and service follow-ups.',
      ],
      pointsAr: [
        'تقييم وتصنيف عينات بيانات مهيكلة لتعلم الآلة وفق معايير الجودة.',
        'إدارة التواصل الفعال مع العملاء ومتابعة الخدمات عن بعد.',
      ],
    ),
  ];

  static const education = [
    TimelineEntry(
      title: 'B.Sc. Computer Science and Information Systems',
      titleAr: 'بكالوريوس علوم الحاسب ونظم المعلومات',
      place: 'Mansoura University',
      placeAr: 'جامعة المنصورة',
      period: 'Expected Oct 2027',
      periodAr: 'متوقع أكتوبر 2027',
      points: [
        'Core coursework: software engineering, mobile app development, and database architecture.',
      ],
      pointsAr: [
        'المقررات الأساسية: هندسة البرمجيات، تطوير تطبيقات الموبايل، وتصميم قواعد البيانات.',
      ],
    ),
    TimelineEntry(
      title: 'Professional Flutter Training Track',
      titleAr: 'منحة تطوير تطبيقات فلاتر الاحترافية',
      place: 'ITI (Information Technology Institute)',
      placeAr: 'معهد تكنولوجيا المعلومات (ITI)',
      period: 'Final Project: Matjarkom',
      periodAr: 'المشروع النهائي: متجرك',
      points: ['Successfully architected and developed the Matjarkom e-commerce platform.'],
      pointsAr: ['تصميم وتطوير منصة التجارة الإلكترونية "متجرك" كمشروع تخرج احترافي.'],
    ),
    TimelineEntry(
      title: 'Digital Marketing Summer Training',
      titleAr: 'تدريب صيفي في التسويق الرقمي',
      place: 'ITIDA / NTI',
      placeAr: 'هيئة تنمية صناعة تكنولوجيا المعلومات / المعهد القومي للاتصالات',
      period: 'Jun – Jul 2025',
      periodAr: 'يونيو – يوليو 2025',
      points: ['Completed 120 intensive hours covering technical marketing and freelance fundamentals.'],
      pointsAr: ['إتمام 120 ساعة تدريبية مكثفة تشمل التسويق التقني وأساسيات العمل الحر.'],
    ),
  ];
}
