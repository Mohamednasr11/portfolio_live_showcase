import 'dart:async';

import 'package:flutter/material.dart';

import '../showcase/kit.dart';

/// Brew & Bloom — specialty coffee ordering, rebuilt as a live session.
///
/// Every beat follows the client's high-fidelity screens (onboarding, home,
/// detail item, order, delivery): the near-black onboarding frame, the dark
/// header dissolving into a cream sheet, the caramel accent, the 12-28px radii
/// and the exact wording from the mockups. The sixth beat has no mockup, so it
/// is composed out of the same design system rather than a new one.
class BrewBloomDemo extends StatelessWidget {
  const BrewBloomDemo({super.key, required this.step});

  final int step;

  /// Palette read off the mockups.
  static const Color night = Color(0xFF0B0A09); // onboarding frame
  static const Color header = Color(0xFF1C1A18); // dark app header
  static const Color body = Color(0xFFF6F2EE); // cream sheet
  static const Color caramel = Color(0xFFC0804E); // primary accent
  static const Color ink = Color(0xFF231C16); // headings on cream
  static const Color muted = Color(0xFF9A9188); // secondary text
  static const Color line = Color(0xFFE7E1D9); // hairlines and outlines
  static const Color tile = Color(0xFFF1ECE6); // light icon tile
  static const Color peach = Color(0xFFFDF1E7); // selected size tile
  static const Color promo = Color(0xFFF1695F); // "Promo" badge
  static const Color promoCard = Color(0xFFA87F5F); // promo sheet
  static const Color green = Color(0xFF3DBE5B); // delivery progress

  static const List<String> _screens = [
    'onboarding',
    'home',
    'detail',
    'order',
    'tracking',
    'rewards',
  ];

  @override
  Widget build(BuildContext context) {
    final screen = _screens[step];
    return AppScreen(
      background: switch (step) {
        0 => night,
        1 => header,
        _ => body,
      },
      padding: EdgeInsets.zero,
      tone: step <= 1 ? DeviceScreenTone.dark : DeviceScreenTone.light,
      child: LiveScreenStack(
        screenKey: screen,
        child: switch (screen) {
          'onboarding' => const _Onboarding(),
          'home' => const _Home(),
          'detail' => const _Detail(),
          'order' => const _Order(),
          'tracking' => const _Tracking(),
          _ => const _Rewards(),
        },
      ),
    );
  }
}

// ---------------------------------------------------------------- onboarding

/// One of the owner's own photographs, cut out of the high-fidelity artboards
/// into assets/brewbloom. BoxFit.cover keeps the mockup's crop at any size.
class _Photo extends StatelessWidget {
  const _Photo(this.name, {this.radius = 0});

  final String name;
  final double radius;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.asset(
          'assets/brewbloom/$name.png',
          fit: BoxFit.cover,
          filterQuality: FilterQuality.medium,
        ),
      );
}

class _Onboarding extends StatelessWidget {
  const _Onboarding();

  @override
  Widget build(BuildContext context) => ScreenBody(
        body: [
          // Full-bleed hero: the mockup's cup-in-beans photograph.
          SizedBox(
            height: 330,
            child: Stack(
              fit: StackFit.expand,
              clipBehavior: Clip.none,
              children: [
                const _Photo('onboarding_cup'),
                const Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 70,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0x000B0A09), BrewBloomDemo.night],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 800),
            builder: _copy,
          ),
          const SizedBox(height: 24),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Dot(on: true),
              SizedBox(width: 6),
              _Dot(on: false),
              SizedBox(width: 6),
              _Dot(on: false),
            ],
          ),
          const SizedBox(height: 22),
        ],
        footer: const Padding(
          padding: EdgeInsets.fromLTRB(18, 6, 18, 22),
          child: _BigButton(label: 'Get Started', radius: 26),
        ),
      );

  static Widget _copy(BuildContext context, double v, Widget? child) => Opacity(
        opacity: v.clamp(0.0, 1.0),
        child: Transform.translate(
          offset: Offset(0, 16 * (1 - v)),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Txt(
                'Fall in Love with Coffee in Blissful Delight!',
                size: 23,
                weight: FontWeight.w800,
                color: Colors.white,
                align: TextAlign.center,
                height: 1.2,
              ),
              SizedBox(height: 14),
              Txt(
                'Welcome to our cozy coffee corner, where every cup is a '
                'delightful for you.',
                size: 13,
                color: Color(0xFF9E948B),
                align: TextAlign.center,
                height: 1.4,
              ),
            ],
          ),
        ),
      );
}

class _Dot extends StatelessWidget {
  const _Dot({required this.on});

  final bool on;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        duration: const Duration(milliseconds: 320),
        width: on ? 20 : 7,
        height: 7,
        decoration: BoxDecoration(
          color: on ? BrewBloomDemo.caramel : const Color(0xFF4A423B),
          borderRadius: BorderRadius.circular(4),
        ),
      );
}

/// The mockup CTA: full-width caramel slab with a generous radius.
class _BigButton extends StatelessWidget {
  const _BigButton({required this.label, this.radius = 24, this.height = 56});

  final String label;
  final double radius;
  final double height;

  @override
  Widget build(BuildContext context) => Container(
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: BrewBloomDemo.caramel,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Txt(
          label,
          size: 16,
          weight: FontWeight.w700,
          color: Colors.white,
          maxLines: 1,
        ),
      );
}

// ---------------------------------------------------------------------- home

class _Home extends StatelessWidget {
  const _Home();

  static const _chips = ['All Coffee', 'Machiato', 'Latte', 'Americano'];

  static const _rows = [
    (
      (
        name: 'Caffe Mocha',
        sub: 'Deep Foam',
        price: 4.53,
        tone: Color(0xFF3A241A),
        photo: 'prod_mocha_home'
      ),
      (
        name: 'Flat White',
        sub: 'Espresso',
        price: 3.53,
        tone: Color(0xFFB98B57),
        photo: 'prod_flat'
      ),
    ),
    (
      // The mockups stop at the fold, so the second row has no artwork to cut.
      (
        name: 'Caffe Latte',
        sub: 'Steamed Milk',
        price: 4.13,
        tone: Color(0xFFC79A66),
        photo: ''
      ),
      (
        name: 'Americano',
        sub: 'Hot Brew',
        price: 3.10,
        tone: Color(0xFF2B1A11),
        photo: ''
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            // Bottom padding is the dark strip the promo card straddles.
            padding: const EdgeInsets.fromLTRB(18, 50, 18, 46),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Txt('Location', size: 11, color: Color(0xFF9E948B)),
                SizedBox(height: 4),
                Row(
                  children: [
                    Flexible(
                      child: Txt('Bilzen, Tanjungbalai',
                          size: 15,
                          weight: FontWeight.w800,
                          color: Colors.white,
                          maxLines: 1),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.expand_more_rounded,
                        size: 18, color: Colors.white70),
                  ],
                ),
                SizedBox(height: 18),
                _SearchBar(),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: BrewBloomDemo.body,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(30)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // The promo card sits on the header/sheet seam, as in the
                  // mockup: 118px of card, only 72px of it inside the sheet.
                  SizedBox(
                    height: 72,
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.bottomCenter,
                      children: const [
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          height: 118,
                          child: _Promo(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Expanded(
                    child: ScreenBody(
                    body: [
                      SizedBox(
                        height: 34,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          children: [
                            for (var i = 0; i < _chips.length; i++)
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child:
                                    _Chip(label: _chips[i], selected: i == 0),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      for (var r = 0; r < _rows.length; r++) ...[
                        SizedBox(
                          height: 214,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(child: _CoffeeCard(item: _rows[r].$1)),
                              const SizedBox(width: 12),
                              Expanded(child: _CoffeeCard(item: _rows[r].$2)),
                            ],
                          ),
                        ),
                        if (r == 0) const SizedBox(height: 14),
                      ],
                      const SizedBox(height: 14),
                    ],
                    footer: const _TabBar(),
                  ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) => Row(
        children: [
          const Expanded(
            child: Surface(
              color: Color(0xFF2A2622),
              radius: 18,
              height: 44,
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  Icon(Icons.search_rounded,
                      size: 19, color: Color(0xFF8B8078)),
                  SizedBox(width: 10),
                  Flexible(
                    child: Txt('Search coffee',
                        size: 13,
                        color: Color(0xFF8B8078),
                        maxLines: 1),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: BrewBloomDemo.caramel,
              borderRadius: BorderRadius.all(Radius.circular(18)),
            ),
            child: const Icon(Icons.tune_rounded,
                size: 20, color: Colors.white),
          ),
        ],
      );
}

class _Promo extends StatelessWidget {
  const _Promo();

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: BrewBloomDemo.promoCard,
          borderRadius: BorderRadius.circular(24),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            const Positioned(
              right: -34,
              top: -22,
              child: SizedBox(
                width: 152,
                height: 152,
                child: _Photo('promo_cups', radius: 76),
              ),
            ),
            Positioned(
              left: 16,
              top: 12,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                decoration: BoxDecoration(
                  color: BrewBloomDemo.promo,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Txt('Promo',
                    size: 11, weight: FontWeight.w800, color: Colors.white),
              ),
            ),
            Positioned(
              left: 16,
              right: 72,
              bottom: 14,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Txt('Buy one get',
                      size: 18,
                      weight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.15,
                      maxLines: 2),
                  Txt('one FREE',
                      size: 18,
                      weight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.15,
                      maxLines: 2),
                ],
              ),
            ),
          ],
        ),
      );
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) => Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: selected ? BrewBloomDemo.caramel : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Txt(
          label,
          size: 13,
          weight: FontWeight.w700,
          maxLines: 1,
          color: selected
              ? Colors.white
              : BrewBloomDemo.ink,
        ),
      );
}

class _CoffeeCard extends StatelessWidget {
  const _CoffeeCard({required this.item});

  final ({
    String name,
    String sub,
    double price,
    Color tone,
    String photo,
  }) item;

  @override
  Widget build(BuildContext context) => Surface(
        color: Colors.white,
        radius: 22,
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 92,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (item.photo.isEmpty)
                    FakeImage(
                      size: const Size(double.infinity, double.infinity),
                      from: item.tone,
                      to: item.tone.withValues(alpha: 0.45),
                      radius: 16,
                      icon: Icons.local_cafe_rounded,
                    )
                  else
                    _Photo(item.photo, radius: 16),
                  // The cut-out already carries the mockup's own rating chip.
                  if (item.photo.isEmpty)
                    const Positioned(
                      top: 6,
                      right: 8,
                      child: Row(
                        children: [
                          Icon(Icons.star_rounded,
                              size: 14, color: Color(0xFFFFC24B)),
                          SizedBox(width: 3),
                          Txt('4.8',
                              size: 11,
                              weight: FontWeight.w700,
                              color: Colors.white),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Txt(item.name,
                size: 14,
                weight: FontWeight.w800,
                color: BrewBloomDemo.ink,
                maxLines: 1),
            const SizedBox(height: 3),
            Txt(item.sub,
                size: 12, color: BrewBloomDemo.muted, maxLines: 1),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Txt('\$ ${item.price.toStringAsFixed(2)}',
                      size: 15,
                      weight: FontWeight.w800,
                      color: BrewBloomDemo.ink,
                      maxLines: 1),
                ),
                const SizedBox(width: 4),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: BrewBloomDemo.caramel,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.add_rounded,
                      size: 17, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      );
}

/// The mockup tab bar is a white sheet with rounded top corners, the active
/// icon picked out in caramel with a dash under it.
class _TabBar extends StatelessWidget {
  const _TabBar();

  static const _icons = [
    Icons.home_rounded,
    Icons.favorite_border_rounded,
    Icons.shopping_bag_outlined,
    Icons.notifications_none_rounded,
  ];

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(26, 16, 26, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (var i = 0; i < _icons.length; i++)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _icons[i],
                    size: 23,
                    color: i == 0 ? BrewBloomDemo.caramel : BrewBloomDemo.muted,
                  ),
                  const SizedBox(height: 5),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 320),
                    width: i == 0 ? 14 : 0,
                    height: 4,
                    decoration: BoxDecoration(
                      color: BrewBloomDemo.caramel,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
          ],
        ),
      );
}

// -------------------------------------------------------------------- detail

class _Detail extends StatefulWidget {
  const _Detail();

  @override
  State<_Detail> createState() => _DetailState();
}

class _DetailState extends State<_Detail> {
  static const _sizes = ['S', 'M', 'L'];
  static const _prices = [3.93, 4.53, 5.13];

  /// The mockup shows M selected at \$ 4.53, so start there and cycle.
  int _size = 1;
  Timer? _auto;

  @override
  void initState() {
    super.initState();
    _auto = Timer.periodic(const Duration(milliseconds: 1500), (_) {
      if (!mounted) return;
      setState(() => _size = (_size + 1) % _sizes.length);
    });
  }

  @override
  void dispose() {
    _auto?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScreenBody(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        body: [
          const SizedBox(height: 46),
          Row(
            children: [
              const Icon(Icons.chevron_left_rounded, size: 30, color: BrewBloomDemo.ink),
              const Expanded(
                child: Txt('Detail',
                    size: 17,
                    weight: FontWeight.w800,
                    color: BrewBloomDemo.ink,
                    align: TextAlign.center,
                    maxLines: 1),
              ),
              const Icon(Icons.favorite_border_rounded,
                  size: 24, color: BrewBloomDemo.ink),
            ],
          ),
          const SizedBox(height: 24),
          const SizedBox(
            height: 190,
            child: _Photo('prod_mocha', radius: 28),
          ),
          const SizedBox(height: 22),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Txt('Caffe Mocha',
                        size: 20,
                        weight: FontWeight.w800,
                        color: BrewBloomDemo.ink,
                        maxLines: 1),
                    SizedBox(height: 5),
                    Txt('Ice/Hot',
                        size: 12.5,
                        color: BrewBloomDemo.muted,
                        maxLines: 1),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              _InfoTile(Icons.two_wheeler_rounded),
              const SizedBox(width: 8),
              _InfoTile(Icons.eco_rounded),
              const SizedBox(width: 8),
              _InfoTile(Icons.local_drink_rounded),
            ],
          ),
          const SizedBox(height: 14),
          const Row(
            children: [
              Icon(Icons.star_rounded, size: 18, color: Color(0xFFFFC24B)),
              SizedBox(width: 6),
              Txt('4.8',
                  size: 15,
                  weight: FontWeight.w800,
                  color: BrewBloomDemo.ink),
              SizedBox(width: 5),
              Flexible(
                child: Txt('(230)',
                    size: 13, color: BrewBloomDemo.muted, maxLines: 1),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const SizedBox(
            height: 1,
            child: DecoratedBox(
                decoration: BoxDecoration(color: BrewBloomDemo.line)),
          ),
          const SizedBox(height: 18),
          const Txt('Description',
              size: 16,
              weight: FontWeight.w800,
              color: BrewBloomDemo.ink),
          const SizedBox(height: 10),
          Text.rich(
            TextSpan(
              children: const [
                TextSpan(
                  text: 'A cappuccino is an approximately 150 ml (5 oz) '
                      'beverage, with 25 ml of espresso coffee and 85ml of '
                      'fresh milk the fo.. ',
                  style: TextStyle(
                    color: BrewBloomDemo.muted,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
                TextSpan(
                  text: 'Read More',
                  style: TextStyle(
                    color: BrewBloomDemo.caramel,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Txt('Size',
              size: 16,
              weight: FontWeight.w800,
              color: BrewBloomDemo.ink),
          const SizedBox(height: 12),
          Row(
            children: [
              for (var i = 0; i < _sizes.length; i++)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: i == 2 ? 0 : 10),
                    child: _SizeTile(
                      label: _sizes[i],
                      on: _size == i,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
        ],
        footer: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
          child: Row(
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Txt('Price',
                        size: 12,
                        color: BrewBloomDemo.muted,
                        maxLines: 1),
                    const SizedBox(height: 4),
                    CountUp(
                      value: _prices[_size],
                      playKey: 'bb-price-$_size',
                      prefix: r'$ ',
                      decimals: 2,
                      style: const TextStyle(
                        color: BrewBloomDemo.caramel,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: const _BigButton(label: 'Buy Now', height: 52),
              ),
            ],
          ),
        ),
      );
}

class _InfoTile extends StatelessWidget {
  const _InfoTile(this.icon);

  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
        width: 34,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: BrewBloomDemo.tile,
          borderRadius: BorderRadius.circular(11),
        ),
        child: Icon(icon, size: 18, color: BrewBloomDemo.caramel),
      );
}

class _SizeTile extends StatelessWidget {
  const _SizeTile({required this.label, required this.on});

  final String label;
  final bool on;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: on ? BrewBloomDemo.peach : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: on ? BrewBloomDemo.caramel : BrewBloomDemo.line,
          ),
        ),
        child: Txt(label,
            size: 14,
            weight: FontWeight.w700,
            maxLines: 1,
            color: on ? BrewBloomDemo.caramel : BrewBloomDemo.ink),
      );
}

// --------------------------------------------------------------------- order

class _Order extends StatelessWidget {
  const _Order();

  @override
  Widget build(BuildContext context) => ScreenBody(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        body: [
          const SizedBox(height: 46),
          const Row(
            children: [
              Icon(Icons.chevron_left_rounded,
                  size: 30, color: BrewBloomDemo.ink),
              Expanded(
                child: Txt('Order',
                    size: 17,
                    weight: FontWeight.w800,
                    color: BrewBloomDemo.ink,
                    align: TextAlign.center,
                    maxLines: 1),
              ),
              SizedBox(width: 30),
            ],
          ),
          const SizedBox(height: 24),
          const Row(
            children: [
              Expanded(child: _Segment(label: 'Deliver', on: true)),
              SizedBox(width: 4),
              Expanded(child: _Segment(label: 'Pick Up', on: false)),
            ],
          ),
          const SizedBox(height: 26),
          const Txt('Delivery Address',
              size: 18, weight: FontWeight.w800, color: BrewBloomDemo.ink),
          const SizedBox(height: 16),
          const Txt('Jl. Kpg Sutoyo',
              size: 15,
              weight: FontWeight.w800,
              color: BrewBloomDemo.ink,
              maxLines: 1),
          const SizedBox(height: 5),
          const Txt('Kpg. Sutoyo No. 620, Bilzen, Tanjungbalai.',
              size: 13, color: BrewBloomDemo.muted, height: 1.4),
          const SizedBox(height: 14),
          const Row(
            children: [
              Flexible(child: _GhostPill(label: 'Edit Address', icon: Icons.edit_outlined)),
              SizedBox(width: 10),
              Flexible(child: _GhostPill(label: 'Add Note', icon: Icons.sticky_note_2_outlined)),
            ],
          ),
          const SizedBox(height: 18),
          const SizedBox(
            height: 1,
            child: DecoratedBox(
                decoration: BoxDecoration(color: BrewBloomDemo.line)),
          ),
          const SizedBox(height: 18),
          const Row(
            children: [
              SizedBox(
                width: 56,
                height: 56,
                child: _Photo('prod_mocha_home', radius: 14),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Txt('Caffe Mocha',
                        size: 15,
                        weight: FontWeight.w800,
                        color: BrewBloomDemo.ink,
                        maxLines: 1),
                    SizedBox(height: 4),
                    Txt('Deep Foam',
                        size: 13,
                        color: BrewBloomDemo.muted,
                        maxLines: 1),
                  ],
                ),
              ),
              _Qty(icon: Icons.remove_rounded),
              SizedBox(width: 12),
              Txt('1',
                  size: 15,
                  weight: FontWeight.w800,
                  color: BrewBloomDemo.ink),
              SizedBox(width: 12),
              _Qty(icon: Icons.add_rounded),
            ],
          ),
          const SizedBox(height: 22),
          const Surface(
            color: Colors.white,
            radius: 22,
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 15),
            child: Row(
              children: [
                Icon(Icons.brightness_auto_rounded,
                    size: 24, color: BrewBloomDemo.caramel),
                SizedBox(width: 12),
                Expanded(
                  child: Txt('1 Discount is Applies',
                      size: 14,
                      weight: FontWeight.w700,
                      color: BrewBloomDemo.ink,
                      maxLines: 1),
                ),
                Icon(Icons.chevron_right_rounded,
                    size: 22, color: BrewBloomDemo.muted),
              ],
            ),
          ),
          const SizedBox(height: 26),
          const Txt('Payment Summary',
              size: 18, weight: FontWeight.w800, color: BrewBloomDemo.ink),
          const SizedBox(height: 18),
          const Row(
            children: [
              Txt('Price', size: 14, color: BrewBloomDemo.ink),
              Spacer(),
              Txt('\$ 4.53',
                  size: 14,
                  weight: FontWeight.w800,
                  color: BrewBloomDemo.ink,
                  maxLines: 1),
            ],
          ),
          const SizedBox(height: 14),
          const Row(
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Txt('Delivery Fee',
                      size: 14, color: BrewBloomDemo.ink, maxLines: 1),
                ),
              ),
              SizedBox(width: 10),
              Text(
                r'$ 2.0',
                style: TextStyle(
                  color: BrewBloomDemo.muted,
                  fontSize: 14,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              SizedBox(width: 8),
              Txt('\$ 1.0',
                  size: 14,
                  weight: FontWeight.w800,
                  color: BrewBloomDemo.ink,
                  maxLines: 1),
            ],
          ),
          const SizedBox(height: 22),
        ],
        footer: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(Icons.account_balance_wallet_outlined,
                      size: 24, color: BrewBloomDemo.caramel),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Txt('Cash/Wallet',
                            size: 15,
                            weight: FontWeight.w800,
                            color: BrewBloomDemo.ink,
                            maxLines: 1),
                        SizedBox(height: 3),
                        CountUp(
                          value: 5.53,
                          playKey: 'bb-total',
                          prefix: r'$ ',
                          decimals: 2,
                          style: TextStyle(
                            color: BrewBloomDemo.caramel,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.expand_more_rounded,
                      size: 24, color: BrewBloomDemo.ink),
                ],
              ),
              SizedBox(height: 18),
              _BigButton(label: 'Order'),
            ],
          ),
        ),
      );
}

class _Segment extends StatelessWidget {
  const _Segment({required this.label, required this.on});

  final String label;
  final bool on;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: on ? BrewBloomDemo.caramel : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Txt(label,
            size: 15,
            weight: FontWeight.w700,
            maxLines: 1,
            color: on ? Colors.white : BrewBloomDemo.ink),
      );
}

class _GhostPill extends StatelessWidget {
  const _GhostPill({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFC9C3BB)),
          borderRadius: BorderRadius.circular(17),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: BrewBloomDemo.ink),
            const SizedBox(width: 7),
            Flexible(
              child: Txt(label,
                  size: 13,
                  weight: FontWeight.w500,
                  color: BrewBloomDemo.ink,
                  maxLines: 1),
            ),
          ],
        ),
      );
}

class _Qty extends StatelessWidget {
  const _Qty({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
        width: 30,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: BrewBloomDemo.line),
        ),
        child: Icon(icon, size: 16, color: BrewBloomDemo.ink),
      );
}

// ------------------------------------------------------------------ tracking

class _Tracking extends StatefulWidget {
  const _Tracking();

  @override
  State<_Tracking> createState() => _TrackingState();
}

class _TrackingState extends State<_Tracking>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 7000),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  /// The mockup route walks the grid in right angles, not a bezier.
  static const List<Offset> _stops = [
    Offset(0.20, 0.30),
    Offset(0.20, 0.44),
    Offset(0.34, 0.44),
    Offset(0.34, 0.20),
    Offset(0.68, 0.20),
    Offset(0.68, 0.56),
    Offset(0.52, 0.56),
    Offset(0.52, 0.74),
  ];

  static Offset _at(double t, Size s) {
    final f = t.clamp(0.0, 1.0) * (_stops.length - 1);
    final i = f.floor().clamp(0, _stops.length - 2);
    final local = f - i;
    final a = _stops[i];
    final b = _stops[i + 1];
    return Offset(
      s.width * (a.dx + (b.dx - a.dx) * local),
      s.height * (a.dy + (b.dy - a.dy) * local),
    );
  }

  static Path _route(Size s) {
    final path = Path()..moveTo(_at(0, s).dx, _at(0, s).dy);
    for (var i = 1; i < _stops.length; i++) {
      final p = _stops[i];
      path.lineTo(s.width * p.dx, s.height * p.dy);
    }
    return path;
  }

  @override
  Widget build(BuildContext context) => Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 236,
            child: LayoutBuilder(
              builder: (context, box) {
                final size = Size(box.maxWidth, box.maxHeight);
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      child: ColoredBox(
                        color: const Color(0xFFEFEDEA),
                        child: CustomPaint(painter: _MapPainter(size: size)),
                      ),
                    ),
                    Positioned.fill(
                      child: CustomPaint(
                          painter: _BrewRoute(route: _route(size))),
                    ),
                    Positioned(
                      left: _at(0, size).dx - 15,
                      top: _at(0, size).dy - 26,
                      child: const Icon(Icons.location_on_rounded,
                          size: 30, color: BrewBloomDemo.caramel),
                    ),
                    AnimatedBuilder(
                      animation: _c,
                      builder: (context, _) {
                        final p = _at(_c.value, size);
                        return Positioned(
                          left: p.dx - 21,
                          top: p.dy - 21,
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withValues(alpha: 0.18),
                                  blurRadius: 14,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.two_wheeler_rounded,
                                size: 22, color: BrewBloomDemo.caramel),
                          ),
                        );
                      },
                    ),
                    Positioned(
                      left: 16,
                      top: 46,
                      child: _MapButton(
                          icon: Icons.chevron_left_rounded, size: 26),
                    ),
                    Positioned(
                      right: 16,
                      top: 46,
                      child: _MapButton(
                          icon: Icons.my_location_rounded, size: 20),
                    ),
                  ],
                );
              },
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 396,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(30)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: ScreenBody(
                body: [
                  const SizedBox(height: 12),
                  Center(
                    child: Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D3CC),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Txt('10 minutes left',
                      size: 20,
                      weight: FontWeight.w800,
                      color: BrewBloomDemo.ink,
                      align: TextAlign.center,
                      maxLines: 1),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Txt('Delivery to ',
                          size: 13, color: BrewBloomDemo.muted, maxLines: 1),
                      Flexible(
                        child: Txt('Jl. Kpg Sutoyo',
                            size: 13,
                            weight: FontWeight.w800,
                            color: BrewBloomDemo.ink,
                            maxLines: 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      for (var i = 0; i < 4; i++)
                        Expanded(
                          child: Container(
                            height: 5,
                            margin: EdgeInsets.only(right: i == 3 ? 0 : 8),
                            decoration: BoxDecoration(
                              color: i < 3
                                  ? BrewBloomDemo.green
                                  : const Color(0xFFE4DFD8),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: BrewBloomDemo.line),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: BrewBloomDemo.line),
                          ),
                          child: const Icon(Icons.two_wheeler_rounded,
                              size: 26, color: BrewBloomDemo.caramel),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Txt('Delivered your order',
                                  size: 15,
                                  weight: FontWeight.w800,
                                  color: BrewBloomDemo.ink,
                                  maxLines: 1),
                              SizedBox(height: 5),
                              Txt(
                                'We will deliver your goods to you in the '
                                'shortes possible time.',
                                size: 13,
                                color: BrewBloomDemo.muted,
                                height: 1.45,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    children: [
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: _Photo('courier', radius: 14),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Txt('Brooklyn Simmons',
                                size: 15,
                                weight: FontWeight.w800,
                                color: BrewBloomDemo.ink,
                                maxLines: 1),
                            SizedBox(height: 4),
                            Txt('Personal Courier',
                                size: 13,
                                color: BrewBloomDemo.muted,
                                maxLines: 1),
                          ],
                        ),
                      ),
                      _MapButton(icon: Icons.call_rounded, size: 20),
                    ],
                  ),
                  const SizedBox(height: 18),
                ],
              ),
            ),
          ),
        ],
      );
}

class _MapButton extends StatelessWidget {
  const _MapButton({required this.icon, required this.size});

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
        width: 42,
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, size: size, color: BrewBloomDemo.ink),
      );
}

class _MapPainter extends CustomPainter {
  _MapPainter({required this.size});

  final Size size;

  @override
  void paint(Canvas canvas, Size _) {
    final block = Paint()..color = const Color(0xFFE8E5E1);
    final road = Paint()
      ..color = Colors.white
      ..strokeWidth = 11
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < 4; i++) {
      for (var j = 0; j < 3; j++) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(
              size.width * (j + 0.12) / 3.2,
              size.height * (i + 0.14) / 4.4,
              size.width / 4.6,
              size.height / 6.4,
            ),
            const Radius.circular(4),
          ),
          block,
        );
      }
    }
    for (var i = 1; i < 5; i++) {
      canvas.drawLine(
        Offset(0, size.height * i / 5),
        Offset(size.width, size.height * i / 5 + 10),
        road,
      );
    }
    for (var i = 1; i < 4; i++) {
      canvas.drawLine(
        Offset(size.width * i / 3.4, 0),
        Offset(size.width * i / 3.4 - 8, size.height),
        road,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _MapPainter old) => old.size != size;
}

class _BrewRoute extends CustomPainter {
  _BrewRoute({required this.route});

  final Path route;

  @override
  void paint(Canvas canvas, Size _) {
    canvas.drawPath(
      route,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round
        ..color = BrewBloomDemo.caramel.withValues(alpha: 0.35),
    );
    canvas.drawPath(
      route,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6
        ..color = Colors.white.withValues(alpha: 0.7),
    );
  }

  @override
  bool shouldRepaint(covariant _BrewRoute old) => old.route != route;
}

// --------------------------------------------------- rewards (no mockup beat)

/// No loyalty screen exists in the client's mockups, so this beat is built only
/// from pieces they do define: the promo-card brown, white cards, the S/M/L
/// tile language and the caramel slab button.
class _Rewards extends StatelessWidget {
  const _Rewards();

  @override
  Widget build(BuildContext context) => ScreenBody(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        body: [
          const SizedBox(height: 46),
          const Row(
            children: [
              Icon(Icons.chevron_left_rounded,
                  size: 30, color: BrewBloomDemo.ink),
              Expanded(
                child: Txt('Bloom Club',
                    size: 17,
                    weight: FontWeight.w800,
                    color: BrewBloomDemo.ink,
                    align: TextAlign.center,
                    maxLines: 1),
              ),
              SizedBox(width: 30),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: BrewBloomDemo.promoCard,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Txt('Points Balance',
                    size: 12, color: Color(0xF2FFFFFF), maxLines: 1),
                SizedBox(height: 8),
                CountUp(
                  value: 1480,
                  playKey: 'bb-points',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 16),
                _TierBar(),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Txt('Rewards you can redeem',
              size: 16,
              weight: FontWeight.w800,
              color: BrewBloomDemo.ink),
          const SizedBox(height: 14),
          const _RewardRow(
              cost: '300 pts',
              label: 'Free espresso',
              icon: Icons.local_cafe_rounded,
              unlocked: true),
          const _RewardRow(
              cost: '900 pts',
              label: 'Any latte, size L',
              icon: Icons.coffee_rounded,
              unlocked: true),
          const _RewardRow(
              cost: '2000 pts',
              label: 'Bag of single-origin',
              icon: Icons.inventory_2_outlined,
              unlocked: false),
          const SizedBox(height: 8),
        ],
        footer: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 22),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Surface(
                color: BrewBloomDemo.tile,
                radius: 16,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Row(
                  children: [
                    Icon(Icons.local_offer_rounded,
                        size: 18, color: BrewBloomDemo.caramel),
                    SizedBox(width: 8),
                    Flexible(
                      child: Txt('Invite a friend · +250 pts',
                          size: 13,
                          weight: FontWeight.w700,
                          color: BrewBloomDemo.ink,
                          maxLines: 1),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14),
              _BigButton(label: 'Redeem a reward'),
            ],
          ),
        ),
      );
}

class _TierBar extends StatelessWidget {
  const _TierBar();

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 0.74),
            duration: const Duration(milliseconds: 1200),
            builder: (context, v, _) => ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: v.clamp(0.0, 1.0),
                minHeight: 8,
                backgroundColor: Colors.white24,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Txt('520 pts to Gold tier',
              size: 11.5, color: Color(0xE6FFFFFF), maxLines: 1),
        ],
      );
}

class _RewardRow extends StatelessWidget {
  const _RewardRow({
    required this.cost,
    required this.label,
    required this.icon,
    required this.unlocked,
  });

  final String cost;
  final String label;
  final IconData icon;
  final bool unlocked;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Opacity(
          opacity: unlocked ? 1 : 0.5,
          child: Surface(
            color: Colors.white,
            radius: 20,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: BrewBloomDemo.tile,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(unlocked ? icon : Icons.lock_outline_rounded,
                      size: 17, color: BrewBloomDemo.caramel),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Txt(label,
                      size: 14,
                      weight: FontWeight.w700,
                      color: BrewBloomDemo.ink,
                      maxLines: 1),
                ),
                Txt(cost,
                    size: 13,
                    weight: FontWeight.w800,
                    color: BrewBloomDemo.caramel,
                    maxLines: 1),
              ],
            ),
          ),
        ),
      );
}
