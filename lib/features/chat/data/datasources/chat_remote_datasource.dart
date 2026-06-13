import 'dart:developer' as dev;
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/base_remote_datasource.dart';
import '../../../../core/network/http_method.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<ConversationModel>> getConversations(String currentUserId);
  Future<ConversationModel> startDirect(
      String recipientId, String currentUserId);
  Future<List<MessageModel>> getMessages(String conversationId,
      {int page, int limit});
  Future<MessageModel> sendMessage(String conversationId, String text,
      {String? taggedRoadmapId});
}

class ChatRemoteDataSourceImpl extends BaseRemoteDataSource
    implements ChatRemoteDataSource {
  @override
  Future<List<ConversationModel>> getConversations(
      String currentUserId) async {
    try {
      final res = await baseSendRequest(
          ApiConstants.myConversations, HttpMethod.get);
      final raw = res['data'];
      final list = raw is List ? raw : (raw as Map)['items'] as List? ?? [];
      return list
          .map((e) => ConversationModel.fromJson(
              e as Map<String, dynamic>, currentUserId))
          .toList();
    } catch (e, st) {
      dev.log('getConversations error: $e', stackTrace: st, name: 'Chat');
      rethrow;
    }
  }

  @override
  Future<ConversationModel> startDirect(
      String recipientId, String currentUserId) async {
    final res = await baseSendRequest(
      ApiConstants.startDirectConversation,
      HttpMethod.post,
      data: {'recipientId': recipientId},
    );
    final data = res['data'] as Map<String, dynamic>;
    return ConversationModel.fromJson(data, currentUserId);
  }

  @override
  Future<List<MessageModel>> getMessages(String conversationId,
      {int page = 1, int limit = 50}) async {
    final res = await baseSendRequest(
      ApiConstants.conversationMessages(conversationId),
      HttpMethod.get,
      queryParameters: {'page': page, 'limit': limit},
    );
    final raw = res['data'];
    final list = raw is List ? raw : (raw as Map)['items'] as List? ?? [];
    return list
        .map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<MessageModel> sendMessage(String conversationId, String text,
      {String? taggedRoadmapId}) async {
    final res = await baseSendRequest(
      ApiConstants.conversationMessages(conversationId),
      HttpMethod.post,
      data: {
        'text': text,
        if (taggedRoadmapId != null) 'taggedRoadmapId': taggedRoadmapId,
      },
    );
    return MessageModel.fromJson(res['data'] as Map<String, dynamic>);
  }
}
