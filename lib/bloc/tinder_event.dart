import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class TinderEvent extends Equatable {
  const TinderEvent();
}

class TinderLoadEvent extends TinderEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
