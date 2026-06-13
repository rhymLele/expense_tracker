import 'dart:developer' as dev;
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/datasources/chat_remote_datasource.dart';
import '../../../domain/entities/message_entity.dart';

// Events
abstract class ChatRoomEvent extends Equatable {
  const ChatRoomEvent();
  @override List<Object?> get props => [];
}
class ChatRoomLoaded extends ChatRoomEvent {
  final String conversationId;
  const ChatRoomLoaded(this.conversationId);
  @override List<Object?> get props => [conversationId];
}
class ChatRoomMessageSent extends ChatRoomEvent {
  final String text;
  const ChatRoomMessageSent(this.text);
  @override List<Object?> get props => [text];
}

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

// Bloc
class ChatRoomBloc extends Bloc<ChatRoomEvent, ChatRoomState> {
  final ChatRemoteDataSource _ds;

  ChatRoomBloc({required ChatRemoteDataSource datasource})
      : _ds = datasource,
        super(const ChatRoomState()) {
    on<ChatRoomLoaded>(_onLoaded);
    on<ChatRoomMessageSent>(_onSent);
  }

  Future<void> _onLoaded(ChatRoomLoaded event, Emitter<ChatRoomState> emit) async {
    emit(state.copyWith(
      status: ChatRoomStatus.loading,
      conversationId: event.conversationId,
    ));
    try {
      final msgs = await _ds.getMessages(event.conversationId);
      emit(state.copyWith(status: ChatRoomStatus.success, messages: msgs));
    } catch (e, st) {
      dev.log('ChatRoomBloc load error: $e', stackTrace: st, name: 'Chat');
      emit(state.copyWith(status: ChatRoomStatus.failure, error: e.toString()));
    }
  }

  Future<void> _onSent(ChatRoomMessageSent event, Emitter<ChatRoomState> emit) async {
    if (event.text.trim().isEmpty) return;
    emit(state.copyWith(status: ChatRoomStatus.sending));
    try {
      final msg = await _ds.sendMessage(state.conversationId, event.text.trim());
      emit(state.copyWith(
        status: ChatRoomStatus.success,
        messages: [...state.messages, msg],
      ));
    } catch (e, st) {
      dev.log('ChatRoomBloc send error: $e', stackTrace: st, name: 'Chat');
      emit(state.copyWith(status: ChatRoomStatus.failure, error: e.toString()));
    }
  }
}
