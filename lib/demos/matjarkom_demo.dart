import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../showcase/kit.dart';

/// Matjarkom, rebuilt screen by screen from the owner's own mockups in
/// `D:\portfolio_flutter_ref\assets\متجركم\`. Colours are sampled from those
/// PNGs and the widget order reproduces their RTL positions; nothing here is a
/// new design decision.
///
/// splash -> dark_splash.png   login   -> dark_code.png
/// home   -> dark_home.png     category-> dark_category.png
/// detail -> dark_add_to_cart.png  cart -> dark_payment_screen.png
/// payment-> dark_confirm_pay.png  success -> dark_success_pay.png
/// chat   -> dark_chat_bot_ai.png
class MatjarkomDemo extends StatefulWidget {
  const MatjarkomDemo({super.key, required this.step});

  final int step;

  static const Color bg = Color(0xFF121212);
  static const Color splashBg = Color(0xFF070C10);
  static const Color surface = Color(0xFF1E1E1E);
  static const Color tile = Color(0xFF2C2C2C);
  static const Color chip = Color(0xFF353535);
  static const Color accent = Color(0xFF6B67FF);
  static const Color muted = Color(0xFF8E8E93);
  static const Color soft = Color(0xFFBDBDBD);
  static const Color pink = Color(0xFFEFB4C9);
  static const Color danger = Color(0xFFFF4D4D);
  static const Color green = Color(0xFF27AE60);
  static const Color chatBg = Color(0xFF0B141A);
  static const Color chatBubble = Color(0xFF1F2C34);

  static const List<String> _screens = [
    'splash',
    'login',
    'home',
    'category',
    'detail',
    'cart',
    'payment',
    'success',
    'chat',
  ];

  @override
  State<MatjarkomDemo> createState() => _MatjarkomDemoState();
}

class _MatjarkomDemoState extends State<MatjarkomDemo> {
  late final PageController _hero =
      PageController(viewportFraction: 0.88, initialPage: 1);
  Timer? _heroTimer;
  int _heroPage = 1;

  @override
  void initState() {
    super.initState();
    _heroTimer = Timer.periodic(const Duration(milliseconds: 2600), (_) {
      // The beat cross-fade keeps two screens mounted at once and both build a
      // PageView on this controller, so animateToPage's own `position` read
      // asserts "attached to multiple scroll views". Only drive the carousel
      // while exactly one view holds it.
      if (!mounted || _hero.positions.length != 1) return;
      setState(() => _heroPage = (_heroPage + 1) % 3);
      _hero.animateToPage(
        _heroPage,
        duration: const Duration(milliseconds: 620),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _heroTimer?.cancel();
    _hero.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screen = MatjarkomDemo._screens[widget.step];

    return AppScreen(
      background: switch (screen) {
        'chat' => MatjarkomDemo.chatBg,
        'splash' => MatjarkomDemo.splashBg,
        _ => MatjarkomDemo.bg,
      },
      rtl: true,
      child: LiveScreenStack(
        screenKey: screen,
        child: switch (screen) {
          'splash' => const _Splash(),
          'login' => const _OtpConfirm(),
          'home' => _Home(hero: _hero, heroPage: _heroPage),
          'category' => const _Category(),
          'detail' => const _AddedToCart(),
          'cart' => const _Orders(),
          'payment' => const _ConfirmOrder(),
          'success' => const _Success(),
          _ => const _Chat(),
        },
      ),
    );
  }
}

/// Product imagery cut out of the owner's mockups. The error builder keeps the
/// box measurable in widget tests, where the asset bundle is empty.
class _Shot extends StatelessWidget {
  const _Shot(this.name, {this.fit = BoxFit.cover, this.icon});

  final String name;
  final BoxFit fit;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => Image.asset(
        'assets/matjarkom/$name.png',
        fit: fit,
        errorBuilder: (context, _, _) => FakeImage(
          size: const Size(double.infinity, double.infinity),
          from: MatjarkomDemo.tile,
          to: MatjarkomDemo.surface,
          radius: 0,
          icon: icon ?? Icons.shopping_bag_rounded,
          iconColor: Colors.white24,
        ),
      );
}

/// The mockups always place the leading glyph to the right of the label, which
/// is the natural first-child position in an RTL row.
class _Cta extends StatelessWidget {
  const _Cta(this.label, {this.icon});

  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        height: 58,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: MatjarkomDemo.accent,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 21, color: Colors.white),
              const SizedBox(width: 12),
            ],
            Flexible(
              child: Txt(label,
                  size: 15.5, weight: FontWeight.w800, color: Colors.white,
                  maxLines: 1),
            ),
          ],
        ),
      );
}

class _BackChevron extends StatelessWidget {
  const _BackChevron();

  @override
  Widget build(BuildContext context) => const Icon(Icons.chevron_right_rounded,
      size: 26, color: Colors.white);
}

// ---------------------------------------------------------------- splash ----

class _Splash extends StatelessWidget {
  const _Splash();

  @override
  Widget build(BuildContext context) => Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.72, end: 1),
          duration: const Duration(milliseconds: 1100),
          curve: Curves.easeOutBack,
          builder: (context, v, child) => Opacity(
            // easeOutBack overshoots past 1.0; only the mark may pop.
            opacity: (v * 1.1).clamp(0.0, 1.0),
            child: Transform.scale(scale: v, child: child),
          ),
          child: SizedBox(
            width: 168,
            height: 91,
            child: _Shot('logo', fit: BoxFit.contain,
                icon: Icons.storefront_rounded),
          ),
        ),
      );
}

// ------------------------------------------------------------------ otp -----

class _OtpConfirm extends StatelessWidget {
  const _OtpConfirm();

  @override
  Widget build(BuildContext context) => ScreenBody(
        body: [
          const Row(children: [_BackChevron(), Spacer()]),
          const SizedBox(height: 60),
          Center(
            child: Container(
              width: 116,
              height: 116,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: MatjarkomDemo.surface,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.mark_email_read_rounded,
                  size: 46, color: MatjarkomDemo.accent),
            ),
          ),
          const SizedBox(height: 28),
          const Center(
            child: Txt('تأكيد الهاتف',
                size: 25, weight: FontWeight.w800, maxLines: 1),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Txt('أدخل الكود المكون من 6 أرقام المرسل لـهاتفك',
                size: 13, color: MatjarkomDemo.muted, height: 1.6),
          ),
          const SizedBox(height: 40),
          const _OtpField(),
        ],
        footer: const _Cta('تأكيد ودخول'),
      );
}

class _OtpField extends StatelessWidget {
  const _OtpField();

  @override
  Widget build(BuildContext context) => Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFF2C2C34)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock_outline_rounded, size: 21, color: MatjarkomDemo.soft),
                SizedBox(width: 20),
                TypeOn(
                  '123456',
                  playKey: 'otp',
                  startDelay: Duration(milliseconds: 500),
                  speedPerChar: Duration(milliseconds: 220),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 3,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 26,
            child: Container(
              color: MatjarkomDemo.bg,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: const Txt('OTP Code', size: 11, color: MatjarkomDemo.muted),
            ),
          ),
        ],
      );
}

// ------------------------------------------------------------------ home ----

class _Home extends StatelessWidget {
  const _Home({required this.hero, required this.heroPage});

  final PageController hero;
  final int heroPage;

  static const _cats = [
    ('cat_beauty', 'Beauty'),
    ('cat_fragrances', 'Fragrances'),
    ('cat_furniture', 'Furniture'),
    ('cat_groceries', 'Groceries'),
    ('cat_furniture', 'Decor'),
  ];

  @override
  Widget build(BuildContext context) {
    return ScreenBody(
      body: [
        Row(
          children: [
            const ClipOval(
              child: SizedBox(
                width: 42,
                height: 42,
                child: _Shot('avatar', icon: Icons.person_rounded),
              ),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Txt('أهلاً', size: 11, color: MatjarkomDemo.muted),
                Txt('Reham', size: 18, weight: FontWeight.w800),
              ],
            ),
            const Spacer(),
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  color: MatjarkomDemo.surface, shape: BoxShape.circle),
              child: const Icon(Icons.auto_awesome_rounded,
                  size: 19, color: MatjarkomDemo.accent),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Row(
          children: [
            _OrdersPill(),
            Spacer(),
          ],
        ),
        const SizedBox(height: 18),
        Surface(
          height: 56,
          radius: 22,
          color: MatjarkomDemo.surface,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: const Row(
            children: [
              Txt('بحث', size: 13.5, color: MatjarkomDemo.muted),
              SizedBox(width: 14),
              Icon(Icons.search_rounded, size: 20, color: MatjarkomDemo.soft),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 172,
          child: PageView(
            controller: hero,
            children: const [
              _HeroCard(
                title: 'شحن مجاني',
                sub: 'الطلبات فوق 300 ج',
                a: Color(0xFF9BD7F0),
                b: Color(0xFF6FBEE0),
                icon: Icons.local_shipping_rounded,
              ),
              _HeroCard(
                title: 'SUMMER SALE\nUP TO 50%',
                sub: '',
                a: Color(0xFFF0BDD0),
                b: Color(0xFFE7A6BE),
                shot: 'hero_watch',
              ),
              _HeroCard(
                title: 'العطور الجديدة',
                sub: 'مجموعة الصيف',
                a: Color(0xFFD9A6E0),
                b: Color(0xFFBE7EC9),
                icon: Icons.spa_rounded,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < 3; i++)
              AnimatedContainer(
                duration: const Duration(milliseconds: 320),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: i == heroPage ? 22 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: i == heroPage
                      ? MatjarkomDemo.pink
                      : const Color(0xFF2C2C34),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
          ],
        ),
        const SizedBox(height: 22),
        const Row(
          children: [
            Txt('الأقسام', size: 17, weight: FontWeight.w800),
            Spacer(),
            Txt('عرض الكل', size: 12.5, color: Color(0xFFE0E0E0)),
          ],
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 88,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              for (final c in _cats)
                Padding(
                  padding: const EdgeInsets.only(left: 18),
                  child: Column(
                    children: [
                      ClipOval(
                        child: SizedBox(
                          width: 62,
                          height: 62,
                          child: _Shot(c.$1, icon: Icons.category_rounded),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Txt(c.$2,
                          size: 11, weight: FontWeight.w700, maxLines: 1),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Txt('اخترنا لك', size: 17, weight: FontWeight.w800),
        const SizedBox(height: 14),
        const _Filters(),
        const SizedBox(height: 20),
        const _ProductRow(
          items: [
            ('prod_palette', 'Eyeshadow Palette with Mirror', 19.99, 0),
            ('prod_mascara', 'Essence Mascara Lash Princess', 9.99, 1),
          ],
        ),
        const SizedBox(height: 14),
        const _ProductRow(
          items: [
            ('prod_lipstick', 'Ruby Lipstick Matte', 14.50, 2),
            ('prod_powder', 'Loose Setting Powder', 22.00, 3),
          ],
        ),
      ],
      footer: const _TabBar(active: 0),
    );
  }
}

class _OrdersPill extends StatelessWidget {
  const _OrdersPill();

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1925),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: MatjarkomDemo.accent.withValues(alpha: .45)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Txt('طلباتك', size: 13, weight: FontWeight.w700),
            SizedBox(width: 14),
            _Badge(count: 1),
          ],
        ),
      );
}

class _Badge extends StatelessWidget {
  const _Badge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) => Stack(
        clipBehavior: Clip.none,
        children: [
          const Icon(Icons.shopping_cart_rounded,
              size: 20, color: MatjarkomDemo.accent),
          Positioned(
            top: -6,
            right: -7,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.3, end: 1),
              duration: const Duration(milliseconds: 520),
              curve: Curves.easeOutBack,
              builder: (context, v, child) => Opacity(
                opacity: v.clamp(0.0, 1.0),
                child: Transform.scale(scale: v, child: child),
              ),
              child: Container(
                width: 18,
                height: 18,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    color: Color(0xFFFF5A5F), shape: BoxShape.circle),
                child: Txt('$count',
                    size: 10, weight: FontWeight.w800, color: Colors.white),
              ),
            ),
          ),
        ],
      );
}

class _Filters extends StatelessWidget {
  const _Filters();

  @override
  Widget build(BuildContext context) => const Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          _FilterPill('الكل', selected: true),
          _FilterPill('شائع'),
          _FilterPill('الأحدث'),
          _FilterPill('الأكثر مبيعاً'),
        ],
      );
}

class _FilterPill extends StatelessWidget {
  const _FilterPill(this.label, {this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
        decoration: BoxDecoration(
          color: selected ? MatjarkomDemo.accent : MatjarkomDemo.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Txt(label,
            size: 13,
            weight: FontWeight.w700,
            color: selected ? Colors.white : MatjarkomDemo.soft),
      );
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.title,
    required this.sub,
    required this.a,
    required this.b,
    this.icon,
    this.shot,
  });

  final String title;
  final String sub;
  final Color a;
  final Color b;
  final IconData? icon;
  final String? shot;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(left: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [a, b],
          ),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Txt(title,
                      size: 15,
                      weight: FontWeight.w800,
                      color: Colors.black87,
                      height: 1.3),
                  if (sub.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Txt(sub, size: 11.5, color: Colors.black54, maxLines: 1),
                  ],
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Txt('اشترِ الآن',
                        size: 11,
                        weight: FontWeight.w800,
                        color: Color(0xFFE08BA8),
                        maxLines: 1),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 76,
              height: 68,
              child: shot == null
                  ? Icon(icon, size: 44, color: Colors.black26)
                  : _Shot(shot!, fit: BoxFit.contain),
            ),
          ],
        ),
      );
}

class _ProductRow extends StatelessWidget {
  const _ProductRow({required this.items});

  /// (asset, name, price, stagger index)
  final List<(String, String, double, int)> items;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            Expanded(
              child: _ProductCard(
                shot: items[i].$1,
                name: items[i].$2,
                price: items[i].$3,
                index: items[i].$4,
              ),
            ),
            if (i != items.length - 1) const SizedBox(width: 12),
          ],
        ],
      );
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.shot,
    required this.name,
    required this.price,
    required this.index,
  });

  final String shot;
  final String name;
  final double price;
  final int index;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: Duration(milliseconds: 320 + index * 110),
        curve: Curves.easeOutCubic,
        builder: (context, v, child) => Opacity(
          opacity: v,
          child:
              Transform.translate(offset: Offset(0, 16 * (1 - v)), child: child),
        ),
        child: Container(
          height: 252,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: MatjarkomDemo.surface,
            borderRadius: BorderRadius.circular(26),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  height: 128,
                  width: double.infinity,
                  child: _Shot(shot),
                ),
              ),
              const SizedBox(height: 12),
              Txt(name, size: 12.5, weight: FontWeight.w700, maxLines: 1),
              const SizedBox(height: 4),
              const Txt('إلكترونيات', size: 11, color: MatjarkomDemo.muted),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Flexible without a Spacer: a Spacer is Expanded, and two
                  // flex children split the row, which clipped "$19.99" to "$9".
                  // The 262px content box is narrower than the mockup's 375pt,
                  // so scaleDown keeps "$2499.99" whole instead of ellipsising.
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: AlignmentDirectional.centerStart,
                      child: Txt('\$${price.toStringAsFixed(2)}',
                          size: 14.5, weight: FontWeight.w800, maxLines: 1),
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        color: MatjarkomDemo.chip, shape: BoxShape.circle),
                    child: const Icon(Icons.favorite_border_rounded,
                        size: 16, color: MatjarkomDemo.soft),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}

class _TabBar extends StatelessWidget {
  const _TabBar({required this.active});

  final int active;

  static const _items = [
    (Icons.home_rounded, 'الرئيسية'),
    (Icons.shopping_cart_checkout_rounded, 'السلة'),
    (Icons.favorite_rounded, 'المفضلة'),
    (Icons.person_rounded, 'الحساب'),
  ];

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        decoration: BoxDecoration(
          color: MatjarkomDemo.surface,
          borderRadius: BorderRadius.circular(28),
        ),
        // The bar has to survive a 262px screen with the Ahem test font, so the
        // row is measured at its natural width and scaled down instead of
        // being allowed to overflow.
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < _items.length; i++) ...[
                if (i > 0) const SizedBox(width: 12),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 320),
                  padding: EdgeInsets.symmetric(
                      horizontal: i == active ? 12 : 8, vertical: 9),
                  decoration: BoxDecoration(
                    color: i == active
                        ? const Color(0xFF272639)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _items[i].$1,
                        size: 19,
                        color: i == active
                            ? MatjarkomDemo.accent
                            : const Color(0xFF6E6E7A),
                      ),
                      if (i == active) ...[
                        const SizedBox(width: 8),
                        Txt(_items[i].$2,
                            size: 11.5,
                            weight: FontWeight.w700,
                            color: MatjarkomDemo.accent,
                            maxLines: 1),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      );
}

// --------------------------------------------------------------- category ---

class _Category extends StatelessWidget {
  const _Category();

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            alignment: Alignment.center,
            children: const [
              Column(
                children: [
                  Txt('تصفح القسم', size: 12, color: MatjarkomDemo.muted),
                  SizedBox(height: 2),
                  Txt('FURNITURE',
                      size: 19,
                      weight: FontWeight.w800,
                      letterSpacing: 1.2),
                ],
              ),
              Positioned(right: 0, child: _BackChevron()),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: const [
                _ProductRow(
                  items: [
                    ('prod_sofa', 'Annibale Colombo Sofa', 2499.99, 0),
                    ('prod_bed', 'Annibale Colombo Bed', 1899.99, 1),
                  ],
                ),
                SizedBox(height: 14),
                _ProductRow(
                  items: [
                    ('prod_chair', 'Knoll Saarinen Executive', 499.99, 2),
                    ('prod_table', 'Bedside Table African Che', 299.99, 3),
                  ],
                ),
                SizedBox(height: 14),
                _ProductRow(
                  items: [
                    ('prod_sink', 'Wooden Bathroom Sink With', 379.99, 4),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
}

// ------------------------------------------------------------ add to cart ---

class _AddedToCart extends StatefulWidget {
  const _AddedToCart();

  @override
  State<_AddedToCart> createState() => _AddedToCartState();
}

class _AddedToCartState extends State<_AddedToCart> {
  Timer? _snack;
  bool _shown = false;

  @override
  void initState() {
    super.initState();
    // The mockup shows the confirmation landing after the tap, not at once.
    _snack = Timer(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => _shown = true);
    });
  }

  @override
  void dispose() {
    _snack?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScreenBody(
        body: [
          const Txt('اخترنا لك', size: 17, weight: FontWeight.w800),
          const SizedBox(height: 14),
          const _Filters(),
          const SizedBox(height: 20),
          const _ProductRow(
            items: [
              ('prod_palette', 'Eyeshadow Palette with M', 19.99, 0),
              ('prod_mascara', 'Essence Mascara Lash Pri', 9.99, 1),
            ],
          ),
          const SizedBox(height: 14),
          const _ProductRow(
            items: [
              ('prod_lipstick', 'Ruby Lipstick Matte', 14.50, 2),
              ('prod_powder', 'Loose Setting Powder', 22.00, 3),
            ],
          ),
        ],
        footer: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AnimatedSlide(
              offset: _shown ? Offset.zero : const Offset(0, 0.7),
              duration: const Duration(milliseconds: 420),
              curve: Curves.easeOutCubic,
              child: AnimatedOpacity(
                opacity: _shown ? 1 : 0,
                duration: const Duration(milliseconds: 320),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: MatjarkomDemo.accent,
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(Icons.shopping_bag_rounded,
                            size: 20, color: MatjarkomDemo.accent),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Txt('تمت الإضافة للسلة',
                                size: 14, weight: FontWeight.w800, maxLines: 1),
                            SizedBox(height: 3),
                            Txt('المنتج جاهز للدفع الآن',
                                size: 11.5,
                                color: Color(0xFFE4E3FF),
                                maxLines: 1),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const _TabBar(active: 0),
          ],
        ),
      );
}

// ----------------------------------------------------------------- orders ---

class _Orders extends StatelessWidget {
  const _Orders();

  @override
  Widget build(BuildContext context) => ScreenBody(
        body: [
          Stack(
            alignment: Alignment.center,
            children: [
              const Txt('طلباتي', size: 19, weight: FontWeight.w800),
              const Positioned(
                left: 0,
                child: Icon(Icons.delete_outline_rounded,
                    size: 25, color: MatjarkomDemo.danger),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: MatjarkomDemo.surface,
              borderRadius: BorderRadius.circular(26),
            ),
            child: Row(
              children: [
                ClipOval(
                  child: SizedBox(
                    width: 84,
                    height: 84,
                    child: _Shot('prod_palette'),
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Txt('Eyeshadow Palette with Mirror',
                          size: 14, weight: FontWeight.w700, maxLines: 1),
                      SizedBox(height: 6),
                      Txt('Electronic', size: 12, color: MatjarkomDemo.muted),
                      SizedBox(height: 8),
                      Txt('\$19.99', size: 16, weight: FontWeight.w800),
                    ],
                  ),
                ),
                const _Qty(),
              ],
            ),
          ),
        ],
        footer: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              decoration: BoxDecoration(
                color: MatjarkomDemo.surface,
                borderRadius: BorderRadius.circular(26),
              ),
              child: Row(
                children: [
                  const Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Txt('السعر الإجمالي',
                            size: 12.5, color: MatjarkomDemo.muted, maxLines: 1),
                        SizedBox(height: 4),
                        CountUp(
                          value: 19.99,
                          playKey: 'orders-total',
                          prefix: r'$',
                          decimals: 2,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 15),
                    decoration: BoxDecoration(
                      color: MatjarkomDemo.accent,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.shopping_cart_rounded,
                            size: 19, color: Colors.white),
                        SizedBox(width: 12),
                        Txt('دفع',
                            size: 15,
                            weight: FontWeight.w800,
                            color: Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const _TabBar(active: 1),
          ],
        ),
      );
}

class _Qty extends StatelessWidget {
  const _Qty();

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _QtyButton(Icons.add_rounded),
          const SizedBox(height: 6),
          const Txt('1', size: 15, weight: FontWeight.w700),
          const SizedBox(height: 6),
          const _QtyButton(Icons.remove_rounded),
        ],
      );
}

class _QtyButton extends StatelessWidget {
  const _QtyButton(this.icon);

  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
        width: 30,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF4A4A4A)),
        ),
        child: Icon(icon, size: 16, color: Colors.white),
      );
}

// ----------------------------------------------------------- confirm order --

class _ConfirmOrder extends StatefulWidget {
  const _ConfirmOrder();

  @override
  State<_ConfirmOrder> createState() => _ConfirmOrderState();
}

class _ConfirmOrderState extends State<_ConfirmOrder> {
  /// The mockup shows the credit card selected; the beat flips to the debit one
  /// so the single-select state is visibly live rather than a still frame.
  bool _credit = true;
  Timer? _flip;

  @override
  void initState() {
    super.initState();
    _flip = Timer(const Duration(milliseconds: 1800), () {
      if (mounted) setState(() => _credit = false);
    });
  }

  @override
  void dispose() {
    _flip?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScreenBody(
        body: [
          Stack(
            alignment: Alignment.center,
            children: const [
              Txt('تأكيد الطلب', size: 19, weight: FontWeight.w800),
              Positioned(right: 0, child: _BackChevron()),
            ],
          ),
          const SizedBox(height: 26),
          _CardRow(
            title: 'بطاقة ائتمان',
            number: '5227 **** **** 3302',
            selected: _credit,
            iconColor: Colors.white,
          ),
          const SizedBox(height: 16),
          _CardRow(
            title: 'بطاقة مدين',
            number: '4929 **** **** 1976',
            selected: !_credit,
            iconColor: const Color(0xFF2F80ED),
          ),
          const SizedBox(height: 34),
          const Txt('عنوان التوصيل', size: 16.5, weight: FontWeight.w800),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: MatjarkomDemo.surface,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: MatjarkomDemo.tile,
                      borderRadius: BorderRadius.circular(14)),
                  child: const Icon(Icons.inventory_2_outlined,
                      size: 20, color: Colors.white),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Txt('Delivery Point',
                          size: 13,
                          weight: FontWeight.w700,
                          color: MatjarkomDemo.green),
                      SizedBox(height: 5),
                      Txt('Mohammed Mahmoud 1، ميدان التحرير، Egypt',
                          size: 12.5, weight: FontWeight.w700, maxLines: 1),
                    ],
                  ),
                ),
                const Icon(Icons.edit_outlined, size: 18, color: Colors.white),
              ],
            ),
          ),
        ],
        footer: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Row(
              children: [
                Flexible(
                  child: Txt('وقت التوصيل المتوقع:',
                      size: 13, color: MatjarkomDemo.muted, maxLines: 1),
                ),
                SizedBox(width: 10),
                Txt('20-30 min',
                    size: 13, color: MatjarkomDemo.muted, maxLines: 1),
              ],
            ),
            const SizedBox(height: 14),
            const Row(
              children: [
                Flexible(
                  child: Txt('السعر الإجمالي',
                      size: 15.5, weight: FontWeight.w800, maxLines: 1),
                ),
                SizedBox(width: 10),
                CountUp(
                  value: 19.99,
                  playKey: 'confirm-total',
                  prefix: r'$',
                  decimals: 2,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const _Cta('إتمام الطلب',
                icon: Icons.check_circle_outline_rounded),
          ],
        ),
      );
}

class _CardRow extends StatelessWidget {
  const _CardRow({
    required this.title,
    required this.number,
    required this.selected,
    required this.iconColor,
  });

  final String title;
  final String number;
  final bool selected;
  final Color iconColor;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOut,
        height: 92,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF1A1D26) : MatjarkomDemo.surface,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Icon(Icons.credit_card_rounded, size: 28, color: iconColor),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Txt(title, size: 15, weight: FontWeight.w800, maxLines: 1),
                  const SizedBox(height: 5),
                  Txt(number,
                      size: 12.5, color: MatjarkomDemo.muted, maxLines: 1),
                ],
              ),
            ),
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              size: 24,
              color: selected ? Colors.white : const Color(0xFF4A4A4A),
            ),
          ],
        ),
      );
}

// ----------------------------------------------------------------- success --

class _Success extends StatelessWidget {
  const _Success();

  @override
  Widget build(BuildContext context) => ScreenBody(
        body: [
          const SizedBox(height: 56),
          Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutBack,
              builder: (context, v, child) => Opacity(
                opacity: v.clamp(0.0, 1.0),
                child: Transform.scale(scale: 0.6 + 0.4 * v, child: child),
              ),
              child: Container(
                width: 158,
                height: 158,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    color: MatjarkomDemo.surface, shape: BoxShape.circle),
                child: Container(
                  width: 74,
                  height: 74,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      color: MatjarkomDemo.accent, shape: BoxShape.circle),
                  child: const Icon(Icons.check_rounded,
                      size: 44, color: MatjarkomDemo.bg),
                ),
              ),
            ),
          ),
          const SizedBox(height: 44),
          const Center(
            child: Txt('تم إرسال الطلب بنجاح!',
                size: 21, weight: FontWeight.w800),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Center(
              child: Txt(
                'تم تأكيد طلبك وسيتم توصيله إليك في أقرب وقت ممكن.',
                size: 13.5,
                color: MatjarkomDemo.muted,
                height: 1.7,
              ),
            ),
          ),
        ],
        footer: const Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Cta('العودة للرئيسية'),
            SizedBox(height: 12),
          ],
        ),
      );
}

// ------------------------------------------------------------------- chat ---

class _Chat extends StatefulWidget {
  const _Chat();

  @override
  State<_Chat> createState() => _ChatState();
}

class _ChatState extends State<_Chat> {
  static const _turns = [
    (
      false,
      'تم مسح سجل المحادثة. كيف يمكنني مساعدتك؟',
      'AM 01:38',
    ),
    (true, 'فين اوردري', 'AM 01:48'),
    (
      false,
      'أهلاً بكِ يا ريهام محمد، يسعدنا جداً تواصلك معنا. لمساعدتك في تتبع طلبك '
          'بدقة، هل يمكنك تزويدي برقم الطلب (Order ID) المكون من 5 أرقام؟ سأقوم '
          'فوراً بالتحقق من حالة الشحن وموافاتك بالتفاصيل. نحن هنا دائماً لخدمتك!',
      'AM 01:48',
    ),
    (true, '95452', 'AM 01:48'),
    (
      false,
      'شكراً لكِ يا ريهام محمد على تزويدي برقم الطلب 95452. لقد تم استلام طلبك '
          'وهو الآن قيد المراجعة في قسم الشحن. سنقوم بإرسال رسالة نصية لكِ فور '
          'خروج الطلب للتوصيل.',
      'AM 01:49',
    ),
  ];

  int _revealed = 0;
  bool _typing = false;
  final List<Timer> _timers = [];

  @override
  void initState() {
    super.initState();
    _schedule(200, () => _revealed = 1);
    _schedule(900, () => _revealed = 2);
    _schedule(1600, () => _revealed = 3);
    _schedule(2500, () => _revealed = 4);
    _schedule(3000, () => _typing = true);
    _schedule(3900, () {
      _typing = false;
      _revealed = _turns.length;
    });
  }

  void _schedule(int ms, void Function() action) =>
      _timers.add(Timer(Duration(milliseconds: ms), () {
        if (mounted) setState(action);
      }));

  @override
  void dispose() {
    for (final t in _timers) {
      t.cancel();
    }
    _timers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  const Txt('مساعد متجركم', size: 17, weight: FontWeight.w800),
                  const SizedBox(height: 3),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _Pulse(),
                      const SizedBox(width: 6),
                      const Txt('Online',
                          size: 11.5, color: MatjarkomDemo.muted),
                    ],
                  ),
                ],
              ),
              const Positioned(
                left: 0,
                child: Icon(Icons.delete_sweep_rounded,
                    size: 24, color: MatjarkomDemo.danger),
              ),
              const Positioned(right: 0, child: _BackChevron()),
            ],
          ),
          const SizedBox(height: 18),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                for (var i = 0; i < _revealed && i < _turns.length; i++)
                  _Bubble(
                    text: _turns[i].$2,
                    me: _turns[i].$1,
                    time: _turns[i].$3,
                  ),
                if (_typing) const _Typing(),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 54,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    color: MatjarkomDemo.chatBubble,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: const Txt('اكتب رسالتك هنا...',
                      size: 13, color: Color(0xFF8FA0A8)),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    color: MatjarkomDemo.accent, shape: BoxShape.circle),
                child: const Icon(Icons.near_me_rounded,
                    size: 20, color: Colors.white),
              ),
            ],
          ),
        ],
      );
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.text, required this.me, required this.time});

  final String text;
  final bool me;
  final String time;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
        builder: (context, v, child) => Opacity(
          opacity: v,
          child: Transform.translate(offset: Offset(0, 12 * (1 - v)), child: child),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Align(
            alignment: me ? Alignment.centerRight : Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: me ? 170 : 288),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color:
                          me ? MatjarkomDemo.accent : MatjarkomDemo.chatBubble,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Txt(
                      text,
                      size: 13,
                      height: 1.7,
                      color: me ? Colors.white : const Color(0xFFE6E6E6),
                    ),
                  ),
                ),
                // The mockups print these timestamps in Latin order, so the
                // run is forced LTR instead of letting RTL reorder it.
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Txt(time, size: 10.5, color: MatjarkomDemo.muted),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class _Typing extends StatelessWidget {
  const _Typing();

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
            decoration: BoxDecoration(
              color: MatjarkomDemo.chatBubble,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [_Dot(delay: 0), _Dot(delay: 160), _Dot(delay: 320)],
            ),
          ),
        ),
      );
}

class _Dot extends StatefulWidget {
  const _Dot({required this.delay});

  final int delay;

  @override
  State<_Dot> createState() => _DotState();
}

class _DotState extends State<_Dot> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  @override
  void initState() {
    super.initState();
    _c.repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _c,
        builder: (context, _) {
          final t = _c.value * 2 * math.pi + widget.delay / 150;
          final lift = (math.sin(t) + 1) / 2;
          return Container(
            width: 7,
            height: 7,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              color: MatjarkomDemo.muted.withValues(alpha: 0.3 + 0.6 * lift),
              shape: BoxShape.circle,
            ),
          );
        },
      );
}

class _Pulse extends StatefulWidget {
  const _Pulse();

  @override
  State<_Pulse> createState() => _PulseState();
}

class _PulseState extends State<_Pulse> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _c,
        builder: (context, _) => Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: const Color(0xFF35C77E),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF35C77E)
                    .withValues(alpha: 0.25 + 0.35 * _c.value),
                blurRadius: 6 + 4 * _c.value,
              ),
            ],
          ),
        ),
      );
}
