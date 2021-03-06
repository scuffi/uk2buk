import 'package:buk/providers/feed/feed_provider.dart';
import 'package:buk/widgets/feed/interface/blocked_type.dart';
import 'package:buk/widgets/feed/interface/item_data.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:buk/api/user_api.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  List<ItemData> _likes = [];
  bool _admin = false;
  List<BlockItem> _blocks = [];

  User? get user => _user;
  List<ItemData> get likes => _likes;
  bool get admin => _admin;
  List<BlockItem> get blocks => _blocks;

  void setBlocks(List<BlockItem> blocks) {
    _blocks = blocks;
    notifyListeners();
  }

  Future<void> addBlock(BlockItem block) async {
    var success = await addUserBlock(_user!, block);
    if (success) {
      _blocks.add(block);
    }
    notifyListeners();
  }

  Future<void> removeBlock(BlockItem block) async {
    var success = await removeUserBlockById(_user!, block.id);
    if (success) {
      _blocks.removeWhere((element) => element.id == block.id);
    }
    notifyListeners();
  }

  bool isBlockedById(String id) {
    return _blocks.any((element) => element.id == id);
  }

  void setAdmin(bool bool) {
    _admin = bool;
    notifyListeners();
  }

  List<ItemData> getSortedLikes() {
    likes.sort((a, b) => b.timestamp!.compareTo(a.timestamp!));
    return likes;
  }

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  bool _existsInFeed(ItemData item, FeedData feed) {
    return feed.fullFeed.contains(item);
  }

  Future<bool> addLike(ItemData item, FeedData feed) async {
    if (_existsInFeed(item, feed)) {
      bool success = await addUserLike(user!, item);

      if (success) {
        _likes.add(item);
        notifyListeners();
        return true;
      }
    }

    return false;
  }

  void discreditLike(String id) {
    _likes.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  Future<bool> removeLike(ItemData item) async {
    bool success = await removeUserLike(user!, item);

    if (success) {
      _likes.remove(item);
      notifyListeners();
      return true;
    }

    return false;
  }

  Future<bool> removeLikes(List<ItemData> itemIds) async {
    bool success = await removeUserLikes(user!, itemIds);

    if (success) {
      _likes.removeWhere(((element) => itemIds.contains(element)));
      notifyListeners();
      return true;
    }

    return false;
  }

  void defaultAddLikes(List<ItemData> likes, FeedData feed) {
    _likes.addAll(likes);

    notifyListeners();
  }

  bool hasLiked(ItemData item) {
    return _likes.any((element) => element.id == item.id);
  }

  void clearUser() {
    _user = null;
    _likes = [];
    notifyListeners();
  }
}
