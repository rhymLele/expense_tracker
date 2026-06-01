import 'package:flutter/material.dart';

/// Static mock used while real APIs are being wired.
/// Mirror of design_handoff_learnspace/data.js

class MockUser {
  final String id;
  final String name;
  final String avatar;
  final Color color;
  final String role;
  final String followers;
  final bool verified;
  const MockUser({
    required this.id,
    required this.name,
    required this.avatar,
    required this.color,
    required this.role,
    required this.followers,
    required this.verified,
  });
}

class MockRoadmap {
  final String id;
  final String title;
  final String authorId;
  final int days;
  final double rating;
  final int votes;
  final String learners;
  final Color color;
  final String tag;
  final String blurb;
  const MockRoadmap({
    required this.id,
    required this.title,
    required this.authorId,
    required this.days,
    required this.rating,
    required this.votes,
    required this.learners,
    required this.color,
    required this.tag,
    required this.blurb,
  });
}

class MockPost {
  final String id;
  final String userId;
  final String time;
  final bool liked;
  final int likes;
  final int comments;
  final String text;
  final String? roadmapId;
  final String? image; // 'accent' | 'streak' | null
  const MockPost({
    required this.id,
    required this.userId,
    required this.time,
    required this.liked,
    required this.likes,
    required this.comments,
    required this.text,
    this.roadmapId,
    this.image,
  });
}

abstract class MockData {
  static const users = {
    'maianh': MockUser(
      id: 'maianh', name: 'Cô Mai Anh', avatar: 'MA',
      color: Color(0xFF764FDB), role: 'IELTS 8.5 · Speaking',
      followers: '12.4k', verified: true,
    ),
    'david': MockUser(
      id: 'david', name: 'David Nguyễn', avatar: 'DN',
      color: Color(0xFF2A6FDB), role: 'Phát âm giọng Mỹ',
      followers: '8.9k', verified: true,
    ),
    'linh': MockUser(
      id: 'linh', name: 'Cô Linh Trang', avatar: 'LT',
      color: Color(0xFFE37E36), role: 'Business English',
      followers: '5.1k', verified: true,
    ),
    'hung': MockUser(
      id: 'hung', name: 'Thầy Hùng', avatar: 'TH',
      color: Color(0xFF449297), role: 'Ngữ pháp & Writing',
      followers: '3.7k', verified: false,
    ),
    'mira': MockUser(
      id: 'mira', name: 'Mira Phạm', avatar: 'MP',
      color: Color(0xFFEB5146), role: 'Đang học IELTS',
      followers: '420', verified: false,
    ),
  };

  static const roadmaps = {
    'r1': MockRoadmap(
      id: 'r1', title: 'IELTS Speaking 7.0 trong 30 ngày', authorId: 'maianh',
      days: 30, rating: 4.8, votes: 1240, learners: '3.2k',
      color: Color(0xFF5CC691), tag: 'IELTS',
      blurb: 'Luyện phản xạ Part 1–2–3 với feedback chấm điểm mỗi ngày.',
    ),
    'r2': MockRoadmap(
      id: 'r2', title: 'Phát âm chuẩn Mỹ — 14 ngày', authorId: 'david',
      days: 14, rating: 4.7, votes: 860, learners: '2.1k',
      color: Color(0xFF2A6FDB), tag: 'Phát âm',
      blurb: 'Nắm 44 âm IPA, nối âm và ngữ điệu tự nhiên.',
    ),
    'r3': MockRoadmap(
      id: 'r3', title: 'Business English cho người đi làm', authorId: 'linh',
      days: 21, rating: 4.6, votes: 540, learners: '1.4k',
      color: Color(0xFFE37E36), tag: 'Business',
      blurb: 'Email, họp và thuyết trình tự tin trong 3 tuần.',
    ),
  };

  static const suggestedTeachers = ['maianh', 'david', 'linh', 'hung'];

  static const feed = [
    MockPost(
      id: 'p1', userId: 'maianh', time: '2 giờ', liked: false, likes: 342, comments: 28,
      text: 'Cue card hôm nay: "Describe a memorable trip". Tip vàng — đừng kể tuần tự, hãy bám vào CẢM XÚC tại từng khoảnh khắc. Mình vừa cập nhật bài luyện Ngày 12 của lộ trình bên dưới nhé!',
      roadmapId: 'r1',
    ),
    MockPost(
      id: 'p2', userId: 'david', time: '5 giờ', liked: true, likes: 511, comments: 64,
      text: 'Âm /θ/ và /ð/ là nỗi sợ của người Việt. Bí quyết: đặt lưỡi chạm nhẹ răng cửa rồi đẩy hơi. Xem clip hướng dẫn trong lộ trình 14 ngày bên dưới!',
      roadmapId: 'r2', image: 'accent',
    ),
    MockPost(
      id: 'p3', userId: 'mira', time: '1 ngày', liked: false, likes: 96, comments: 12,
      text: 'Vừa hoàn thành chuỗi 7 ngày streak đầu tiên! Cảm giác mỗi ngày làm xong list bài tập rồi tích lửa đúng kiểu gây nghiện thật sự.',
      image: 'streak',
    ),
  ];
}
