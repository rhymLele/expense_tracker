import 'dart:developer' as dev;
import 'package:equatable/equatable.dart';
import '../../../../../core/base/base_cubit.dart';
import '../../../data/datasources/chat_remote_datasource.dart';
import '../../../domain/entities/message_entity.dart';

// State
enum ChatRoomStatus { initial, loading, success, failure, sending }

class ChatRoomState extends Equatable {
  final ChatRoomStatus status;
  final String conversationId;
  final List<MessageEntity> messages;
  final String? error;

  const ChatRoomState({
    this.status = ChatRoomStatus.initial,
    this.conversationId = '',
    this.messages = const [],
    this.error,
  });

  ChatRoomState copyWith({
    ChatRoomStatus? status,
    String? conversationId,
    List<MessageEntity>? messages,
    String? error,
  }) => ChatRoomState(
    status: status ?? this.status,
    conversationId: conversationId ?? this.conversationId,
    messages: messages ?? this.messages,
    error: error,
  );

  @override
  List<Object?> get props => [status, conversationId, messages, error];
}

// Cubit
class ChatRoomCubit extends BaseCubit<ChatRoomState> {
  final ChatRemoteDataSource _ds;

  ChatRoomCubit({required ChatRemoteDataSource datasource})
      : _ds = datasource,
        super(const ChatRoomState());

  /// Phòng chat mở qua [loadRoom] từ UI.
  @override
  Future<void> fetchData() async {}

  Future<void> loadRoom(String conversationId) async {
    emit(state.copyWith(
      status: ChatRoomStatus.loading,
      conversationId: conversationId,
    ));
    try {
      final msgs = await _ds.getMessages(conversationId);
      emit(state.copyWith(status: ChatRoomStatus.success, messages: msgs));
    } catch (e, st) {
      dev.log('ChatRoomCubit load error: $e', stackTrace: st, name: 'Chat');
      emit(state.copyWith(status: ChatRoomStatus.failure, error: e.toString()));
    }
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    emit(state.copyWith(status: ChatRoomStatus.sending));
    try {
      final msg = await _ds.sendMessage(state.conversationId, text.trim());
      emit(state.copyWith(
        status: ChatRoomStatus.success,
        messages: [...state.messages, msg],
      ));
    } catch (e, st) {
      dev.log('ChatRoomCubit send error: $e', stackTrace: st, name: 'Chat');
      emit(state.copyWith(status: ChatRoomStatus.failure, error: e.toString()));
    }
  }
}
