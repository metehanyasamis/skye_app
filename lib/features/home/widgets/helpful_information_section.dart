import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:skye_app/shared/models/blog_model.dart';
import 'package:skye_app/features/home/widgets/info_card.dart';
import 'package:skye_app/shared/theme/app_colors.dart';

/// Helpful Information section widget displaying blog posts
class HelpfulInformationSection extends StatelessWidget {
  const HelpfulInformationSection({
    super.key,
    required this.blogPosts,
    required this.isLoading,
    this.onBlogTap,
  });

  final List<BlogModel> blogPosts;
  final bool isLoading;
  final void Function(BlogModel)? onBlogTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'HELPFUL INFORMATIONS',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.textGrayLight,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 135,
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : blogPosts.isEmpty
                  ? _buildDefaultInfoCards()
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: blogPosts.length,
                      itemBuilder: (context, index) {
                        final blog = blogPosts[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            right: index < blogPosts.length - 1 ? 12 : 0,
                          ),
                          child: InfoCard(
                            blog: blog,
                            onTap: onBlogTap != null
                                ? () => onBlogTap!(blog)
                                : () {
                                    debugPrint('🧭 [HelpfulInformationSection] Blog tapped: ${blog.title}');
                                  },
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }

  Widget _buildDefaultInfoCards() {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: const [
        InfoCard(title: 'Why are the airplanes white?'),
        SizedBox(width: 12),
        InfoCard(title: '5 interesting facts about flying'),
        SizedBox(width: 12),
        InfoCard(title: 'We lose a lot of water during a flight'),
      ],
    );
  }
}
