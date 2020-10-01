import 'package:ammaratef45Flutter/custom_widgets/error.dart';
import 'package:ammaratef45Flutter/custom_widgets/header.dart';
import 'package:ammaratef45Flutter/custom_widgets/home_body.dart';
import 'package:ammaratef45Flutter/custom_widgets/loading.dart';
import 'package:ammaratef45Flutter/custom_widgets/menu_bar.dart';
import 'package:ammaratef45Flutter/models/myinfo.dart';
import 'package:ammaratef45Flutter/services/info_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final InfoService infoService = InfoService.instance;
  @override
  Widget build(BuildContext context) {
    infoService.getMyInfo();
    return Scaffold(
      body: FutureBuilder<MyInfo>(
          future: infoService.getMyInfo(),
          builder: (context, snapshot) {
            if (snapshot.hasError)
              return ErrorView(error: snapshot.error.toString());
            if (!snapshot.hasData) return LoadingView();
            return SingleChildScrollView(
              child: Column(
                children: [
                  MenuBar(
                    myInfo: snapshot.data,
                  ),
                  Header(
                    myInfo: snapshot.data,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  HomeBody(
                    myInfo: snapshot.data,
                  ),
                ],
              ),
            );
          }),
    );
  }
}
