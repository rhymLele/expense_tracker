import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/widgets/base_button.dart';
import '../../../../core/widgets/base_loading.dart';
import '../../../../core/widgets/base_text_field.dart';
import '../../../auth/presentation/shared/auth_cubit.dart';
import '../../../auth/presentation/shared/auth_state.dart';
import 'bloc/create_topic_cubit.dart';
import 'bloc/create_topic_state.dart';
import 'create_topic_view_model.dart';

class CreateTopicPage extends StatelessWidget {
  const CreateTopicPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<CreateTopicViewModel>();
    final authState = context.read<AuthCubit>().state;
    final userRole = authState is AuthAuthenticated ? authState.user.role : 'student';

    return BlocConsumer<CreateTopicCubit, CreateTopicState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (ctx, state) {
        if (state.isSuccess) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            const SnackBar(
              content: Text('Đăng bài thành công!'),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.pop(ctx, true);
        }
        if (state.isFailure) {
          ScaffoldMessenger.of(ctx)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Text(state.error ?? 'Đăng bài thất bại'),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              action: SnackBarAction(
                label: 'Đóng',
                textColor: AppColors.background,
                onPressed: vm.dismissError,
              ),
            ));
        }
      },
      builder: (ctx, state) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          title: const Text('Tạo bài đăng', style: AppTextStyles.titleLarge),
          leading: IconButton(
            icon: const Icon(Icons.close, color: AppColors.textPrimary),
            onPressed: () => Navigator.pop(ctx),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: AppSizes.paddingMd),
              child: state.isLoading
                  ? const BaseLoading(size: 24)
                  : TextButton(
                      onPressed: vm.submit,
                      child: const Text(
                        'Đăng',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
            ),
          ],
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(ctx).unfocus(),
          behavior: HitTestBehavior.opaque,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.paddingLg),
            child: Form(
              key: vm.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TypeSelector(
                    selected: state.selectedType,
                    userRole: userRole,
                    onChanged: vm.selectType,
                  ),
                  const SizedBox(height: AppSizes.paddingLg),
                  BaseTextField(
                    controller: vm.titleController,
                    labelText: 'Tiêu đề',
                    hintText: 'Nhập tiêu đề bài đăng...',
                    textInputAction: TextInputAction.next,
                    validator: vm.validateTitle,
                  ),
                  const SizedBox(height: AppSizes.paddingLg),
                  BaseTextField(
                    controller: vm.descriptionController,
                    labelText: 'Nội dung (tuỳ chọn)',
                    hintText: 'Mô tả thêm về bài đăng...',
                    maxLines: 5,
                    textInputAction: TextInputAction.newline,
                  ),
                  const SizedBox(height: AppSizes.paddingLg),
                  _VisibilityToggle(
                    selected: state.selectedVisibility,
                    onChanged: vm.selectVisibility,
                  ),
                  const SizedBox(height: AppSizes.xxxl),
                  BaseButton(
                    width: double.infinity,
                    onPressed: state.isLoading ? null : vm.submit,
                    child: state.isLoading
                        ? const BaseLoading(color: AppColors.background, size: 24)
                        : const Text(
                            'Đăng bài',
                            style: TextStyle(
                              color: AppColors.background,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Type Selector ─────────────────────────────────────────────────────────

class _TypeSelector extends StatelessWidget {
  final String selected;
  final String userRole;
  final ValueChanged<String> onChanged;

  const _TypeSelector({
    required this.selected,
    required this.userRole,
    required this.onChanged,
  });

  static const _types = [
    _TopicTypeOption(value: 'lesson', label: 'Bài học', icon: Icons.menu_book_outlined),
    _TopicTypeOption(value: 'exercise', label: 'Bài tập', icon: Icons.edit_note_outlined),
    _TopicTypeOption(value: 'journey', label: 'Hành trình', icon: Icons.route_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    final visibleTypes = userRole == 'teacher'
        ? _types
        : _types.where((t) => t.value != 'journey').toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Loại bài đăng', style: AppTextStyles.labelMedium),
        const SizedBox(height: AppSizes.paddingSm),
        Row(
          children: visibleTypes
              .map((opt) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: opt == visibleTypes.last ? 0 : AppSizes.paddingSm,
                      ),
                      child: _TypeChip(
                        option: opt,
                        isSelected: selected == opt.value,
                        onTap: () => onChanged(opt.value),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _TopicTypeOption {
  final String value;
  final String label;
  final IconData icon;
  const _TopicTypeOption({required this.value, required this.label, required this.icon});
}

class _TypeChip extends StatelessWidget {
  final _TopicTypeOption option;
  final bool isSelected;
  final VoidCallback onTap;
  const _TypeChip({required this.option, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          vertical: AppSizes.paddingSm,
          horizontal: AppSizes.paddingXs,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.08) : AppColors.surface,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        child: Column(
          children: [
            Icon(option.icon,
                size: 22,
                color: isSelected ? AppColors.primary : AppColors.textHint),
            const SizedBox(height: 4),
            Text(
              option.label,
              style: AppTextStyles.bodySmall.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Visibility Toggle ──────────────────────────────────────────────────────

class _VisibilityToggle extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;
  const _VisibilityToggle({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Hiển thị', style: AppTextStyles.labelMedium),
        const Spacer(),
        _VisibilityChip(
          label: 'Công khai',
          icon: Icons.public_outlined,
          value: 'public',
          selected: selected,
          onTap: onChanged,
        ),
        const SizedBox(width: AppSizes.paddingSm),
        _VisibilityChip(
          label: 'Người theo dõi',
          icon: Icons.people_outline,
          value: 'followers_only',
          selected: selected,
          onTap: onChanged,
        ),
      ],
    );
  }
}

class _VisibilityChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final String value;
  final String selected;
  final ValueChanged<String> onTap;
  const _VisibilityChip({
    required this.label,
    required this.icon,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == selected;
    return GestureDetector(
      onTap: () => onTap(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingSm,
          vertical: AppSizes.paddingXs,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.08) : AppColors.surface,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 14,
                color: isSelected ? AppColors.primary : AppColors.textHint),
            const SizedBox(width: 4),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
