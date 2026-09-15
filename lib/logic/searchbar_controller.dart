import 'package:flutter/material.dart';

final searchBarNotifier = ValueNotifier<String>('');

void setSearchBarText(String query) {
  searchBarNotifier.value = query;
}

String getSearchBarText() {
  return searchBarNotifier.value;
}
