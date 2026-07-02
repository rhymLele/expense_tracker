import 'dart:developer' as dev;
import 'package:equatable/equatable.dart';
import '../../../../../core/base/base_cubit.dart';
import '../../../data/datasources/chat_remote_datasource.dart';
import '../../../domain/entities/conversation_entity.dart';

// State
enum ChatListStatus { initial, loading, success, failure }

class ChatListState extends Equatable {
  final ChatListStatus status;
  final List<ConversationEntity> conversations;
  final String? error;
  const ChatListState({
    this.status = ChatListStatus.initial,
    this.conversations = const [],
    this.error,
  });
  ChatListState copyWith({
    ChatListStatus? status,
    List<ConversationEntity>? conversations,
    String? error,
  }) => ChatListState(
    status: status ?? this.status,
    conversations: conversations ?? this.conversations,
    error: error,
  );
  @override
  List<Object?> get props => [status, conversations, error];
}

// Cubit
class ChatListCubit extends BaseCubit<ChatListState> {
  final ChatRemoteDataSource _ds;
  final String currentUserId;

  ChatListCubit({required ChatRemoteDataSource datasource, required this.currentUserId})
      : _ds = datasource,
        super(const ChatListState());

  @override
  Future<void> fetchData() => _fetch();

  Future<void> load() => _fetch();
  Future<void> refresh() => _fetch();

  Future<void> _fetch() async {
    emit(state.copyWith(status: ChatListStatus.loading));
    try {
      final list = await _ds.getConversations(currentUserId);
      emit(state.copyWith(status: ChatListStatus.success, conversations: list));
    } catch (e, st) {
      dev.log('ChatListCubit error: $e', stackTrace: st, name: 'Chat');
      emit(state.copyWith(status: ChatListStatus.failure, error: e.toString()));
    }
  }
}
