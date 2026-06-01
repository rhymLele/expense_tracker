import 'package:flutter/material.dart';
import '../../../../core/base/base_view_model.dart';
import '../../domain/usecases/create_topic_usecase.dart';
import 'bloc/create_topic_bloc.dart';
import 'bloc/create_topic_event.dart';

class CreateTopicViewModel extends BaseViewModel<CreateTopicBloc> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  CreateTopicViewModel({required CreateTopicUseCase createTopic})
      : super(CreateTopicBloc(createTopic: createTopic));

  void selectType(String type) => bloc.add(CreateTopicTypeChanged(type));

  void selectVisibility(String visibility) =>
      bloc.add(CreateTopicVisibilityChanged(visibility));

  void submit() {
    if (!formKey.currentState!.validate()) return;
    bloc.add(CreateTopicSubmitted(
      title: titleController.text.trim(),
      description: descriptionController.text.trim().isEmpty
          ? null
          : descriptionController.text.trim(),
    ));
  }

  void dismissError() => bloc.add(const CreateTopicErrorDismissed());

  String? validateTitle(String? v) {
    if (v == null || v.trim().isEmpty) return 'Vui lòng nhập tiêu đề';
    if (v.trim().length < 3) return 'Tiêu đề tối thiểu 3 ký tự';
    return null;
  }

  @override
  void disposeResources() {
    titleController.dispose();
    descriptionController.dispose();
  }
}
