import 'package:flutter/cupertino.dart';
import 'package:equatable/equatable.dart';

import '../model/tinder_model.dart';

@immutable
abstract class TinderState extends Equatable {}

//data loading state
class TinderLoadingState extends TinderState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class TinderLoadedState extends TinderState {
  TinderLoadedState(this.users);
  List<TinderModel> users;
  @override
  // TODO: implement props
  List<Object?> get props => [users];
}

class TinderErrorState extends TinderState {
  TinderErrorState(this.error);
  final String error;
  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
