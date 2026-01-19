import 'package:flutter/material.dart';
import 'package:skye_app/theme/app_colors.dart';
import 'package:skye_app/widgets/skye_logo.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeBackground,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.navy900,
        unselectedItemColor: AppColors.textSecondary,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.flight), label: 'Flights'),
          BottomNavigationBarItem(icon: Icon(Icons.access_time), label: 'Logbook'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          children: [
            Row(
              children: [
                const SkyeLogo(),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.cardLight,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.place, size: 16, color: AppColors.textSecondary),
                        SizedBox(width: 6),
                        Text(
                          '1 World Wy...',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.cardLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.notifications_none, color: AppColors.navy900),
                ),
              ],
            ),
            const SizedBox(height: 22),
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.navy900,
                      fontWeight: FontWeight.w800,
                    ),
                children: const [
                  TextSpan(text: "Let's fly "),
                  TextSpan(
                    text: 'today.',
                    style: TextStyle(color: AppColors.blue500),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _PromoCard(
                    tag: 'BEFORE USE',
                    title: 'Ready to\nmeet your\ninstructor?',
                    actionIcon: Icons.play_circle_fill,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PromoCard(
                    tag: 'ONBOARD',
                    title: 'All about\ntime\nbuilding',
                    actionIcon: Icons.play_circle_fill,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const _SectionTitle(title: 'SHORTCUTS'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: const [
                _ShortcutChip(label: 'AIRCRAFT RENTALS/\nSALES', icon: Icons.airplane_ticket),
                _ShortcutChip(label: 'TIME BUILDING', icon: Icons.timer),
                _ShortcutChip(label: 'GET LISTED AS A CFI', icon: Icons.verified_user),
                _ShortcutChip(label: 'LOGBOOK', icon: Icons.menu_book),
              ],
            ),
            const SizedBox(height: 20),
            _SectionTitle(
              title: 'INSTRUCTORS NEAR YOU',
              trailing: TextButton(
                onPressed: null,
                child: Text('See All'),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 130,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  return _InstructorCard(
                    name: ['Ebru K.', 'Omer K.', 'Nezih L.', 'Muzeo'][index],
                    distance: ['33 mile away', '5 mile away', '5 mile away', '14 mile away'][index],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const _SectionTitle(title: 'HELPFUL INFORMATIONS'),
            const SizedBox(height: 10),
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  return _InfoCard(
                    title: [
                      'Why are the\nairplanes white?',
                      'Interesting facts\nabout flying',
                      'We lose a lot of\nwater during a flight',
                    ][index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PromoCard extends StatelessWidget {
  const _PromoCard({
    required this.tag,
    required this.title,
    required this.actionIcon,
  });

  final String tag;
  final String title;
  final IconData actionIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBlue,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tag,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.bottomRight,
            child: Icon(actionIcon, color: AppColors.white),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.6,
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class _ShortcutChip extends StatelessWidget {
  const _ShortcutChip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: AppColors.cardLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: AppColors.navy900),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.navy900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InstructorCard extends StatelessWidget {
  const _InstructorCard({required this.name, required this.distance});

  final String name;
  final String distance;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.cardLight,
            child: Icon(Icons.person, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.navy900,
            ),
          ),
          Text(
            distance,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBlue,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
