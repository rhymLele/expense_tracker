import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/skeletons/app_skeletons.dart';
import '../../../teachers/presentation/bloc/teachers_list_bloc.dart';
import '../../../teachers/presentation/bloc/teachers_list_event.dart';
import '../../../teachers/presentation/bloc/teachers_list_state.dart';
import '../../../teachers/presentation/widgets/teacher_card.dart';
import '../widgets/subject_filter_bar.dart';

class DiscoverTab extends StatelessWidget {
  const DiscoverTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<TeachersListBloc>()..add(const TeachersListLoadRequested()),
      child: const _DiscoverContent(),
    );
  }
}

class _DiscoverContent extends StatefulWidget {
  const _DiscoverContent();

  @override
  State<_DiscoverContent> createState() => _DiscoverContentState();
}

class _DiscoverContentState extends State<_DiscoverContent> {
  final _searchController = TextEditingController();
  String? _selectedSubject;

  static const _subjects = [
    'Tiếng Anh',
    'Toán',
    'Lý',
    'Hóa',
    'Văn',
    'Lịch sử',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeachersListBloc, TeachersListState>(
      builder: (context, state) {
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            context
                .read<TeachersListBloc>()
                .add(const TeachersListLoadRequested());
            await context
                .read<TeachersListBloc>()
                .stream
                .firstWhere((s) => s.status != TeachersListStatus.loading);
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeader(context)),
              SliverToBoxAdapter(
                child: SubjectFilterBar(
                  subjects: _subjects,
                  selected: _selectedSubject,
                  onSelected: (subject) {
                    setState(() => _selectedSubject = subject);
                    context
                        .read<TeachersListBloc>()
                        .add(TeachersListSubjectFiltered(subject));
                  },
                ),
              ),
              if (state.status == TeachersListStatus.loading &&
                  state.teachers.isEmpty)
                const TeacherListSkeleton()
              else if (state.status == TeachersListStatus.failure &&
                  state.teachers.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Text(
                      state.errorMessage ?? 'Không tải được dữ liệu',
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ),
                )
              else if (state.teachers.isEmpty &&
                  state.status == TeachersListStatus.success)
                const SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'Không tìm thấy giáo viên',
                      style: AppTextStyles.bodyMedium,
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingLg,
                  ),
                  sliver: SliverList.builder(
                    itemCount: state.teachers.length +
                        (state.hasMore && state.teachers.isNotEmpty ? 1 : 0),
                    itemBuilder: (ctx, i) {
                      if (i == state.teachers.length) {
                        ctx
                            .read<TeachersListBloc>()
                            .add(const TeachersListLoadMoreRequested());
                        return const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: AppSizes.paddingLg,
                          ),
                          child: TeacherCardSkeleton(),
                        );
                      }
                      return TeacherCard(
                        teacher: state.teachers[i],
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.teacherProfile,
                          arguments: state.teachers[i].userId,
                        ),
                      );
                    },
                  ),
                ),
              const SliverToBoxAdapter(
                child: SizedBox(height: AppSizes.xxxl),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.paddingLg,
        AppSizes.paddingXl,
        AppSizes.paddingLg,
        AppSizes.paddingMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Khám phá', style: AppTextStyles.headlineLarge),
          const SizedBox(height: AppSizes.paddingMd),
          TextField(
            controller: _searchController,
            onChanged: (v) => context
                .read<TeachersListBloc>()
                .add(TeachersListSearchChanged(v)),
            decoration: InputDecoration(
              hintText: 'Tìm kiếm giáo viên...',
              hintStyle:
                  AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
              prefixIcon:
                  const Icon(Icons.search, color: AppColors.textHint),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear,
                          color: AppColors.textHint),
                      onPressed: () {
                        _searchController.clear();
                        context
                            .read<TeachersListBloc>()
                            .add(const TeachersListSearchChanged(''));
                      },
                    )
                  : null,
              filled: true,
              fillColor: AppColors.surface,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingMd,
                vertical: AppSizes.paddingSm,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                borderSide: const BorderSide(color: AppColors.divider),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                borderSide: const BorderSide(color: AppColors.divider),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
