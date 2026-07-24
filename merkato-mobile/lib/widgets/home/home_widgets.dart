import 'dart:async';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:merkato_mobile/theme/app_theme.dart';
import 'package:merkato_mobile/widgets/merkato_logo.dart';

class HomeHeader extends StatelessWidget {
  final VoidCallback? onMenuTap;

  const HomeHeader({super.key, this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.lightGreen,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(Icons.menu, color: AppColors.primaryGreen),
              onPressed: onMenuTap ?? () {},
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(child: MerkatoLogoText(fontSize: 16, showTagline: true)),
          _WalletChip(),
          const SizedBox(width: 4),
          _BadgeIcon(icon: Icons.chat_bubble_outline, count: 3),
          const SizedBox(width: 4),
          _BadgeIcon(icon: Icons.shopping_cart_outlined, count: 2),
        ],
      ),
    );
  }
}

class _WalletChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.lightGreen,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accentGreen.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentGreen.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.account_balance_wallet, size: 14, color: AppColors.accentGreen),
          SizedBox(width: 4),
          Text(
            '1,250 Birr',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryGreen,
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeIcon extends StatelessWidget {
  final IconData icon;
  final int count;

  const _BadgeIcon({required this.icon, required this.count});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: Icon(icon, color: AppColors.textDark),
          onPressed: () {},
        ),
        if (count > 0)
          Positioned(
            top: 6,
            right: 6,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                color: AppColors.errorRed,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                '$count',
                style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderGrey),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 14),
                  const Icon(Icons.search, color: AppColors.textGrey, size: 20),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Search for products, stores and more...',
                      style: TextStyle(color: AppColors.textGrey, fontSize: 13),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.lightGreen,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.camera_alt_outlined, color: AppColors.accentGreen, size: 18),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.accentGreen, AppColors.primaryGreen],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accentGreen.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                minimumSize: const Size(72, 48),
                padding: const EdgeInsets.symmetric(horizontal: 14),
              ),
              child: const Text('Search', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeLocationBar extends StatefulWidget {
  const HomeLocationBar({super.key});

  @override
  State<HomeLocationBar> createState() => _HomeLocationBarState();
}

class _HomeLocationBarState extends State<HomeLocationBar> {
  bool _isAmharic = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined, size: 16, color: AppColors.accentGreen),
          const SizedBox(width: 4),
          const Expanded(
            child: Text.rich(
              TextSpan(
                style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
                children: [
                  TextSpan(text: 'Deliver to: '),
                  TextSpan(
                    text: 'Bole, Addis Ababa',
                    style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _isAmharic = !_isAmharic),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.borderGrey),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                _isAmharic ? 'አማርኛ' : 'English',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HeroCarousel extends StatelessWidget {
  const HeroCarousel({super.key});

  static const _slides = [
    {
      'title': 'Big Deals.\nLocal Stores.\nFast Delivery.',
      'subtitle': 'Support local merchants and get the best deals around you.',
      'color': AppColors.primaryGreen,
      'discount': 'Up to 50% OFF',
    },
    {
      'title': 'Made in Ethiopia\nProducts',
      'subtitle': 'Support local artisans & businesses',
      'color': AppColors.accentGreen,
      'discount': 'Local Special',
    },
    {
      'title': 'Pay with\nTelebirr & QR',
      'subtitle': 'Secure payments, instant delivery',
      'color': Color(0xFF006B3F),
      'discount': 'Easy Pay',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: CarouselSlider.builder(
        itemCount: _slides.length,
        options: CarouselOptions(
          height: 180,
          viewportFraction: 1.0,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 4),
        ),
        itemBuilder: (context, index, _) {
          final slide = _slides[index];
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [slide['color'] as Color, (slide['color'] as Color).withOpacity(0.85)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: Stack(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            slide['title'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            slide['subtitle'] as String,
                            style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 11),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.gold,
                              foregroundColor: AppColors.textDark,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              minimumSize: Size.zero,
                            ),
                            child: const Text('Shop Now', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Stack(
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.delivery_dining, color: Colors.white54, size: 60),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.gold,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              slide['discount'] as String,
                              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.textDark),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  bottom: 8,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_slides.length, (idx) => Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: index == idx ? Colors.white : Colors.white.withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                    )),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class QuickServicesRow extends StatelessWidget {
  const QuickServicesRow({super.key});

  static const _services = [
    {'icon': Icons.send, 'label': 'Send Money', 'sub': 'telebirr'},
    {'icon': Icons.qr_code_scanner, 'label': 'Pay Merchant', 'sub': 'QR'},
    {'icon': Icons.phone_android, 'label': 'Airtime & Data', 'sub': ''},
    {'icon': Icons.receipt_long, 'label': 'Bill Payment', 'sub': ''},
    {'icon': Icons.account_balance, 'label': 'Bank Services', 'sub': ''},
    {'icon': Icons.more_horiz, 'label': 'More', 'sub': ''},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Quick Services', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: () {},
                child: const Text('See All >', style: TextStyle(fontSize: 12, color: AppColors.accentGreen, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 95,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _services.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final s = _services[index];
                return SizedBox(
                  width: 72,
                  child: Column(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.lightGreen,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accentGreen.withOpacity(0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(s['icon'] as IconData, color: AppColors.accentGreen, size: 26),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        s['label'] as String,
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                      if ((s['sub'] as String).isNotEmpty)
                        Text(
                          '(${s['sub']})',
                          style: const TextStyle(fontSize: 9, color: AppColors.textGrey),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ValueBadgesRow extends StatelessWidget {
  const ValueBadgesRow({super.key});

  static const _badges = [
    {'icon': Icons.auto_awesome, 'label': 'AI Price Check', 'desc': 'Fair price guarantee before you buy'},
    {'icon': Icons.near_me, 'label': 'Nearby Deals', 'desc': 'Best deals in your area'},
    {'icon': Icons.verified_user, 'label': 'Verified Sellers', 'desc': 'Trusted stores you can rely on'},
    {'icon': Icons.lock, 'label': 'Secure Payments', 'desc': 'Safe & Refund guarantee'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _badges.map((b) {
          return Expanded(
            child: Column(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.lightGreen,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accentGreen.withOpacity(0.12),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(b['icon'] as IconData, color: AppColors.accentGreen, size: 22),
                ),
                const SizedBox(height: 8),
                Text(
                  b['label'] as String,
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textDark),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  b['desc'] as String,
                  style: const TextStyle(fontSize: 8, color: AppColors.textGrey),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class CategoryCirclesRow extends StatelessWidget {
  const CategoryCirclesRow({super.key});

  static const _categories = [
    {'icon': Icons.grid_view, 'label': 'All'},
    {'icon': Icons.devices, 'label': 'Electronics'},
    {'icon': Icons.checkroom, 'label': 'Fashion'},
    {'icon': Icons.kitchen, 'label': 'Home & Kitchen'},
    {'icon': Icons.face, 'label': 'Beauty'},
    {'icon': Icons.smartphone, 'label': 'Phones'},
    {'icon': Icons.directions_car, 'label': 'Vehicles'},
    {'icon': Icons.more_horiz, 'label': 'More'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Top Categories', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: () {},
                child: const Text('See All >', style: TextStyle(fontSize: 12, color: AppColors.accentGreen, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 95,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final cat = _categories[index];
                return SizedBox(
                  width: 70,
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: index == 0 ? AppColors.accentGreen : AppColors.lightGreen,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.accentGreen.withOpacity(0.2)),
                          boxShadow: [
                            BoxShadow(
                              color: (index == 0 ? AppColors.accentGreen : AppColors.lightGreen).withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(cat['icon'] as IconData, color: index == 0 ? Colors.white : AppColors.accentGreen, size: 26),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        cat['label'] as String,
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FlashDealsSection extends StatefulWidget {
  const FlashDealsSection({super.key});

  @override
  State<FlashDealsSection> createState() => _FlashDealsSectionState();
}

class _FlashDealsSectionState extends State<FlashDealsSection> {
  Duration _remaining = const Duration(hours: 2, minutes: 45, seconds: 18);
  Timer? _timer;

  static const _deals = [
    {'name': 'Wireless Earbuds', 'price': '890', 'original': '1,490', 'discount': '40%'},
    {'name': 'Smart Watch', 'price': '2,200', 'original': '3,500', 'discount': '37%'},
    {'name': 'Running Shoes', 'price': '1,650', 'original': '2,800', 'discount': '41%'},
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remaining.inSeconds > 0) {
        setState(() => _remaining -= const Duration(seconds: 1));
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h : $m : $s';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.errorRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.bolt, color: AppColors.errorRed, size: 18),
              ),
              const SizedBox(width: 8),
              const Text('Flash Deals', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              const Text('Limited time offer', style: TextStyle(fontSize: 11, color: AppColors.textGrey)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.errorRed, Color(0xFFD32F2F)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.errorRed.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  _formatDuration(_remaining),
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, fontFeatures: [FontFeature.tabularFigures()]),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 185,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _deals.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final deal = _deals[index];
                return Container(
                  width: 145,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderGrey),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 95,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppColors.lightGreen, AppColors.accentGreen.withOpacity(0.1)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            ),
                            child: Center(
                              child: Icon(Icons.shopping_bag, size: 44, color: AppColors.accentGreen.withOpacity(0.6)),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.errorRed,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                deal['discount']!,
                                style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(deal['name']!, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 6),
                            Text('${deal['price']} Birr', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.errorRed)),
                            Text('${deal['original']} Birr', style: const TextStyle(fontSize: 10, color: AppColors.textGrey, decoration: TextDecoration.lineThrough)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class LocalMarketSection extends StatelessWidget {
  const LocalMarketSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.goldLight, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.gold.withOpacity(0.4)),
          boxShadow: [
            BoxShadow(
              color: AppColors.gold.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.errorRed.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(Icons.favorite, color: AppColors.errorRed, size: 14),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 18,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: const Center(
                          child: Icon(Icons.star, color: Colors.yellow, size: 9),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(6)),
                        child: const Text('Made in Ethiopia', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('Local Market', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  const Text('Shop local products', style: TextStyle(fontSize: 13, color: AppColors.textGrey)),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryGreen,
                      side: const BorderSide(color: AppColors.accentGreen, width: 1.5),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      minimumSize: Size.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Explore', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppColors.lightGreen,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentGreen.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.shopping_basket, size: 44, color: AppColors.accentGreen),
            ),
          ],
        ),
      ),
    );
  }
}

class CoinsRewardsBanner extends StatelessWidget {
  const CoinsRewardsBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryGreen, Color(0xFF003D29)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGreen.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.gold.withOpacity(0.25),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.monetization_on, color: AppColors.gold, size: 26),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Coins & Rewards', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                  SizedBox(height: 3),
                  Text('You have 320 Coins', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                  SizedBox(height: 3),
                  Text('Collect coins and get discounts', style: TextStyle(color: Colors.white70, fontSize: 11)),
                ],
              ),
            ),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.gold.withOpacity(0.25),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.card_giftcard, color: AppColors.gold, size: 26),
            ),
          ],
        ),
      ),
    );
  }
}

class TrendingNearYouSection extends StatelessWidget {
  const TrendingNearYouSection({super.key});

  static const _markets = [
    {'name': 'Bole Market', 'distance': '2.1 km'},
    {'name': 'Megenagna Market', 'distance': '3.5 km'},
    {'name': 'Merkato', 'distance': '4.2 km'},
    {'name': 'Mexico Square', 'distance': '5.0 km'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.errorRed.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.local_fire_department, color: AppColors.errorRed, size: 18),
                  ),
                  const SizedBox(width: 8),
                  const Text('Trending Near You', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              GestureDetector(
                onTap: () {},
                child: const Text('See All >', style: TextStyle(fontSize: 12, color: AppColors.accentGreen, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 105,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _markets.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final m = _markets[index];
                return SizedBox(
                  width: 95,
                  child: Column(
                    children: [
                      Container(
                        width: 85,
                        height: 85,
                        decoration: BoxDecoration(
                          color: AppColors.lightGreen,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.accentGreen.withOpacity(0.3)),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accentGreen.withOpacity(0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.storefront, color: AppColors.accentGreen, size: 36),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        m['name']!,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        m['distance']!,
                        style: const TextStyle(color: AppColors.textGrey, fontSize: 10),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
