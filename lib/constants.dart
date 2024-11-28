import 'dart:math';

import 'package:flutter/material.dart';

const primaryColor = Color(0xFF2697FF);
const secondaryColor = Color(0xFF2A2D3E);
const bgColor = Color(0xFF212332);

const defaultPadding = 16.0;

class RandomText {
  static const _englishWords = ['apple', 'banana', 'cat', 'dog', 'hello'];

  static String word() {
    final random = Random();
    return _englishWords[random.nextInt(_englishWords.length)];
  }
}
