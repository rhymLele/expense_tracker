import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/errors/app_exception.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> register({
    required String email,
    required String password,
    required String fullName,
  });
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  const AuthRemoteDataSourceImpl({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  })  : _auth = auth,
        _firestore = firestore;

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = credential.user!.uid;
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) {
        throw const NotFoundException('Không tìm thấy thông tin người dùng');
      }
      return UserModel.fromFirestore(doc);
    } on AppException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromCode(e.code, firebaseMessage: e.message);
    } on FirebaseException catch (e) {
      throw _mapFirestoreException(e);
    } on SocketException {
      throw const NetworkException();
    } catch (e) {
      throw ServerException(code: 'unknown', message: e.toString());
    }
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = credential.user!.uid;
      final now = DateTime.now();
      final model = UserModel(
        id: uid,
        email: email,
        fullName: fullName,
        createdAt: now,
      );
      await _firestore.collection('users').doc(uid).set(model.toFirestore());
      return model;
    } on AppException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromCode(e.code, firebaseMessage: e.message);
    } on FirebaseException catch (e) {
      throw _mapFirestoreException(e);
    } on SocketException {
      throw const NetworkException();
    } catch (e) {
      throw ServerException(code: 'unknown', message: e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } on FirebaseException catch (e) {
      throw _mapFirestoreException(e);
    } on SocketException {
      throw const NetworkException();
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) return null;
      return UserModel.fromFirestore(doc);
    } on FirebaseException catch (e) {
      throw _mapFirestoreException(e);
    } on SocketException {
      throw const NetworkException();
    }
  }

  AppException _mapFirestoreException(FirebaseException e) => switch (e.code) {
        'not-found'         => const NotFoundException(),
        'permission-denied' => ServerException(
            code: e.code,
            message: 'Không có quyền truy cập',
          ),
        'unavailable'       => const NetworkException(),
        _                   => ServerException(
            code: e.code,
            message: e.message ?? 'Lỗi server, vui lòng thử lại',
          ),
      };
}
