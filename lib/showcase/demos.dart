import 'package:flutter/material.dart';

import '../demos/brew_bloom_demo.dart';
import '../demos/build_guard_demo.dart';
import '../demos/matjarkom_demo.dart';
import '../demos/trustsafe_demo.dart';
import 'model.dart';

/// The four live demos plus the beat sheet the presenter drives.
List<DemoSpec> buildDemos() => const [
      matjarkom,
      buildGuard,
      brewBloom,
      trustSafe,
    ];

Widget _matjarkom(BuildContext context, int step) => MatjarkomDemo(step: step);
Widget _buildGuard(BuildContext context, int step) => BuildGuardDemo(step: step);
Widget _brewBloom(BuildContext context, int step) => BrewBloomDemo(step: step);
Widget _trustSafe(BuildContext context, int step) => TrustSafeDemo(step: step);

const DemoSpec matjarkom = DemoSpec(
  id: 'matjarkom',
  name: 'Matjarkom',
  category: 'E-COMMERCE · MOBILE APP',
  role: 'Flutter · Firebase',
  accent: Color(0xFF6C5CE7),
  surface: Color(0xFF0A0A0C),
  stack: ['Flutter', 'Firebase', 'Google Maps', 'AI'],
  headline: 'تطبيق تسوق إلكتروني ذكي مدعوم بالذكاء الاصطناعي',
  subtitle: 'Smart E-Commerce with AI Assistant & Fast Checkout',
  pitch:
      'Arabic-first storefront with a phone-OTP login, cart flow and an AI '
      'assistant that can add items to the basket.',
  steps: [
    DemoStep(
      screen: 'splash',
      label: 'Splash',
      annotation: 'The wordmark pops in on the app’s own near-black field.',
      techNote: 'A single scaled image layer over a flat colour, so the first '
          'frames carry no layout work and stay smooth on a cold start.',
      speakerNote: 'I start with the thing interviewers check first — whether '
          'the first frames stay smooth while the app initialises.',
      hold: Duration(milliseconds: 2600),
    ),
    DemoStep(
      screen: 'login',
      label: 'OTP confirmation',
      annotation: 'Six digits land in the notched code field, one at a time.',
      techNote: 'Firebase Auth phone verification: the verification id is held '
          'in state, auto-retrieval fills the code, errors surface as a retry '
          'state instead of a dead screen.',
      speakerNote: 'Auth is the riskiest part of any e-commerce app, so the '
          'error branch is designed, not bolted on.',
      hold: Duration(milliseconds: 3600),
    ),
    DemoStep(
      screen: 'home',
      label: 'Home',
      annotation: 'RTL grid, auto-driving hero carousel, circular categories.',
      techNote: 'Full Directionality.rtl support, PageView with a programmatic '
          'timer, and horizontal lists that recycle their children.',
      speakerNote: 'Everything here mirrors right-to-left, including the '
          'carousel direction and the badge placement.',
      hold: Duration(milliseconds: 4200),
    ),
    DemoStep(
      screen: 'category',
      label: 'Category grid',
      annotation: 'Furniture cards rise in on a per-index stagger.',
      techNote: 'Filter chips drive a query; the grid rebuilds with a per-index '
          'delay so the change reads as motion instead of a flicker.',
      speakerNote: 'Small detail: the stagger delay is derived from the index, '
          'so a longer list never blocks the first card.',
      hold: Duration(milliseconds: 3200),
    ),
    DemoStep(
      screen: 'detail',
      label: 'Added to cart',
      annotation: 'The confirmation sheet slides up over the grid, as mocked.',
      techNote: 'The cart badge, this sheet and the checkout total all read one '
          'state object, so they cannot disagree after a tap.',
      speakerNote: 'This is where I would talk about state management: one '
          'source of truth, everything else derived.',
      hold: Duration(milliseconds: 3400),
    ),
    DemoStep(
      screen: 'cart',
      label: 'My orders',
      annotation: 'Line item with stepper, plus a running total that counts up.',
      techNote: 'The total is a CountUp over a computed value, so editing a '
          'quantity re-animates the same code path a real user would hit.',
      speakerNote: 'Currency is formatted in one place, which matters once you '
          'support both EGP and USD.',
    ),
    DemoStep(
      screen: 'payment',
      label: 'Confirm order',
      annotation: 'Card selection flips live under the saved delivery address.',
      techNote: 'Payment method is a single-select state and the ETA plus total '
          'are derived from the same order object, not typed into the widget.',
      speakerNote: 'The screen looks static in a mockup; here the selection is '
          'actually a state change with the price re-derived behind it.',
      hold: Duration(milliseconds: 4200),
    ),
    DemoStep(
      screen: 'success',
      label: 'Order confirmed',
      annotation: 'Check disc pops inside its halo, then the return action.',
      techNote: 'Confirmation screen reads the order back from the write, which '
          'is also the retry path if the response is slow.',
      speakerNote: 'If the user kills the app here, the order still exists — '
          'that is the point of the write-then-render shape.',
    ),
    DemoStep(
      screen: 'chat',
      label: 'AI assistant',
      annotation: 'Bubbles land one by one with a typing indicator.',
      techNote: 'Streaming responses rendered as they arrive; the assistant can '
          'emit an add-to-cart intent, not just text.',
      speakerNote: 'The interesting part is not the chat — it is that the bot '
          'can act on the cart, so it needs the same state as the UI.',
      hold: Duration(milliseconds: 4600),
    ),
  ],
  builder: _matjarkom,
);

const DemoSpec buildGuard = DemoSpec(
  id: 'build_guard',
  name: 'Build-Guard',
  category: 'CONSTRUCTION · SAFETY',
  role: 'Flutter · AI vision',
  accent: Color(0xFFF5821F),
  surface: Color(0xFFEDEEF0),
  stack: ['Flutter', 'AI', 'Firebase'],
  headline: 'إدارة وإرشادات السلامة في مواقع البناء بالذكاء الاصطناعي',
  subtitle: 'Real-time AI Site Safety Monitoring & Incident Reports',
  pitch:
      'Point the camera at a concrete surface, get a defect segmentation and a '
      'risk score with a repair plan attached.',
  steps: [
    DemoStep(
      screen: 'home',
      label: 'Site dashboard',
      annotation: 'Structural health score with open issues and recent scans.',
      techNote: 'Aggregated site state on one screen; the health bar animates '
          'from a value the backend computed, not a hard-coded width.',
      speakerNote: 'Site managers open this first, so the score has to be '
          'readable at a glance from across a room.',
      hold: Duration(milliseconds: 3800),
    ),
    DemoStep(
      screen: 'scan',
      label: 'Camera scan',
      annotation: 'AI VISION: ACTIVE, lighting check, sweeping orange frame.',
      techNote: 'Overlay painted with CustomPainter on top of the preview: '
          'corner brackets, scan line and a live lighting confidence label.',
      speakerNote: 'The scan line is a repeating controller — cheap, and it '
          'tells the user the model is listening.',
      hold: Duration(milliseconds: 4200),
    ),
    DemoStep(
      screen: 'capture',
      label: 'Shutter',
      annotation: 'White flash decays into the frozen frame.',
      techNote: 'One-shot animation that hands off to the inference call, so '
          'the user never sees a spinner appear from nowhere.',
      speakerNote: 'Feedback and the actual request start on the same tap.',
      hold: Duration(milliseconds: 2200),
    ),
    DemoStep(
      screen: 'analyzing',
      label: 'Inference',
      annotation: 'Ring percentage plus the four phases of the pipeline.',
      techNote: 'Phase list is driven by real progress events, so the UI can '
          'never claim a step it did not receive.',
      speakerNote: 'This is where I keep the work off the UI isolate — the '
          'screen stays at full frame rate while inference runs.',
      hold: Duration(milliseconds: 4200),
    ),
    DemoStep(
      screen: 'result',
      label: 'Risk verdict',
      annotation: 'Gauge needle sweeps to 92/100 · High Risk.',
      techNote: 'Hand-painted half-circle gauge: banded arc, tick marks, and a '
          'needle eased in over 1.4s so the number lands before the label.',
      speakerNote: 'The gauge is fully drawn — no image asset, so it scales on '
          'a tablet without going soft.',
      hold: Duration(milliseconds: 4600),
    ),
    DemoStep(
      screen: 'analysis',
      label: 'Defect breakdown',
      annotation: 'Detection boxes appear one at a time over the frame.',
      techNote: 'Each box is confidence-scored geometry mapped from model '
          'output to widget space, with the reasoning written out below.',
      speakerNote: 'Explainability was the client ask: an engineer needs to see '
          'why a wall scored high, not just the score.',
      hold: Duration(milliseconds: 4200),
    ),
    DemoStep(
      screen: 'repair',
      label: 'Repair plan',
      annotation: 'Ordered steps, then route to a verified provider.',
      techNote: 'The plan is generated from the defect list, and the last step '
          'is a re-scan — closing the loop back to the dashboard.',
      speakerNote: 'That closes the product loop: scan, score, fix, re-scan.',
      hold: Duration(milliseconds: 3800),
    ),
  ],
  builder: _buildGuard,
);

const DemoSpec brewBloom = DemoSpec(
  id: 'brew_and_bloom',
  name: 'Brew & Bloom',
  category: 'HOSPITALITY · ORDERING',
  role: 'Flutter · UI/UX',
  accent: Color(0xFFC08552),
  surface: Color(0xFFF7F3EF),
  stack: ['Flutter', 'UI / UX', 'Dart'],
  headline: 'تجربة طلب القهوة الفاخرة والمكافآت',
  subtitle: 'Premium Coffee Ordering & Artisanal Brew Selection',
  pitch:
      'Specialty coffee ordering where the brew customisation actually changes '
      'the price, and loyalty points are spendable in the cart.',
  steps: [
    DemoStep(
      screen: 'onboarding',
      label: 'Onboarding',
      annotation: 'Copy rises in with the page indicator.',
      techNote: 'Three-page intro built on a PageView with shared transitions, '
          'kept in the same theme as the app.',
      speakerNote: 'First screen sets the type scale for everything after it.',
      hold: Duration(milliseconds: 3200),
    ),
    DemoStep(
      screen: 'home',
      label: 'Menu home',
      annotation: 'Dark header dissolving into a cream sheet, promo card, chips.',
      techNote: 'Two-tone layout with a rounded sheet overlapping the header, '
          'and horizontally scrolling category chips.',
      speakerNote: 'The contrast between the header and the menu is deliberate '
          '— it makes the product photos the loudest thing on screen.',
      hold: Duration(milliseconds: 4200),
    ),
    DemoStep(
      screen: 'detail',
      label: 'Build the cup',
      annotation: 'Size and shot selectors cycle; the price follows.',
      techNote: 'Options are a priced model, so the total recomputes from the '
          'selection rather than from a static label.',
      speakerNote: 'This is the core interaction of the app, and it is fully '
          'live: change a shot, watch the price move.',
      hold: Duration(milliseconds: 4600),
    ),
    DemoStep(
      screen: 'order',
      label: 'Order summary',
      annotation: 'Line items, loyalty points applied, total counts up.',
      techNote: 'Redeeming points is a line in the same pricing pass, which '
          'keeps discounts and totals consistent.',
      speakerNote: 'Loyalty is applied in the cart rather than at the terminal, '
          'so the user sees the real number before committing.',
      hold: Duration(milliseconds: 3800),
    ),
    DemoStep(
      screen: 'tracking',
      label: 'Live delivery',
      annotation: 'Courier dot walks the route across a drawn map.',
      techNote: 'Static map chrome painted once; the route progress and marker '
          'are the only things repainting each frame.',
      speakerNote: 'Cheap trick worth knowing: paint the parts that never '
          'change once, and animate only the overlay.',
      hold: Duration(milliseconds: 4600),
    ),
    DemoStep(
      screen: 'rewards',
      label: 'Loyalty club',
      annotation: 'Balance counts up, tier bar fills, locked rows dim.',
      techNote: 'Tier progress and reward availability are derived from the '
          'same balance value.',
      speakerNote: 'The five screens before this one are the client’s '
          'mockups; this one is not — it is built from the same design system '
          'to close the loop: order, earn, redeem.',
      hold: Duration(milliseconds: 3800),
    ),
  ],
  builder: _brewBloom,
);

const DemoSpec trustSafe = DemoSpec(
  id: 'trustsafe',
  name: 'TrustSafe',
  category: 'ENTERPRISE · DOCUMENT MANAGEMENT',
  role: 'Flutter · Security',
  accent: Color(0xFFA0562C),
  surface: Color(0xFFF7EFE7),
  stack: ['Flutter', 'Enterprise', 'Security'],
  headline: 'إدارة وثائق المؤسسات بأعلى معايير الأمان',
  subtitle: 'Secure Enterprise Document Management & Workflows',
  pitch:
      'A family document vault where every permission grant is explicit and '
      'the files stay shut until the device itself says yes.',
  steps: [
    DemoStep(
      screen: 'splash',
      label: 'Splash',
      annotation: 'Brand mark over the login form on a cream field.',
      techNote: 'Brand-first entry; the unlock check runs behind this screen '
          'so a returning user never sees a blank frame.',
      speakerNote: 'For an enterprise product the entry has to feel calm — '
          'cream, heavy sans, no motion theatre.',
      hold: Duration(milliseconds: 3000),
    ),
    DemoStep(
      screen: 'vault',
      label: 'Document vault',
      annotation: 'Each row carries its own state: Locked, Shared, Draft.',
      techNote: 'List rows render their state badge from the document record, '
          'so a shared file cannot look private.',
      speakerNote: 'State has to be visible on the list, otherwise people '
          'assume everything is locked.',
      hold: Duration(milliseconds: 3600),
    ),
    DemoStep(
      screen: 'upload',
      label: 'Add document',
      annotation: 'Type selects itself, then the file encrypts.',
      techNote: 'Upload is a staged state machine — select, encrypt, store — '
          'and the save action stays disabled until the last stage lands.',
      speakerNote: 'The interesting constraint here is that nothing is writable '
          'until encryption succeeds.',
      hold: Duration(milliseconds: 5200),
    ),
    DemoStep(
      screen: 'access',
      label: 'Grant access',
      annotation: 'Permissions flip on one at a time.',
      techNote: 'Three distinct grants, each with its own consequence, and '
          'transferring on death is opt-in rather than a default.',
      speakerNote: 'Granular consent is the product thesis — the toggle is the '
          'whole point of the app.',
      hold: Duration(milliseconds: 4200),
    ),
    DemoStep(
      screen: 'unlock',
      label: 'Biometric unlock',
      annotation: 'Being signed in is not the same as being allowed in.',
      techNote: 'The vault stays empty until the platform reports a successful '
          'unlock, so device trust is an auth factor and not a stored flag.',
      speakerNote: 'This is the screen between "logged in" and "allowed to '
          'read the file", and it is the one most apps skip.',
      hold: Duration(milliseconds: 3600),
    ),
    DemoStep(
      screen: 'settings',
      label: 'Security settings',
      annotation: 'Biometric login flips on by itself.',
      techNote: 'Device trust is a real unlock factor; enabling it changes the '
          'auth path, not just a stored flag.',
      speakerNote: 'And that is the last beat — the account is only as secure '
          'as the weakest unlock.',
      hold: Duration(milliseconds: 3600),
    ),
  ],
  builder: _trustSafe,
);
