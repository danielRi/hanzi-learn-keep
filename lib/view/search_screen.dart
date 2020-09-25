import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hanzi_learn_keep/bloc/search_bloc.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _bloc = SearchBloc();
    return BlocProvider<SearchBloc>(
      lazy: false,
      create: (context) {
        return _bloc..add(SearchInitEvent());
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: TextField(
                  autocorrect: false,
                  style: TextStyle(
                    fontSize: 28,
                  ),
                  decoration: InputDecoration(
                    focusColor: Colors.black,
                    hintStyle: TextStyle(
                      fontFamily: "SentyWen",
                      fontSize: 28,
                    ),
                    hintText: '尋找',
                  ),
                  controller: TextEditingController(),
                  onChanged: (value) async {
                    print("value: ");
                    print("value");
                    _bloc.add(SearchStringEvent(text: value));
                    print("after");
                  },
                ),
              ),
            ],
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              if (state is DataState) {
                return Container(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: state.list.length,
                    itemBuilder: (BuildContext context, int index) {
                      final listElement = state.list[index];
                      return Card(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 18.0, horizontal: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    listElement.frame.keyWord,
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontFamily: "FreeSerif",
                                    ),
                                  ),
                                  Text(
                                    listElement.frame.frameNumber,
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontFamily: "FreeSerif",
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    listElement.frame.characterTraditional,
                                    style: TextStyle(
                                      fontSize: 48,
                                    ),
                                  ),
                                  listElement.statistic != null
                                      ? RichText(
                                          text: TextSpan(
                                            style: new TextStyle(
                                              fontSize: 28.0,
                                              color: Colors.black,
                                              fontFamily: "FreeSerif",
                                            ),
                                            children: [
                                              TextSpan(
                                                text: listElement.statistic.seen
                                                        .toString() +
                                                    "/",
                                              ),
                                              TextSpan(
                                                text: listElement
                                                    .statistic.correct
                                                    .toString(),
                                                style: TextStyle(
                                                  color: Colors.green[600],
                                                ),
                                              ),
                                              TextSpan(
                                                text: "/",
                                              ),
                                              listElement.statistic.wrong > 0
                                                  ? TextSpan(
                                                      text: listElement
                                                          .statistic.wrong
                                                          .toString(),
                                                      style: TextStyle(
                                                        color: Colors.red[900],
                                                      ),
                                                    )
                                                  : TextSpan(
                                                      text: "-",
                                                    )
                                            ],
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return Center(
                  child: SpinKitPouringHourglass(color: Colors.black),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
