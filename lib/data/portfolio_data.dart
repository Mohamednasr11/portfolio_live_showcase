import '../models/project.dart';

class PortfolioData {
  const PortfolioData._();

  static const String name = 'Mohamed Nasr Eldeen';
  static const String titleEn =
      'Flutter Developer | Mobile Application Developer';
  static const String titleAr = 'مطور تطبيقات فلاتر | مطور تطبيقات الهاتف';

  static const String universityEn = 'Mansoura University — Computer Science';
  static const String universityAr =
      'جامعة المنصورة — كلية الحاسبات والمعلومات';

  static const String email = 'mohamed.nasr.flutter@gmail.com';
  static const String phone = '2010960743334';
  static const String githubUrl = 'https://github.com/Mohamednasr11';
  static const String linkedinUrl =
      'https://www.linkedin.com/in/mohamed-nasr-eldeen-3057b8240/';

  static const String heroIntroEn =
      "I'm a Computer Science undergraduate and Flutter Developer passionate about building scalable, high-performance mobile applications. I specialize in Clean Architecture, BLoC/Cubit state management, API integration, and Firebase services, with a strong focus on maintainable code and exceptional user experiences.";

  static const String heroIntroAr =
      "أنا طالب في كلية الحاسبات والمعلومات ومطور تطبيقات فلاتر شغوف ببناء تطبيقات جوال عالية الأداء وقابلة للتوسع. أتخصص في المعمارية النظيفة (Clean Architecture)، وإدارة الحالة (BLoC/Cubit)، وربط واجهات البرمجة (APIs)، وخدمات Firebase مع تركيز قوي على الشفرات البرمجية القابلة للصيانة وتجارب المستخدم الاستثنائية.";

  static const List<Project> flutterProjects = [
    Project(
      id: 'build_guard',
      nameEn: 'BuildGuard',
      nameAr: 'بيَلد جارد (BuildGuard)',
      categoryEn: 'CONSTRUCTION · SAFETY & INCIDENT MANAGEMENT',
      categoryAr: 'إنشاءات · إدارة السلامة والبلاغات',
      image: 'assets/buildguard/shield_house.png',
      headlineEn: 'AI-assisted construction site safety & incident management',
      headlineAr:
          'نظام إدارة وتوثيق سلامة مواقع البناء المدعوم بالذكاء الاصطناعي',
      subtitleEn: 'Real-time issue logging, inspection requests, & reporting',
      subtitleAr: 'توثيق الأعطال، طلبات المعاينة، وتقارير المخاطر المباشرة',
      descriptionEn: 'A mobile safety inspection application enabling site engineers to log risk reports, attach media, trigger provider service requests, and track remediation workflows in real time.',
      descriptionAr: 'تطبيق جوال لفحص ومعاينة السلامة يتيح لمهندسي الموقع تسجيل تقارير المخاطر، إرفاق الصور والوسائط، طلب خدمات الصيانة المباشرة، ومتابعة خطوات الإصلاح.',
      tags: [
        'Flutter',
        'Firebase',
        'Clean Architecture',
        'Camera API',
        'REST API',
      ],
      gallery: [
        'assets/buildguard/shield_house.png',
        'assets/buildguard/scan_crack.png',
      ],
      githubUrl: 'https://github.com/Mohamednasr11/Build-Guard',
      isFeatured: true,
      problemEn: 'Construction sites suffer from delayed hazard reporting, paper-based inspection forms, and fragmented communication between site inspectors and service technicians.',
      problemAr: 'تعاني مواقع البناء من تأخر الإبلاغ عن المخاطر، والاعتماد على النماذج الورقية، وتشتت التواصل بين فاحصي الموقع وفنيي الصيانة.',
      solutionEn: 'Built a streamlined mobile system where engineers capture site hazards, categorize risk levels (High/Medium/Low), submit report tickets, and track repair steps seamlessly.',
      solutionAr: 'بناء تطبيق جوال سلس يتيح للمهندسين التقاط المخاطر بالموقع، تصنيف مستويات الخطر (مرتفع/متوسط/منخفض)، إرسال تذاكر البلاغات، ومتابعة مراحل التعديل.',
      architectureEn: 'Structured using Clean Architecture (Data, Domain, and Presentation layers) to isolate business logic from UI elements.',
      architectureAr: 'مبني وفق معمارية Clean Architecture لتقسيم الكود إلى طبقات (البيانات، المنطق، والواجهة) لعزل منطق العمل عن عناصر UI.',
      stateManagementEn: 'Utilized BLoC/Cubit to manage dynamic report states, attachment uploads, and interactive form submissions cleanly.',
      stateManagementAr: 'استخدام BLoC/Cubit لإدارة حالة التقارير المباشرة، رفع المرفقات، وإرسال النماذج التفاعلية بأسلوب منظم.',
      apiBackendEn: 'Firebase Authentication for identity verification and Firestore/Cloud Storage for real-time ticket sync & media handling.',
      apiBackendAr: 'مصادقة Firebase للتحقق من هوية المستخدمين وCloud Firestore Storage لمزامنة البلاغات ورفع الصور والوسائط.',
      keyFeaturesEn: '• Multi-tier Risk Assessment (Low/Medium/High)\n• Photo & Document Attachment Modal\n• Appointment Booking with Technicians\n• Live Status Tracking (Active / Resolved)',
      keyFeaturesAr: '• تقييم المخاطر متعدد المستويات (منخفض/متوسط/عالي)\n• نافذة إرفاق الصور والمستندات\n• حجز مواعيد معاينة مع الفنيين\n• متابعة حالة البلاغات (نشطة / مكتملة)',
    ),
    Project(
      id: 'matjarkom',
      nameEn: 'Matjarkom',
      nameAr: 'متجركم (Matjarkom)',
      categoryEn: 'E-COMMERCE · MOBILE APPLICATION',
      categoryAr: 'تجارة إلكترونية · تطبيق جوال',
      image: 'assets/matjarkom/hero_watch.png',
      headlineEn:
          'Modern e-commerce platform with product catalogs & cart management',
      headlineAr: 'منصة تسوق إلكتروني متكاملة بعرض المنتجات وإدارة السلة',
      subtitleEn:
          'Feature-rich shopping experience with Firebase & clean UI design',
      subtitleAr: 'تجربة تسوق سلسة مع خدمات Firebase وتصميم واجهة عصري',
      descriptionEn: 'A polished Flutter e-commerce application offering dynamic product category browsing, wishlist management, cart operations, and streamlined checkout UI.',
      descriptionAr: 'تطبيق تجارة إلكترونية متكامل بـ Flutter يقدم تصفحاً ديناميكياً للفئات، قائمة المفضلات، عمليات السلة، ومسار إتمام الشراء.',
      tags: ['Flutter', 'Firebase', 'State Management', 'UI/UX'],
      gallery: [
        'assets/matjarkom/hero_watch.png',
        'assets/matjarkom/cat_beauty.png',
        'assets/matjarkom/cat_fragrances.png',
        'assets/matjarkom/cat_furniture.png',
      ],
      githubUrl: 'https://github.com/Mohamednasr11',
      isFeatured: true,
      problemEn: 'E-commerce applications often struggle with slow initial load times, choppy list animations, and messy state management during cart modifications.',
      problemAr: 'تعاني العديد من تطبيقات التسوق من بطء التحميل الأولي، عدم انسيابية التمرير، وتشتت إدارة حالة سلة التسوق.',
      solutionEn: 'Designed a clean Flutter UI architecture with reactive state updates for item quantities, instant total calculation, and dark-theme optimized views.',
      solutionAr: 'تصميم معمارية مرنة في Flutter مع تحديثات تفاعلية لسلة التسوق، حساب فوري للإجمالي، وتصميم مريح للعين بالوضع الداكن.',
      architectureEn: 'Layered component structure separating UI screens, custom widgets, and state controllers.',
      architectureAr: 'بناء مكونات مقسمة تعزل شاشات الواجهة، العناصر المعاد استخدامها، ومتحكمات الحالة.',
      stateManagementEn: 'Provider / Cubit state management handling cart state, wishlist toggles, and payment step navigation.',
      stateManagementAr: 'إدارة الحالة عبر Provider/Cubit لتحديث سلة الشراء، قائمة المفضلات، والتنقل في خطوات الدفع.',
      apiBackendEn: 'Firebase Firestore backend for product catalogs and user profile data.',
      apiBackendAr: 'قاعدة بيانات Firebase Firestore لإدارة منتجات المتجر وبيانات ملف المستخدم.',
      keyFeaturesEn: '• Category Browsing & Search\n• Cart & Quantity Management\n• Favorites & Wishlist Sync\n• Dark Theme & Responsive Layout',
      keyFeaturesAr: '• تصفح الفئات والبحث السريع\n• إدارة سلة التسوق والكميات\n• مزامنة المفضلة والمحتويات\n• وضع داكن وتصميم متجاوب',
    ),
    Project(
      id: 'yalla_go',
      nameEn: 'Yalla Go App',
      nameAr: 'تطبيق يلا جو (Yalla Go)',
      categoryEn: 'LOGISTICS · GRAPHQL & FCM',
      categoryAr: 'خدمات وشحن · GraphQL وتنبيهات FCM',
      image: 'assets/brewbloom/onboarding_cup.png',
      headlineEn: 'Service & delivery mobile solution powered by GraphQL',
      headlineAr: 'تطبيق طلبات وخدمات الاعتماد على GraphQL وFirebase',
      subtitleEn: 'GraphQL query integration, Firebase Auth, & Cloud Messaging',
      subtitleAr: 'استعلامات GraphQL، مصادقة Firebase، وإشعارات FCM',
      descriptionEn: 'A responsive mobile app designed for service requests, featuring GraphQL data fetching, secure user authentication, and push notifications via FCM.',
      descriptionAr: 'تطبيق جوال مرن لطلبات الخدمات، يضم استعلامات GraphQL، مصادقة آمنة للمستخدمين، وتنبيهات فورية عبر Firebase Cloud Messaging.',
      tags: ['Flutter', 'GraphQL', 'Firebase Auth', 'FCM', 'Cubit'],
      gallery: [
        'assets/brewbloom/onboarding_cup.png',
        'assets/brewbloom/prod_flat.png',
        'assets/brewbloom/prod_mocha.png',
      ],
      githubUrl: 'https://github.com/Mohamednasr11',
      isFeatured: false,
      problemEn: 'REST endpoints can lead to over-fetching of data on slow mobile networks when retrieving complex user order histories and service statuses.',
      problemAr: 'قد تؤدي واجهات REST التقليدية لجلب بيانات فائضة على شبكات المحمول الضعيفة عند استرجاع سجلات الطلبات وشاشات الخدمة.',
      solutionEn: 'Implemented GraphQL queries and mutations to request precise payload shapes, coupled with FCM push notifications for real-time status updates.',
      solutionAr: 'تنفيذ استعلامات ومُعدلات GraphQL لجلب الحقول المطلوبة فقط بكتلة بيانات دقيقة، مع ربط إشعارات FCM للتنبيهات الفورية.',
      architectureEn: 'Feature-first project organization with clear separation between network services and Cubit presentation states.',
      architectureAr: 'تنظيم المشروع حسب الميزات (Feature-first) مع الفصل التام بين خدمات الشبكة وحالات Cubit.',
      stateManagementEn: 'Cubit state management for responsive UI updates and modal state handling.',
      stateManagementAr: 'إدارة حالة Cubit للتحديثات السريعة في الشاشات وتتبع النوافذ التفاعلية.',
      apiBackendEn: 'GraphQL API client, Firebase Authentication, and Firebase Cloud Messaging (FCM).',
      apiBackendAr: 'عميل GraphQL API، مصادقة Firebase، وإشعارات Firebase Cloud Messaging (FCM).',
      keyFeaturesEn: '• Flexible Service Ordering Flow\n• GraphQL Precise Data Queries\n• Push Notifications via FCM\n• User Account & Order History',
      keyFeaturesAr: '• مسار طلب خدمات مرن وسريع\n• استعلامات GraphQL دقيقة\n• إشعارات دفع عبر FCM\n• إدارة حساب المستخدم وسجل الطلبات',
    ),
    Project(
      id: 'procurement_system',
      nameEn: 'Procurement Approval System',
      nameAr: 'نظام الموافقة على المشتريات',
      categoryEn: 'ENTERPRISE · LOCAL DATA PERSISTENCE',
      categoryAr: 'مؤسسي · التخزين المحالي المتقدم',
      image: 'assets/brewbloom/promo_cups.png',
      headlineEn: 'Enterprise workflow manager with local offline persistence',
      headlineAr: 'نظام إدارة المشتريات وتتبع الموافقات بالتخزين المحلي',
      subtitleEn: 'Clean Architecture, BLoC, & Drift relational database',
      subtitleAr: 'معمارية نظيفة، BLoC، وقاعدة بيانات Drift المحلية',
      descriptionEn: 'An enterprise mobile tool allowing department managers to review procurement requests, record offline approvals, and synchronize data using Drift SQL persistence.',
      descriptionAr: 'تطبيق جوال للمؤسسات يتيح لمديري الأقسام مراجعة طلبات الشراء، تسجيل الموافقات في حالة عدم الاتصال، ومزامنة البيانات عبر Drift.',
      tags: ['Flutter', 'Clean Architecture', 'BLoC', 'Drift', 'SQLite'],
      gallery: [
        'assets/brewbloom/promo_cups.png',
        'assets/brewbloom/courier.png',
      ],
      githubUrl: 'https://github.com/Mohamednasr11',
      isFeatured: false,
      problemEn: 'Managers in remote warehouse locations required uninterrupted access to procurement documentation even without an active internet connection.',
      problemAr: 'يحتاج المديرون في المواقع النائية إلى استعراض وثائق المشتريات والموافقة عليها بدون انقطاع حتى عند غياب شبكة الإنترنت.',
      solutionEn: 'Built an offline-first mobile app using Drift (Reactive SQLite for Dart) that guarantees request persistence and smooth sync upon network recovery.',
      solutionAr: 'بناء تطبيق يركز على العمل بدون اتصال باستخدام مكتبة Drift لقواعد بيانات SQLite التفاعلية لضمان حفظ الطلبات ومزامنتها فور توفر الشبكة.',
      architectureEn: 'Clean Architecture with dedicated Local Data Sources wrapping Drift DAOs.',
      architectureAr: 'معمارية Clean Architecture مع طبقة مصادر بيانات محلية تدير كائنات Drift DAOs.',
      stateManagementEn: 'BLoC managing transactional approval states and local query filters.',
      stateManagementAr:
          'BLoC لإدارة حالات الموافقة وتصفية الاستعلامات المحلية.',
      apiBackendEn: 'Drift (Type-safe SQLite for Flutter & Dart) with local caching and REST API sync layers.',
      apiBackendAr: 'قاعدة بيانات Drift مع محرك SQLite التفاعلي والتخزين المحلي ومزامنة واجهات REST.',
      keyFeaturesEn: '• Offline Procurement Request Review\n• Type-safe Drift SQLite Persistence\n• Approval Workflow Authorization\n• Search & Status Filter Matrix',
      keyFeaturesAr: '• مراجعة طلبات الشراء بدون اتصال بالإنترنت\n• تخزين تفاعلي آمن مع Drift SQLite\n• مسار الموافقة والاعتمادات\n• مصفوفة بحث وتصفية الحالات',
    ),
    Project(
      id: 'tmdb_movie_app',
      nameEn: 'TMDB Movie Application',
      nameAr: 'تطبيق الأفلام TMDB',
      categoryEn: 'ENTERTAINMENT · API INTEGRATION',
      categoryAr: 'ترفيه · ربط واجهات البرمجة',
      image: 'assets/matjarkom/cat_groceries.png',
      headlineEn: 'Movie browsing & discovery application powered by TMDB API',
      headlineAr: 'تطبيق استكشاف ومتابعة الأفلام والمسلسلات عبر TMDB API',
      subtitleEn:
          'Clean Architecture with BLoC state management & Dio HTTP client',
      subtitleAr: 'معمارية نظيفة باستخدام BLoC وعميل Dio لإدارة شبكة الاتصال',
      descriptionEn: 'A feature-packed movie exploration app demonstrating robust networking with Dio, error handling, clean repository pattern, and responsive grid layouts.',
      descriptionAr: 'تطبيق متكامل لاستكشاف الأفلام يقدم نموذجاً مثالياً للربط مع واجهات البرمجة باستخدام Dio، معالجة الأخطاء، نمط Repository، وتنسيقات مرنة.',
      tags: ['Flutter', 'Clean Architecture', 'BLoC', 'Dio', 'REST API'],
      gallery: [
        'assets/matjarkom/cat_groceries.png',
        'assets/matjarkom/logo.png',
      ],
      githubUrl: 'https://github.com/Mohamednasr11',
      isFeatured: false,
      problemEn: 'Building complex media browsing apps requires efficient API response parsing, pagination handling, and seamless image caching without UI stutter.',
      problemAr: 'يتطلب بناء تطبيقات استكشاف الوسائط معالجة كفء لردود واجهات البرمجة، إدارة الصفحات المتعاقبة (Pagination)، والتخزين المؤقت للصور بدون تباطؤ.',
      solutionEn: 'Engineered a scalable Flutter architecture with Dio interceptors, error mapping, and asynchronous page loading for trending movies and cast details.',
      solutionAr: 'تطوير معمارية فلاتر قابلة للتوسع مع اعتراض طلبات الشبكة (Dio Interceptors)، معالجة الأخطاء، والتحميل المتتابع للأفلام الأكثر تداولاً وتفاصيل طاقم العمل.',
      architectureEn: 'Strict Clean Architecture separating data models, repository interfaces, use cases, and presentation states.',
      architectureAr: 'تطبيق صارم لمعمارية Clean Architecture يعزل نماذج البيانات، الواجهات (Repositories)، حالات الاستخدام (Use Cases)، وعروض الشاشة.',
      stateManagementEn: 'BLoC pattern managing distinct UI states: Loading, Success, Error, and LoadMore.',
      stateManagementAr: 'نمط BLoC لإدارة حالات الشاشة المختلفة: التحميل، النجاح، الخطأ، والتحميل الإضافي.',
      apiBackendEn: 'TMDB v3 REST API via Dio with query parameter customization for movie categories and search endpoints.',
      apiBackendAr: 'واجهة برمجة TMDB v3 REST API عبر Dio مع تخصيص معلمات البحث وفئات الأفلام.',
      keyFeaturesEn: '• Trending & Popular Movies feeds\n• Detailed Movie Profiles & Ratings\n• Search & Genre Filtering\n• Optimized Image Caching',
      keyFeaturesAr: '• قوائم الأفلام الأكثر تداولاً والشعبية\n• تفاصيل شاملة عن الفيلم والتقييمات\n• البحث والتصفية حسب الفئة\n• تخزين مؤقت محين للصور',
    ),
  ];

  static const List<Project> webProjects = [
    Project(
      id: 'manara_store',
      nameEn: 'Manara Store',
      nameAr: 'متجر منارة (Manara Store)',
      categoryEn: 'WEB DEVELOPMENT · FULL-STACK E-COMMERCE',
      categoryAr: 'تطوير الويب · متجر إلكتروني متكامل',
      image: 'assets/matjarkom/cat_furniture.png',
      headlineEn: 'Full-stack web development project for online retail',
      headlineAr: 'مشروع تطوير موقع تجارة إلكترونية متكامل على الويب',
      subtitleEn: 'Responsive web interface with catalog management & backend integration',
      subtitleAr: 'واجهة ويب متجاوبة مع إدارة المنتجات وربط الخادم',
      descriptionEn: 'A web application built for online store management, showcasing full-stack web development skills, responsive web design, and RESTful web API consumption.',
      descriptionAr: 'مشروع متجر ويب تم تطويره لإدارة المبيعات، يستعرض مهارات تطوير الويب المتكامل، التصميم المتجاوب، والتعامل مع واجهات الويب البرمجية.',
      tags: ['Web Development', 'JavaScript', 'HTML/CSS', 'REST APIs', 'Git'],
      gallery: ['assets/matjarkom/cat_furniture.png'],
      githubUrl: 'https://github.com/Mohamednasr11/manara',
      isFeatured: false,
      isWebProject: true,
      problemEn: 'Small businesses need affordable, fast, and responsive web portals to showcase products online with easy management access.',
      problemAr: 'تحتاج الأعمال الناشئة إلى منصات ويب سريعة ومتجاوبة لعرض المنتجات عبر الإنترنت مع سهولة الإدارة.',
      solutionEn: 'Developed a web platform featuring product listings, responsive CSS styling, and structured web service interactions.',
      solutionAr: 'تطوير منصة ويب تتميز بعرض منتجات منظمة، تنسيق مرن، وتفاعل مباشر مع واجهات الويب البرمجية.',
      architectureEn: 'Modular web project architecture separating markup, styling, and application logic.',
      architectureAr:
          'معمارية ويب مقسمة تعزل التنسيقات عن هيكل الصفحة ومنطق العمل.',
      stateManagementEn: 'Vanilla JavaScript & web framework state binding for UI interactions.',
      stateManagementAr:
          'ربط حالة واجهة الويب عبر JavaScript لتقديم تفاعل سريع للمستخدم.',
      apiBackendEn:
          'RESTful web APIs for product endpoints and customer submissions.',
      apiBackendAr:
          'واجهات برمجة RESTful لمعالجة بيانات المنتجات وطلبات العملاء.',
      keyFeaturesEn: '• Full-stack Web Store Architecture\n• Responsive Multi-device Layout\n• Dynamic Product Listing\n• Web API Integration',
      keyFeaturesAr: '• معمارية متجر ويب متكاملة\n• تخطيط مرن لكافة الشاشات\n• عرض ديناميكي للمنتجات\n• ربط واجهات الويب البرمجية',
    ),
  ];

  static const List<Map<String, dynamic>> skillCategories = [
    {
      'titleEn': 'Mobile Development',
      'titleAr': 'تطوير تطبيقات الجوال',
      'icon': 'phone',
      'skills': [
        'Flutter',
        'Dart',
        'BLoC',
        'Cubit',
        'Provider',
        'Widgets & Custom Painters',
      ],
    },
    {
      'titleEn': 'Architecture & Design',
      'titleAr': 'المعمارية وأنماط التصميم',
      'icon': 'architecture',
      'skills': [
        'Clean Architecture',
        'Repository Pattern',
        'Dependency Injection',
        'OOP',
        'SOLID Principles',
      ],
    },
    {
      'titleEn': 'Backend & Cloud Integration',
      'titleAr': 'ربط الخلفيات والخدمات السحابية',
      'icon': 'cloud',
      'skills': [
        'Firebase Auth',
        'Cloud Firestore',
        'FCM Push Notifications',
        'REST APIs',
        'GraphQL',
        'Dio Client',
      ],
    },
    {
      'titleEn': 'Tools & Data Persistence',
      'titleAr': 'الأدوات وقواعد البيانات المحلية',
      'icon': 'storage',
      'skills': [
        'Git & GitHub',
        'Postman',
        'Android Studio',
        'VS Code',
        'Drift / SQLite',
        'Shared Preferences',
      ],
    },
  ];

  static const List<Map<String, dynamic>> educationAndTraining = [
    {
      'typeEn': 'Education',
      'typeAr': 'التعليم الأكاديمي',
      'titleEn': 'Mansoura University',
      'titleAr': 'جامعة المنصورة',
      'subtitleEn': 'Faculty of Computer and Information Systems — CS Major',
      'subtitleAr': 'كلية الحاسبات والمعلومات — تخصص علوم الحاسب',
      'period': 'Undergraduate',
      'descriptionEn': 'Focusing on Computer Science foundations, Data Structures, Algorithms, Software Engineering, Database Systems, and Mobile App Development.',
      'descriptionAr': 'دراسة أساسيات علوم الحاسب، هياكل البيانات، الخوارزميات، هندسة البرمجيات، قواعد البيانات، وتطوير تطبيقات الجوال.',
      'icon': 'school',
    },
    {
      'typeEn': 'Intensive Professional Training',
      'typeAr': 'التدريب المهني المكثف',
      'titleEn': 'ITI — Information Technology Institute',
      'titleAr': 'معهد تكنولوجيا المعلومات — ITI',
      'subtitleEn': 'Flutter Mobile Application Development Specialization',
      'subtitleAr': 'تخصص تطوير تطبيقات الجوال باستخدام فلاتر (Flutter)',
      'period': 'Certified Intensive Training',
      'descriptionEn': 'Rigorous hands-on training in cross-platform mobile development with Flutter, Dart, Clean Architecture, State Management (BLoC/Cubit), REST APIs, Firebase, and Git workflows.',
      'descriptionAr': 'تدريب عملي مكثف على تطوير التطبيقات متعددة المنصات باستخدام Flutter، Dart، Clean Architecture، إدارة الحالة، ربط واجهات البرمجة، وFirebase.',
      'icon': 'workspace_premium',
    },
    {
      'typeEn': 'Technical Training',
      'typeAr': 'التدريب التقني المتخصص',
      'titleEn': 'NTI — National Telecommunication Institute',
      'titleAr': 'المعهد القومي للاتصالات — NTI',
      'subtitleEn': 'Mobile Application & Software Engineering Track',
      'subtitleAr': 'مسار تطوير تطبيقات الجوال وهندسة البرمجيات',
      'period': 'Certified Training',
      'descriptionEn': 'Specialized training covering modern mobile application patterns, API integrations, clean coding practices, and production readiness.',
      'descriptionAr': 'تدريب متخصص يغطي أنماط التطبيقات الحديثة، ربط واجهات البرمجة، كتابة كود نظيف قابل للصيانة، وإعداد التطبيقات للنشر.',
      'icon': 'badge',
    },
  ];
}
