# Workspace inventory and portfolio roadmap

[VERIFIED] Discovery snapshot: 2026-11-13. The table records previously inspected Flutter projects on D:. All 17 listed pubspec paths were subsequently checked to exist. There are 16 distinct project/reference folders plus one ITI worktree, not 17 independent apps.

[UNVERIFIED] Except for `portfolio_live_showcase`, the builds, test outcomes, backend connections and completeness of these projects were not validated in this session. Dependency declarations and source/test-file counts do not prove functionality. No other app was modified.

## Inventory

[VERIFIED] Stack observations below are the discovery snapshot, not a production-readiness assessment. Each source is the corresponding local `pubspec.yaml` and previously inspected source tree.

| Project / source | Observed stack and state | Assessment / live status |
| --- | --- | --- |
| `D:/portfolio_live_showcase/pubspec.yaml` | Flutter web, ChangeNotifier, url_launcher | [VERIFIED] New landing page and responsive player locally tested; existing production reachable, new release unpublished |
| `D:/portfolio_flutter_ref/pubspec.yaml` | Flutter, url_launcher | [VERIFIED] Existing portfolio reference; [UNVERIFIED] live/build status |
| `D:/fitness/pubspec.yaml` | BLoC, get_it, Dio, Firebase Auth, Hive/SQLite, fl_chart; Clean Architecture | [VERIFIED] Substantial fitness app with test files; [UNVERIFIED] current tests, completeness and live build |
| `D:/flutter_task_1_iti/pubspec.yaml` | BLoC/Hydrated BLoC, Dio, Firebase, Paymob, maps | [VERIFIED] Matjarkom capstone source; [UNVERIFIED] local backend/build; linked public web showcase reachable |
| `D:/flutter_task_1_iti.worktrees/index-html-view-update/pubspec.yaml` | Same ITI project dependency family | [VERIFIED] Worktree, not another independent project; [UNVERIFIED] its build/live state |
| `D:/movies_app/pubspec.yaml` | BLoC, get_it, dartz, Dio; Clean Architecture | [VERIFIED] TMDb tutorial source; [UNVERIFIED] test outcomes/live build |
| `D:/movies-master/pubspec.yaml` | Movie tutorial dependency family | [VERIFIED] Previously observed leftover copy with empty `lib/`; [UNVERIFIED] usable app/live build |
| `D:/yalla_go_app/pubspec.yaml` | BLoC with some Riverpod, Dio/Retrofit, GraphQL, Firebase/FCM, Hive CE | [VERIFIED] Large customer/admin commerce source; [UNVERIFIED] end-to-end readiness/live build |
| `D:/شغل/yalla-go/pubspec.yaml` | BLoC, GoRouter, Dio, fpdart, Firebase, Hive CE | [VERIFIED] Passenger-transport WIP source; [NEEDS MY DECISION] confidentiality clearance before public showcase |
| `D:/procrument_approval_system/pubspec.yaml` | BLoC, get_it, GoRouter, Drift/SQLite; Supabase declared | [VERIFIED] Approval workflow source and tests; [UNVERIFIED] Supabase usage, test results/live build |
| `D:/task_it_legend/pubspec.yaml` | BLoC, limited Provider, SQLite, GoRouter, get_it | [VERIFIED] Classifieds/hiring task source; [UNVERIFIED] public repository access and live build |
| `D:/ibm_tasks/pubspec.yaml` | Flutter defaults | [VERIFIED] Navigation/registration exercise; [UNVERIFIED] current build/live state |
| `D:/iti_practice/pubspec.yaml` | HTTP, SQLite, SharedPreferences; layered structure | [VERIFIED] Product-list practice source; [UNVERIFIED] live/build state |
| `D:/flutter_practice/pubspec.yaml` | Provider | [VERIFIED] Stepper/singleton exercises; [UNVERIFIED] live/build state |
| `D:/responosive_design/pubspec.yaml` | responsive_zoom, adaptive layouts | [VERIFIED] Responsive exercise and test files; [UNVERIFIED] current test outcomes/live build |
| `D:/tests/pubspec.yaml` | Riverpod, Dio | [VERIFIED] Support-chat/profile sandbox; [UNVERIFIED] build/live state |
| `D:/AndroidDev/hi/pubspec.yaml` | image_picker | [VERIFIED] Single-file scratch source; [UNVERIFIED] build/live state |

## Public projects selected for the landing page

[VERIFIED] Links below returned HTTP 200 during discovery (the ITI repository redirects from the old account). Evidence: `lib/portfolio/profile_data.dart:120`, the URL allowlist in `test/portfolio_test.dart:16`, and the browser-rendered anchors.

| Project | Public repository | Live demonstration | Verification boundary |
| --- | --- | --- | --- |
| Matjarkom | https://github.com/Mo-Nasr-Eldeen/ITI-Final-Project | https://iti-final-project-w77f.vercel.app/ | [VERIFIED] Reachability and README inspected; [UNVERIFIED] authenticated backend/payment/AI flows |
| Fitness Tracker | https://github.com/Mohamednasr11/code_alpha_fitness_tracker_app | — | [VERIFIED] README describes offline logging, charts and rule-based plans; [UNVERIFIED] repository execution in this session |
| Meals App | https://github.com/Mohamednasr11/meals_app | — | [VERIFIED] README describes BLoC, SQFlite CRUD and GoRouter; [UNVERIFIED] execution in this session |
| Smart Route Finder | https://github.com/Mohamednasr11/smart_route_finder | — | [VERIFIED] README describes A* / Greedy Best-First comparison; [UNVERIFIED] execution in this session |
| This portfolio | https://github.com/Mohamednasr11/portfolio_live_showcase | https://portfolioliveshowcase.vercel.app/ | [VERIFIED] Local new release passed analysis, 87 tests and browser checks; [UNVERIFIED] new version on production |

[VERIFIED] No APKs were produced in this session. Missing live links are left absent rather than guessed.

## Case-study honesty

[VERIFIED] All four browser case studies use live Flutter widgets with simulated data and device/network features. Evidence: `lib/portfolio/portfolio_page.dart:632`, `lib/showcase/shell.dart:665`.

[UNVERIFIED] Build-Guard, Brew & Bloom and TrustSafe have no verified public app repositories or live backends; they are labelled UX case studies and simulated flows, not delivered production applications.

[VERIFIED] Current desktop/mobile visual previews are in `docs/screenshots/`; they capture this portfolio, not independently running original apps.

## Prioritised roadmap

[VERIFIED] Completed locally, highest priority: retain the working player, fix responsive controls and add the developer landing page. Evidence: `lib/showcase/shell.dart:105`, `test/responsive_shell_test.dart`, `lib/portfolio/portfolio_page.dart:86`.

[VERIFIED] Completed locally, delivery gate: disclosure and URL checks, route ownership/disposal, clipboard feedback, contrast checks, metadata/loading fallback, MN icons, real screenshots and release build. Evidence: `test/portfolio_test.dart`, `web/index.html`, `tool/vercel_build.sh`.

[NEEDS MY DECISION] Next: authorise feature-branch push, review PR, Vercel preview and then production promotion. Verify the returned live URL before claiming deployment success.

[UNVERIFIED] Cloud bootstrap of the pinned Flutter SDK is prepared but has not run in Vercel; cloud limits and build duration remain unknown.

[ASSUMPTION] Highest-value next app work is Fitness Tracker and Matjarkom: validate their real flows, repair Fitness README screenshot paths, add Matjarkom tests and prepare verified recordings/APKs. This ordering is based on source breadth and public accessibility, not measured usage.

[ASSUMPTION] Procurement approval and larger Yalla Go projects may provide strong architecture examples after their builds/backends and publication rights are verified.

[NEEDS MY DECISION] Confirm the preferred contact email, the CV's expected graduation date and the exact ITI training details. No years-of-experience claims, fabricated percentages, testimonials or performance metrics were added.
