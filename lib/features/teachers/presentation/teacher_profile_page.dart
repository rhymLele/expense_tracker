import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/sizes.dart';
import '../../../core/constants/text_styles.dart';
import '../../../core/router/app_router.dart';
import '../../../core/widgets/skeletons/app_skeletons.dart';
import 'bloc/teacher_profile_bloc.dart';
import 'bloc/teacher_profile_state.dart';
import 'teacher_profile_view_model.dart';
import 'widgets/teacher_profile_widgets.dart';

class TeacherProfilePage extends StatefulWidget {
  const TeacherProfilePage({super.key});

  @override
  State<TeacherProfilePage> createState() => _TeacherProfilePageState();
}

class _TeacherProfilePageState extends State<TeacherProfilePage> {
  @override
  void initState() {
    super.initState();
    final userId = ModalRoute.of(context)?.settings.arguments as String?;
    if (userId != null) {
      context.read<TeacherProfileViewModel>().load(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<TeacherProfileBloc, TeacherProfileState>(
        builder: (context, state) {
          if (state.status == TeacherProfileStatus.loading) {
            return const TeacherProfileSkeleton();
          }
          if (state.status == TeacherProfileStatus.failure) {
            return _ErrorBody(message: state.errorMessage);
          }
          final teacher = state.teacher;
          if (teacher == null) return const SizedBox.shrink();

          return CustomScrollView(
            slivers: [
              _TeacherAppBar(
                name: teacher.userName,
                avatarUrl: teacher.userAvatarUrl,
                isFollowing: state.isFollowing,
                isFollowLoading: state.isFollowLoading,
                onFollowTap: () =>
                    context.read<TeacherProfileViewModel>().toggleFollow(),
              ),
              SliverToBoxAdapter(
                child: TeacherProfileBody(
                  subjects: teacher.subjects,
                  teachingMode: teacher.teachingMode,
                  rating: teacher.rating,
                  reviewCount: teacher.reviewCount,
                ),
              ),
              if (state.topics.isNotEmpty) ...[
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppSizes.paddingLg,
                      AppSizes.paddingLg,
                      AppSizes.paddingLg,
                      AppSizes.paddingSm,
                    ),
                    child: Text('Bài đăng', style: AppTextStyles.titleLarge),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingLg,
                  ),
                  sliver: SliverList.separated(
                    itemCount: state.topics.length,
                    separatorBuilder: (_, __) =>
                        const Divider(color: AppColors.divider, height: 1),
                    itemBuilder: (ctx, i) => TeacherTopicRow(
                      topic: state.topics[i],
                      onTap: () => Navigator.pushNamed(
                        ctx,
                        AppRoutes.topicDetail,
                        arguments: state.topics[i].id,
                      ),
                    ),
                  ),
                ),
              ],
              const SliverToBoxAdapter(child: SizedBox(height: AppSizes.xxxl)),
            ],
          );
        },
      ),
    );
  }
}

class _TeacherAppBar extends StatelessWidget {
  final String name;
  final String? avatarUrl;
  final bool isFollowing;
  final bool isFollowLoading;
  final VoidCallback onFollowTap;

  const _TeacherAppBar({
    required this.name,
    this.avatarUrl,
    required this.isFollowing,
    required this.isFollowLoading,
    required this.onFollowTap,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.textPrimary,
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: AppColors.surface,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: AppSizes.xxxl),
              CircleAvatar(
                radius: 44,
                backgroundColor: AppColors.primary,
                backgroundImage:
                    avatarUrl != null ? NetworkImage(avatarUrl!) : null,
                child: avatarUrl == null
                    ? Text(
                        name.isNotEmpty ? name[0].toUpperCase() : 'T',
                        style: AppTextStyles.headlineLarge.copyWith(
                          color: AppColors.background,
                        ),
                      )
                    : null,
              ),
              const SizedBox(height: AppSizes.paddingSm),
              Text(name, style: AppTextStyles.titleLarge),
            ],
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: AppSizes.paddingMd),
          child: isFollowLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : OutlinedButton(
                  onPressed: onFollowTap,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isFollowing
                        ? AppColors.textSecondary
                        : AppColors.primary,
                    side: BorderSide(
                      color:
                          isFollowing ? AppColors.divider : AppColors.primary,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingMd,
                    ),
                    minimumSize: const Size(0, 32),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    isFollowing ? 'Đang theo dõi' : 'Theo dõi',
                    style: AppTextStyles.labelMedium,
                  ),
                ),
        ),
      ],
    );
  }
}

class _ErrorBody extends StatelessWidget {
  final String? message;
  const _ErrorBody({this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.textHint),
            const SizedBox(height: AppSizes.paddingMd),
            Text(
              message ?? 'Không tải được thông tin giáo viên',
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.paddingLg),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Quay lại'),
            ),
          ],
        ),
      ),
    );
  }
}
