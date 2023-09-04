import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'flipcardgame.dart';

List<String> fillImagesArray() {
  return [
    "assets/banana.png",
    "assets/banana.png",
    "assets/grapes.png",
    "assets/grapes.png",
    "assets/strawberry.png",
    "assets/strawberry.png",
    "assets/cherry.png",
    "assets/cherry.png",
    "assets/apple.png",
    "assets/apple.png",
    "assets/lemon.png",
    "assets/lemon.png",
    "assets/orange.png",
    "assets/orange.png",
    "assets/peach.png",
    "assets/peach.png",
    "assets/pear.png",
    "assets/pear.png",
  ];
}

List<String> getSource(Level level) {
  List<String> levelAndKind = [];
  List imagesArray = fillImagesArray();
  if (level == Level.Hard) {
    imagesArray.forEach((element) {
      levelAndKind.add(element);
    });
  } else if (level == Level.Medium) {
    for (int i = 0; i < 12; i++) {
      levelAndKind.add(imagesArray[i]);
    }
  } else if (level == Level.Easy) {
    for (int i = 0; i < 6; i++) {
      levelAndKind.add(imagesArray[i]);
    }
  }
  levelAndKind.shuffle();
  print(levelAndKind);
  return levelAndKind;
}

List<bool> getCardState(Level level) {
  List<bool> cardStateArray = [];
  if (level == Level.Hard) {
    for (int i = 0; i < 18; i++) {
      cardStateArray.add(true);
    }
  } else if (level == Level.Medium) {
    for (int i = 0; i < 12; i++) {
      cardStateArray.add(true);
    }
  } else if (level == Level.Easy) {
    for (int i = 0; i < 6; i++) {
      cardStateArray.add(true);
    }
  }
  return cardStateArray;
}

List<GlobalKey<FlipCardState>> getCardKeys(Level level) {
  List<GlobalKey<FlipCardState>> cardStateKeys = [];
  if (level == Level.Hard) {
    for (int i = 0; i < 18; i++) {
      cardStateKeys.add(GlobalKey<FlipCardState>());
    }
  }
  if (level == Level.Medium) {
    for (int i = 0; i < 12; i++) {
      cardStateKeys.add(GlobalKey<FlipCardState>());
    }
  }
  if (level == Level.Easy) {
    for (int i = 0; i < 6; i++) {
      cardStateKeys.add(GlobalKey<FlipCardState>());
    }
  }
  return cardStateKeys;
}
