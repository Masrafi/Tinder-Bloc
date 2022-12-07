import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:swipable_stack/swipable_stack.dart';
import '../bloc/tinder_bloc.dart';
import '../bloc/tinder_event.dart';
import '../bloc/tinder_state.dart';
import '../model/tinder_model.dart';
import '../repo/tinder_repo.dart';
import '../widget/bottom_rpws.dart';
import '../widget/card_overlay.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final SwipableStackController _controller;

  void _listenController() => setState(() {
        //getData();
      });

  @override
  void initState() {
    super.initState();
    getData();
    _controller = SwipableStackController()..addListener(_listenController);
  }

  List imageAll = [];
  List indexAll = [];
  List titleAll = [];
  Future getData() async {
    print(imageAll);
    Response response =
        await get(Uri.parse("https://fakestoreapi.com/products"));
    print(response.statusCode);
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);

      //ADD Following lines to your code.

      for (int i = 0; i < data.length; i++) {
        setState(() {
          imageAll.add(data[i]["image"].toString());
          indexAll.add(data[i]["id"].toString());
          titleAll.add(data[i]["title"].toString());
        });
      }
      if (kDebugMode) {
        print(imageAll);
      }
    } else {
      if (kDebugMode) {
        print("Failed");
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller
      ..removeListener(_listenController)
      ..dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider(
      create: (context) => TinderBloc(
        RepositoryProvider.of<RepositoryTinder>(context),
      )..add(TinderLoadEvent()),
      child: Scaffold(
        body: BlocBuilder<TinderBloc, TinderState>(builder: (context, state) {
          if (state is TinderLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is TinderErrorState) {
            return const Center(
              child: Text("Error"),
            );
          }

          if (state is TinderLoadedState) {
            List<TinderModel> dataList = state.users;
            for (int i = 0; i < dataList.length; i++) {
              imageAll.add(dataList[i].image.toString());
              indexAll.add(dataList[i].id.toString());
              titleAll.add(dataList[i].title.toString());
            }
            return SafeArea(
              top: false,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: SwipableStack(
                        detectableSwipeDirections: const {
                          SwipeDirection.right,
                          SwipeDirection.left,
                          SwipeDirection.up,
                          SwipeDirection.down,
                        },
                        controller: _controller,
                        stackClipBehaviour: Clip.none,
                        onSwipeCompleted: (indexAll, direction) {
                          if (kDebugMode) {
                            print('$indexAll, $direction');
                          }
                        },
                        horizontalSwipeThreshold: 0.8,
                        verticalSwipeThreshold: 0.8,
                        builder: (context, properties) {
                          final itemIndex = properties.index % imageAll.length;

                          return Stack(
                            children: [
                              // ExampleCard(
                              //   name: 'Sample No.${itemIndex + 1}',
                              //   assetPath: _images[itemIndex],
                              // ),
                              //show image & text
                              ClipRRect(
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                imageAll[itemIndex]),
                                            fit: BoxFit.cover,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              offset: const Offset(0, 2),
                                              blurRadius: 26,
                                              color: Colors.black
                                                  .withOpacity(0.08),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        height: 200,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              const BorderRadius.vertical(
                                            bottom: Radius.circular(14),
                                          ),
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: <Color>[
                                              Colors.black12.withOpacity(0),
                                              Colors.black12.withOpacity(.4),
                                              Colors.black12.withOpacity(.82),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${indexAll[itemIndex]}',
                                            style: theme.textTheme.headline6!
                                                .copyWith(
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            '${titleAll[itemIndex]}',
                                            style: theme.textTheme.headline6!
                                                .copyWith(
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(
                                              height: BottomButtonsRow.height)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // more custom overlay possible than with overlayBuilder
                              if (properties.stackIndex == 0 &&
                                  properties.direction != null)
                                CardOverlay(
                                  swipeProgress: properties.swipeProgress,
                                  direction: properties.direction!,
                                )
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  BottomButtonsRow(
                    onSwipe: (direction) {
                      _controller.next(swipeDirection: direction);
                    },
                    onRewindTap: _controller.rewind,
                    canRewind: _controller.canRewind,
                  ),
                ],
              ),
            );
          }
          return Container();
        }),
      ),
    );
  }
}

// const _images = [
//   'assets/image1.jpeg',
//   'assets/image2.jpeg',
//   'assets/image3.jpeg',
//   'assets/image4.jpeg',
// ];
