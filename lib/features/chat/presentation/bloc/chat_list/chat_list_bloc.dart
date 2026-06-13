import 'dart:developer' as dev;
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/datasources/chat_remote_datasource.dart';
import '../../../domain/entities/conversation_entity.dart';

// Events
abstract class ChatListEvent extends Equatable {
  const ChatListEvent();
  @override List<Object?> get props => [];
}
class ChatListLoaded extends ChatListEvent { const ChatListLoaded(); }
class ChatListRefreshed extends ChatListEvent { const ChatListRefreshed(); }

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

// Bloc
class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final ChatRemoteDataSource _ds;
  final String currentUserId;

  ChatListBloc({required ChatRemoteDataSource datasource, required this.currentUserId})
      : _ds = datasource,
        super(const ChatListState()) {
    on<ChatListLoaded>((_, emit) => _fetch(emit));
    on<ChatListRefreshed>((_, emit) => _fetch(emit));
  }

  Future<void> _fetch(Emitter<ChatListState> emit) async {
    emit(state.copyWith(status: ChatListStatus.loading));
    try {
      final list = await _ds.getConversations(currentUserId);
      emit(state.copyWith(status: ChatListStatus.success, conversations: list));
    } catch (e, st) {
      dev.log('ChatListBloc error: $e', stackTrace: st, name: 'Chat');
      emit(state.copyWith(status: ChatListStatus.failure, error: e.toString()));
    }
  }
}
