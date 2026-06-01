import 'package:equatable/equatable.dart';

abstract class TemplateGalleryEvent extends Equatable {
  const TemplateGalleryEvent();
  @override
  List<Object?> get props => [];
}

class TemplateGalleryLoadRequested extends TemplateGalleryEvent {
  const TemplateGalleryLoadRequested();
}

class TemplateGalleryCategorySelected extends TemplateGalleryEvent {
  final String? category;
  const TemplateGalleryCategorySelected(this.category);
  @override
  List<Object?> get props => [category];
}
