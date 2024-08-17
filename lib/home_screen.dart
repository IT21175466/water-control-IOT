import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:watercontroliot/bloc/home_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final currentHour = DateTime.now().hour;
  String greeting = '';
  String status = '';

  HomeBloc _homeBloc = HomeBloc();

  final Future<FirebaseApp> _fApp = Firebase.initializeApp();
  double waterLevel = 0;
  double tankHeightInCm = 6;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    if (currentHour < 12) {
      greeting = 'Good Morning';
    } else if (currentHour < 18) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: _homeBloc,
      listener: (context, state) {
        if (state is WaterRequestingState) {
          isLoading = true;
        } else if (state is WaterRequestingSucessState) {
          isLoading = false;
        } else if (state is WaterRequestingErrorState) {
          isLoading = false;
        }
      },
      builder: (context, state) {
        return FutureBuilder(
            future: _fApp,
            builder: (context, snapshot) {
              DatabaseReference _databaseReference =
                  FirebaseDatabase.instance.ref("level");

              _databaseReference.onValue.listen(
                (event) {
                  setState(() {
                    waterLevel = (tankHeightInCm -
                            double.parse(event.snapshot.value.toString())) /
                        tankHeightInCm;
                  });
                },
              );
              return Scaffold(
                appBar: AppBar(
                  title: Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          image: DecorationImage(
                            image: AssetImage('assets/images/profile_img.jpeg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hi, ${greeting}',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'IOT Water Manager',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Icon(
                        Icons.menu,
                      ),
                    ],
                  ),
                ),
                body: Stack(
                  children: [
                    Container(
                      height: screenHeight,
                      width: screenWidth,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          // Container(
                          //   height: 60,
                          //   width: screenWidth,
                          //   padding: EdgeInsets.symmetric(horizontal: 10),
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(15),
                          //     border: Border.all(
                          //       color: Colors.grey.withOpacity(0.6),
                          //     ),
                          //     image: DecorationImage(
                          //       image: AssetImage(
                          //           'assets/images/current_status_BG.jpg'),
                          //       fit: BoxFit.cover,
                          //       opacity: 0.5,
                          //     ),
                          //   ),
                          //   child: Row(
                          //     children: [
                          //       Column(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           Text(
                          //             'වත්මන් තත්ත්වය:',
                          //             style: TextStyle(
                          //               color: Colors.black,
                          //               fontSize: 13,
                          //             ),
                          //           ),
                          //           Text(
                          //             status,
                          //             style: TextStyle(
                          //               color: Colors.blue,
                          //               fontSize: 18,
                          //               fontWeight: FontWeight.w700,
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //       // Spacer(),
                          //       // Image.asset(
                          //       //   'assets/icons/check_mark.png',
                          //       //   height: 30,
                          //       // ),
                          //     ],
                          //   ),
                          // ),
                          // SizedBox(
                          //   height: 15,
                          // ),
                          Row(
                            children: [
                              Container(
                                width: screenWidth / 3 * 2 - 40,
                                height: 350,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 20,
                                      width: screenWidth / 3 * 2 - 100,
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 48, 53, 48),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                    ),
                                    Container(
                                      height: 15,
                                      width: screenWidth / 3 * 2 - 30,
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 48, 53, 48),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                    ),
                                    Container(
                                      height: 275,
                                      width: screenWidth / 3 * 2 - 78,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border(
                                          right: BorderSide(
                                            color: const Color.fromARGB(
                                                255, 48, 53, 48),
                                          ),
                                          left: BorderSide(
                                            color: const Color.fromARGB(
                                                255, 48, 53, 48),
                                          ),
                                        ),
                                      ),
                                      child: LiquidCustomProgressIndicator(
                                        value: waterLevel,
                                        valueColor:
                                            AlwaysStoppedAnimation(Colors.blue),
                                        backgroundColor: Colors.white,
                                        direction: Axis.vertical,
                                        shapePath: _buildBoatPath(
                                            screenWidth / 3 * 2 - 80),
                                      ),
                                    ),
                                    Container(
                                      height: 15,
                                      width: screenWidth / 3 * 2 - 40,
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 48, 53, 48),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5),
                                          topRight: Radius.circular(5),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          height: 25,
                                          width: 20,
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 48, 53, 48),
                                          ),
                                        ),
                                        Spacer(),
                                        Container(
                                          height: 25,
                                          width: 15,
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 48, 53, 48),
                                          ),
                                        ),
                                        Spacer(),
                                        Container(
                                          height: 25,
                                          width: 20,
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 48, 53, 48),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              SizedBox(
                                width: screenWidth / 3 * 1 - 40,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'ජල මට්ටම',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      '${(waterLevel * 100).toStringAsFixed(0)}%',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 40,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                          Spacer(),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _homeBloc.add(WaterRequesingEvent(
                                      wellWater: 1, waterBoard: 0));
                                },
                                child: Container(
                                  height: 120,
                                  width: screenWidth / 2 - 15,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: Image.asset(
                                                'assets/icons/water_well.png',
                                                height: 45,
                                              ),
                                            ),
                                            Text(
                                              'ලිං ජලය',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 23,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Text(
                                              'ලබාගන්න',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  _homeBloc.add(WaterRequesingEvent(
                                      wellWater: 0, waterBoard: 1));
                                },
                                child: Container(
                                  height: 120,
                                  width: screenWidth / 2 - 15,
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 11, 105, 245),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: Image.asset(
                                                'assets/icons/gate_valve.png',
                                                height: 45,
                                              ),
                                            ),
                                            Text(
                                              'නල ජලය',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 23,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Text(
                                              'ලබාගන්න',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(
                            height: 10,
                          ),
                          // Row(
                          //   children: [
                          //     Container(
                          //       height: 120,
                          //       width: screenWidth / 2 - 15,
                          //       padding: EdgeInsets.symmetric(horizontal: 15),
                          //       decoration: BoxDecoration(
                          //         color: Color.fromARGB(255, 113, 153, 255),
                          //         borderRadius: BorderRadius.circular(15),
                          //       ),
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           SizedBox(
                          //             height: 10,
                          //           ),
                          //           Align(
                          //             alignment: Alignment.topRight,
                          //             child: Image.asset(
                          //               'assets/icons/mix_water.png',
                          //               height: 45,
                          //             ),
                          //           ),
                          //           Text(
                          //             'මිශ්‍ර ජලය',
                          //             style: TextStyle(
                          //               color: Colors.white,
                          //               fontSize: 23,
                          //               fontWeight: FontWeight.w700,
                          //             ),
                          //           ),
                          //           Text(
                          //             'ලබාගන්න',
                          //             style: TextStyle(
                          //               color: Colors.white,
                          //               fontSize: 13,
                          //               fontWeight: FontWeight.w500,
                          //             ),
                          //           ),
                          //           SizedBox(
                          //             height: 5,
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //     Spacer(),
                          //     Container(
                          //       height: 120,
                          //       width: screenWidth / 2 - 15,
                          //       padding: EdgeInsets.symmetric(horizontal: 15),
                          //       decoration: BoxDecoration(
                          //         color: Colors.redAccent,
                          //         borderRadius: BorderRadius.circular(15),
                          //       ),
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           SizedBox(
                          //             height: 10,
                          //           ),
                          //           Align(
                          //             alignment: Alignment.topRight,
                          //             child: Image.asset(
                          //               'assets/icons/water_closed.png',
                          //               height: 45,
                          //             ),
                          //           ),
                          //           Spacer(),
                          //           Text(
                          //             'සියලුම කරාම',
                          //             style: TextStyle(
                          //               color: Colors.white,
                          //               fontSize: 20,
                          //               fontWeight: FontWeight.w700,
                          //             ),
                          //           ),
                          //           Text(
                          //             'වසා දමන්න',
                          //             style: TextStyle(
                          //               color: Colors.white,
                          //               fontSize: 13,
                          //               fontWeight: FontWeight.w500,
                          //             ),
                          //           ),
                          //           Spacer(),
                          //         ],
                          //       ),
                          //     ),
                          //   ],
                          // ),

                          // Container(
                          //   height: 65,
                          //   width: screenWidth,
                          //   padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          //   decoration: BoxDecoration(
                          //     color: Color.fromARGB(255, 113, 153, 255),
                          //     borderRadius: BorderRadius.circular(15),
                          //   ),
                          //   child: Row(
                          //     crossAxisAlignment: CrossAxisAlignment.end,
                          //     children: [
                          //       Text(
                          //         'මිශ්‍ර ජලය',
                          //         style: TextStyle(
                          //           color: Colors.white,
                          //           fontSize: 25,
                          //           fontWeight: FontWeight.w700,
                          //         ),
                          //       ),
                          //       SizedBox(
                          //         width: 5,
                          //       ),
                          //       Text(
                          //         'ලබාගන්න',
                          //         style: TextStyle(
                          //           color: Colors.white,
                          //           fontSize: 13,
                          //           fontWeight: FontWeight.w500,
                          //         ),
                          //       ),
                          //       Spacer(),
                          //       Align(
                          //         alignment: Alignment.centerRight,
                          //         child: Image.asset(
                          //           'assets/icons/mix_water.png',
                          //           height: 45,
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          GestureDetector(
                            onTap: () {
                              _homeBloc.add(WaterRequesingEvent(
                                  wellWater: 0, waterBoard: 0));
                            },
                            child: Container(
                              height: 60,
                              width: screenWidth,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Colors.transparent,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            Spacer(),
                                            Text(
                                              'සියලුම ජල කරාම වසා දමන්න.',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Spacer(),
                                          ],
                                        ),
                                        Spacer(),
                                        Spacer(),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Image.asset(
                                            'assets/icons/water_closed.png',
                                            height: 40,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                    isLoading
                        ? Container(
                            height: screenHeight,
                            width: screenWidth,
                            color: Colors.black.withOpacity(0.6),
                            child: Column(
                              children: [
                                Spacer(),
                                Text(
                                  'සකසමින්......',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              );
            });
      },
    );
  }

  _buildBoatPath(double tankWidth) {
    final path = Path();
    path.addRect(Rect.fromLTWH(0, 0, tankWidth, 275));
    return path;
  }
}
