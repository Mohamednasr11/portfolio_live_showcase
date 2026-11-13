class WebLink {
  const WebLink(this.label, this.url);

  final String label;
  final String url;
}

class CodeProject {
  const CodeProject({
    required this.name,
    required this.summary,
    required this.points,
    required this.stack,
    required this.links,
  });

  final String name;
  final String summary;
  final List<String> points;
  final List<String> stack;
  final List<WebLink> links;
}

class CaseStudyInfo {
  const CaseStudyInfo({
    required this.demoId,
    required this.previewStep,
    required this.source,
    this.links = const [],
  });

  final String demoId;

  /// The beat rendered in the card's live preview.
  final int previewStep;

  /// What exists outside this site, stated without embellishment.
  final String source;
  final List<WebLink> links;
}

class SkillGroup {
  const SkillGroup(this.title, this.skills, this.evidence);

  final String title;
  final List<String> skills;

  /// Where a reviewer can see the skill used.
  final String evidence;
}

class TimelineEntry {
  const TimelineEntry({
    required this.title,
    required this.place,
    required this.period,
    required this.points,
  });

  final String title;
  final String place;
  final String period;
  final List<String> points;
}

class Highlight {
  const Highlight(this.title, this.body);

  final String title;
  final String body;
}

abstract final class Profile {
  static const name = 'Mohamed Nasr Eldeen';
  static const role = 'Flutter Developer';
  static const intro =
      'Flutter developer and Computer Science & Information Systems student at '
      'Mansoura University. I build mobile apps with BLoC/Cubit state, Clean '
      'Architecture layers, local SQLite or Firebase data, and widget tests '
      'that keep layouts from breaking.';

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
      source: 'ITI final project. Source code and a web build are public.',
      links: [
        WebLink('Source code', matjarkomRepo),
        WebLink('Web build', matjarkomLive),
      ],
    ),
    CaseStudyInfo(
      demoId: 'build_guard',
      previewStep: 0,
      source: 'UX case study. No public repository is linked.',
    ),
    CaseStudyInfo(
      demoId: 'brew_and_bloom',
      previewStep: 1,
      source: 'UX case study. No public repository is linked.',
    ),
    CaseStudyInfo(
      demoId: 'trustsafe',
      previewStep: 1,
      source: 'UX case study. No public repository is linked.',
    ),
  ];

  static const codeProjects = [
    CodeProject(
      name: 'Matjarkom',
      summary:
          'E-commerce app with an AI shopping assistant, built as the ITI '
          'final project.',
      points: [
        'Shopping assistant chat backed by an n8n AI agent workflow.',
        'BLoC and HydratedCubit state with Clean Architecture layers.',
        'Firebase authentication and data, OpenStreetMap delivery map.',
      ],
      stack: ['Flutter', 'BLoC', 'HydratedCubit', 'Firebase', 'n8n', 'OSM'],
      links: [
        WebLink('Repository', matjarkomRepo),
        WebLink('Web build', matjarkomLive),
      ],
    ),
    CodeProject(
      name: 'Fitness Tracker',
      summary:
          'Offline-first workout logger with progress charts and a rule-based '
          'plan generator.',
      points: [
        'Clean Architecture + MVVM: presentation, domain and data layers.',
        'SQLite with three relational tables; no backend required.',
        'fl_chart progress charts, persisted dark/light theme.',
        'Cubit tests with bloc_test and mocktail.',
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
      summary: 'Meal catalog with full create, read, update and delete.',
      points: [
        'BLoC keeps the list in sync after every add or edit.',
        'SQFlite storage so entries survive restarts and work offline.',
        'GoRouter navigation passing data between list and detail.',
      ],
      stack: ['Flutter', 'BLoC', 'sqflite', 'GoRouter'],
      links: [
        WebLink('Repository', 'https://github.com/Mohamednasr11/meals_app'),
      ],
    ),
    CodeProject(
      name: 'Smart Route Finder',
      summary:
          'University AI course project comparing two search agents on a grid.',
      points: [
        'A* (utility-based) against Greedy Best-First (goal-based).',
        'Manhattan-distance heuristic, step-by-step visualisation.',
        'Reports explored nodes, path length and execution time.',
        'Includes a Snake game driven by a heuristic agent.',
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
      name: 'This portfolio',
      summary:
          'Flutter web site whose case studies are live widget trees, not '
          'screenshots.',
      points: [
        'Presentation engine with a scripted, testable timeline.',
        'Every beat of every case study is rendered in a widget test.',
        'Responsive from phone to desktop, deployed on Vercel.',
      ],
      stack: ['Flutter web', 'ChangeNotifier', 'flutter_test', 'Vercel'],
      links: [WebLink('Repository', sourceUrl)],
    ),
  ];

  static const skills = [
    SkillGroup('Core', [
      'Dart',
      'Flutter',
      'Flutter web',
      'Responsive layouts',
      'Animations',
    ], 'Every project on this page'),
    SkillGroup('State & architecture', [
      'BLoC',
      'Cubit',
      'HydratedCubit',
      'Clean Architecture',
      'MVVM',
      'get_it',
    ], 'Matjarkom, Fitness Tracker, Meals App'),
    SkillGroup('Data & integrations', [
      'Firebase',
      'SQLite / sqflite',
      'SharedPreferences',
      'n8n AI agent',
      'OpenStreetMap',
    ], 'Matjarkom, Fitness Tracker, Meals App'),
    SkillGroup('Navigation & UI', [
      'GoRouter',
      'Named routes',
      'fl_chart',
      'Custom painters',
      'RTL / Arabic UI',
    ], 'Meals App, Fitness Tracker, this portfolio'),
    SkillGroup('Testing & delivery', [
      'flutter_test',
      'bloc_test',
      'mocktail',
      'Git & GitHub',
      'Vercel',
    ], 'Fitness Tracker, this portfolio'),
    SkillGroup('Computer science', [
      'A* search',
      'Greedy best-first',
      'Heuristics',
      'Algorithm analysis',
    ], 'Smart Route Finder'),
  ];

  static const highlights = [
    Highlight(
      'Live widgets, not screenshots',
      'Each case study is a real Flutter widget tree inside a phone frame. '
          'The screens animate, re-layout and render Arabic text the way the '
          'app would.',
    ),
    Highlight(
      'A testable timeline',
      'A ChangeNotifier controller owns the project and beat indexes. Its '
          'timer is injected, so tests advance the tour without waiting on '
          'the wall clock.',
    ),
    Highlight(
      'Overflow is a failing test',
      'Every beat is pumped at phone and desktop sizes and any layout '
          'overflow fails the suite. A control test proves the gate fires.',
    ),
    Highlight(
      'One shell, four screen sizes',
      'The player swaps its side rail for a project strip and stacks its '
          'controls on narrow screens; tests cover 360 px to 1280 px wide.',
    ),
  ];

  static const experience = [
    TimelineEntry(
      title: 'Data Annotation & Customer/Sales Support Specialist',
      place: 'Soualy Company · Remote',
      period: 'Jul 2024 – Aug 2024',
      points: [
        'Reviewed and labelled structured data samples against project '
            'guidelines for machine-learning datasets.',
        'Handled remote customer conversations and follow-ups.',
      ],
    ),
  ];

  static const education = [
    TimelineEntry(
      title: 'B.Sc. Computer Science and Information Systems',
      place: 'Mansoura University',
      period: 'Expected Oct 2027',
      points: [
        'Relevant areas: software engineering, mobile development, database '
            'management.',
      ],
    ),
    TimelineEntry(
      title: 'Flutter training',
      place: 'ITI',
      period: 'Final project: Matjarkom',
      points: ['Built Matjarkom as the final project of the track.'],
    ),
    TimelineEntry(
      title: 'Digital Marketing Summer Training',
      place: 'ITIDA / NTI',
      period: 'Jun – Jul 2025',
      points: ['120 hours: 90 technical and 30 freelancing.'],
    ),
  ];
}
