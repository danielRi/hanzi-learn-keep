import "package:charcode/charcode.dart";
import "package:charcode/html_entity.dart";
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hanzi_learn_keep/bloc/statistic_bloc.dart';
import 'package:hanzi_learn_keep/view/search_screen.dart';
import 'package:hanzi_learn_keep/view/study_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: BlocBuilder<StatisticBloc, StatisticState>(
            builder: (context, state) {
              if (state is StatisticDataState) {
                if (state.hasData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 18.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                state.framesStudied.toString() + " 個漢字學過了",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontFamily: "SentyWen",
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      state.worstFrameStatistic.wrong > 0
                          ? Card(
                              child: Container(
                                height: 150,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 18.0,
                                  horizontal: 8.0,
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "最經常忘記了 (${state.worstFrameStatistic.wrong}/${state.worstFrameStatistic.seen} 次)",
                                      style: TextStyle(
                                          fontSize: 28, fontFamily: "SentyWen"),
                                    ),
                                    Text(
                                      state.worstFrame.keyWord,
                                      style: TextStyle(
                                        fontSize: 48,
                                        fontFamily: "FreeSerif",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                      Card(
                        child: Container(
                          height: 150,
                          padding: const EdgeInsets.symmetric(vertical: 18.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "成功率",
                                style: TextStyle(
                                    fontSize: 28, fontFamily: "SentyWen"),
                              ),
                              Text(
                                state.globalSuccessRate.toString() + " %",
                                style: TextStyle(
                                  fontSize: 48,
                                  fontFamily: "FreeSerif",
                                  color: _colorForSuccessRate(
                                      state.globalSuccessRate),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Center(
                    child: Text(
                      "還沒數據，你先學習吧",
                      style: TextStyle(fontSize: 28, fontFamily: "SentyWen"),
                    ),
                  );
                }
              } else {
                return Center(
                  child: SpinKitPouringHourglass(color: Colors.black),
                );
              }
            },
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        backgroundColor: Colors.black,
        child: Center(
          child: Text(
            "字",
            style: TextStyle(
              fontSize: 26,
              fontFamily: "SentyWen",
            ),
          ),
        ),
        children: [
          SpeedDialChild(
              child: Center(
                child: Text(
                  "學",
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: "SentyWen",
                  ),
                ),
              ),
              backgroundColor: Colors.black,
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudyScreen(50),
                  ),
                );
                BlocProvider.of<StatisticBloc>(context).add(InitEvent());
              }),
          SpeedDialChild(
            child: Center(
              child: Icon(
                Icons.search,
              ),
            ),
            backgroundColor: Colors.black,
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Color _colorForSuccessRate(int successRate) {
    if (successRate == 100) {
      return Colors.green[800];
    } else if (successRate > 96) {
      return Colors.green[700];
    } else if (successRate > 92) {
      return Colors.green[500];
    } else if (successRate > 88) {
      return Colors.yellow[600];
    } else if (successRate > 79) {
      return Colors.yellow[900];
    } else {
      return Colors.red[900];
    }
  }
}
