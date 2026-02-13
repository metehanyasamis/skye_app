import 'package:flutter/material.dart';
import 'package:skye_app/shared/models/aircraft_model.dart';
import 'package:skye_app/shared/services/aircraft_api_service.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/system_ui_helper.dart';

class AircraftDetailScreen extends StatefulWidget {
  const AircraftDetailScreen({super.key});

  static const routeName = '/aircraft/detail';

  @override
  State<AircraftDetailScreen> createState() => _AircraftDetailScreenState();
}

class _AircraftDetailScreenState extends State<AircraftDetailScreen> {
  AircraftModel? _aircraft;
  bool _loading = true;
  String? _error;
  bool _hasFetched = false;

  int? get _id {
    final a = ModalRoute.of(context)?.settings.arguments;
    if (a == null) return null;
    if (a is int) return a;
    if (a is num) return a.toInt();
    return null;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_hasFetched) return;
    final id = _id;
    _hasFetched = true;
    if (id == null) {
      setState(() {
        _loading = false;
        _error = 'Invalid aircraft id';
      });
      return;
    }
    _load();
  }

  Future<void> _load() async {
    final id = _id;
    if (id == null) return;

    setState(() {
      _loading = true;
      _error = null;
      _aircraft = null;
    });

    try {
      final a = await AircraftApiService.instance.getAircraftListing(id);
      if (mounted) {
        setState(() {
          _aircraft = a;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = 'Failed to load aircraft';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemUIHelper.setLightStatusBar();

    if (_loading) {
      return Scaffold(
        backgroundColor: AppColors.cfiBackground,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.labelBlack, size: 22),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
              const Expanded(child: Center(child: CircularProgressIndicator())),
            ],
          ),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: AppColors.cfiBackground,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.labelBlack, size: 22),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_error!, style: const TextStyle(color: Colors.red)),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _load,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final a = _aircraft!;
    final location = a.location ?? '';
    final airport = location.split(',').isNotEmpty ? location.split(',').first.trim() : '—';
    final seats = a.seatCount != null ? '${a.seatCount} Seats' : '—';
    final wet = a.wetPrice != null ? '\$${a.wetPrice!.toStringAsFixed(0)}' : '—';
    final dry = a.dryPrice != null ? '\$${a.dryPrice!.toStringAsFixed(0)}' : '—';

    return Scaffold(
      backgroundColor: AppColors.cfiBackground,
      body: SafeArea(
        top: true,
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.labelBlack, size: 22),
                    onPressed: () => Navigator.of(context).pop(),
                    style: IconButton.styleFrom(
                      padding: const EdgeInsets.all(8),
                      minimumSize: const Size(44, 44),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.favorite_border, color: AppColors.labelBlack, size: 24),
                    onPressed: () {},
                    style: IconButton.styleFrom(
                      padding: const EdgeInsets.all(8),
                      minimumSize: const Size(44, 44),
                    ),
                  ),
                ],
              ),
            ),
            Stack(
              clipBehavior: Clip.none,
              children: [
                _AircraftImage(coverUrl: a.coverImageUrl),
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 12,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.start,
                    children: [
                      _Badge(icon: Icons.star, text: '4.9'),
                      _Badge(text: 'Airport: $airport'),
                      _Badge(text: 'Seats: $seats'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _InformationSection(
              aircraft: a,
              ownerName: a.user?.name ?? '—',
              location: location,
              seats: seats,
              model: a.model,
              title: a.title,
              wetPrice: wet,
              dryPrice: dry,
              description: a.description ?? '',
            ),
            const SizedBox(height: 16),
            const _ReviewsSection(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    ),
    );
  }
}

class _AircraftImage extends StatelessWidget {
  const _AircraftImage({this.coverUrl});

  final String? coverUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 243,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFF6F6F6),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: coverUrl != null && coverUrl!.isNotEmpty
          ? ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              child: Image.network(
                coverUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const _PlaceholderIcon(),
              ),
            )
          : const _PlaceholderIcon(),
    );
  }
}

class _PlaceholderIcon extends StatelessWidget {
  const _PlaceholderIcon();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(Icons.flight, size: 120, color: AppColors.textSecondary),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({this.icon, required this.text});

  final IconData? icon;
  final String text;

  static const _textColor = Color(0xFF1F2937);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: _textColor),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: _textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _InformationSection extends StatelessWidget {
  const _InformationSection({
    required this.aircraft,
    required this.ownerName,
    required this.location,
    required this.seats,
    required this.model,
    required this.title,
    required this.wetPrice,
    required this.dryPrice,
    required this.description,
  });

  final AircraftModel aircraft;
  final String ownerName;
  final String location;
  final String seats;
  final String model;
  final String title;
  final String wetPrice;
  final String dryPrice;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.labelBlack,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 25,
                      backgroundColor: AppColors.cardLight,
                      child: Icon(Icons.person, color: AppColors.textSecondary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ownerName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.labelBlack,
                            ),
                          ),
                          if (location.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              location,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.labelBlack60,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.phone, color: AppColors.blue500),
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _InfoCard(label: 'Aircraft', value: title.isNotEmpty ? title : model),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _InfoCard(label: 'Seats', value: seats),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _InfoCard(label: 'Wet price', value: wetPrice),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _InfoCard(label: 'Dry price', value: dryPrice),
                    ),
                  ],
                ),
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _InfoCard(label: 'Description', value: description, isFullWidth: true),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.label,
    required this.value,
    this.isFullWidth = false,
  });

  final String label;
  final String value;
  final bool isFullWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isFullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.cfiBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Color(0xFF667085)),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.labelBlack,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewsSection extends StatelessWidget {
  const _ReviewsSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Aircraft reviews',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.labelBlack,
            ),
          ),
          const SizedBox(height: 16),
          const _ReviewCard(
            name: 'Ivan',
            date: 'May 21, 2022',
            rating: 5,
            review: 'I flew 30 hours in this aircraft with my instructor. The owner is very attentive!',
          ),
          const SizedBox(height: 16),
          const _ReviewCard(
            name: 'Alexander',
            date: 'May 21, 2022',
            rating: 5,
            review: '',
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 13),
                side: const BorderSide(color: AppColors.labelBlack),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'All reviews',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.labelBlack,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({
    required this.name,
    required this.date,
    required this.rating,
    required this.review,
  });

  final String name;
  final String date;
  final int rating;
  final String review;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF475159).withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.cardLight,
                child: Icon(Icons.person, color: AppColors.textSecondary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: AppColors.labelBlack,
                      ),
                    ),
                    Text(
                      date,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF82898F)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ...List.generate(rating, (_) => const Icon(Icons.star, size: 12, color: Color(0xFFFEC84B))),
              const SizedBox(width: 4),
              Text(rating.toString(), style: const TextStyle(fontSize: 12, color: AppColors.labelBlack)),
            ],
          ),
          if (review.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              review,
              style: const TextStyle(fontSize: 14, color: Color(0xFF475467)),
            ),
          ],
        ],
      ),
    );
  }
}
