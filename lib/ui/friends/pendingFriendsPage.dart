import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:habit/controllers/UserControl.dart';
import 'package:habit/model/Person.dart';
import 'package:habit/ui/widgets/generic/Loading.dart';
import 'package:habit/ui/widgets/generic/Toast.dart';

class PendingFriendsPage extends StatefulWidget {
  @override
  _PendingFriendsPageState createState() => _PendingFriendsPageState();
}

class _PendingFriendsPageState extends State<PendingFriendsPage> {
  bool isEmpty = false;
  List<Person> pendingPersons = [];
  List<Person> addPersons = [];

  @override
  void initState() {
    super.initState();

    getData();
  }

  void getData() async {
    if (await UserControl().isLogged()) {
      Loading.showLoading(context);
      UserControl().getPendingFriends().then((friends) async {
        if (friends.length == 0) {
          isEmpty = true;
          await UserControl().setPendingFriendsStatus(false);
        } else {
          pendingPersons = friends;
          pendingPersons.sort((a, b) => a.name.compareTo(b.name));
        }
        Loading.closeLoading(context);
        setState(() {});
      }).catchError((_) {
        Loading.closeLoading(context);
        showToast("Ocorreu um erro");
        isEmpty = true;
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, addPersons);
        return Future.value(false);
      },
      child: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 40, bottom: 16),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 50,
                    child: BackButton(),
                  ),
                  Expanded(
                    child: Text(
                      "Solicitações de amizade",
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                ],
              ),
            ),
            isEmpty
                ? Text(
                    "Não tem nenhuma amizade pendente",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 22.0, color: Colors.black.withOpacity(0.2)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 20),
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: pendingPersons.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return Container(
                        height: 90,
                        width: double.maxFinite,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 19),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            pendingPersons[index].name != null
                                                ? pendingPersons[index].name
                                                : "",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              decoration:
                                                  pendingPersons[index].you
                                                      ? TextDecoration.underline
                                                      : TextDecoration.none,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            pendingPersons[index].email != null
                                                ? pendingPersons[index].email
                                                : "",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    FloatingActionButton(
                                        child: Icon(Icons.close),
                                        mini: true,
                                        heroTag: null,
                                        backgroundColor: Colors.red,
                                        elevation: 0,
                                        onPressed: () {
                                          Loading.showLoading(context);
                                          UserControl()
                                              .declineRequest(
                                                  pendingPersons[index].uid)
                                              .then((_) {
                                            Loading.closeLoading(context);
                                            pendingPersons.removeAt(index);
                                            if (pendingPersons.length == 0) {
                                              isEmpty = true;
                                              UserControl()
                                                  .setPendingFriendsStatus(
                                                      false);
                                            }
                                            setState(() {});
                                          }).catchError((error) {
                                            Loading.closeLoading(context);
                                            if (error
                                                is CloudFunctionsException) {
                                              if (error.details == true) {
                                                showToast(error.message);
                                                return;
                                              }
                                            }
                                            showToast("Ocorreu um erro");
                                          });
                                        }),
                                    SizedBox(width: 8),
                                    FloatingActionButton(
                                        child: Icon(Icons.check),
                                        mini: true,
                                        heroTag: null,
                                        backgroundColor: Colors.green,
                                        elevation: 0,
                                        onPressed: () {
                                          Loading.showLoading(context);
                                          UserControl()
                                              .acceptRequest(
                                                  pendingPersons[index].uid)
                                              .then((_) {
                                            Loading.closeLoading(context);
                                            addPersons
                                                .add(pendingPersons[index]);
                                            pendingPersons.removeAt(index);
                                            if (pendingPersons.length == 0) {
                                              isEmpty = true;
                                              UserControl()
                                                  .setPendingFriendsStatus(
                                                      false);
                                            }
                                            setState(() {});
                                          }).catchError((error) {
                                            Loading.closeLoading(context);
                                            if (error
                                                is CloudFunctionsException) {
                                              if (error.details == true) {
                                                showToast(error.message);
                                                return;
                                              }
                                            }
                                            showToast("Ocorreu um erro");
                                          });
                                        }),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 1,
                              width: double.maxFinite,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(color: Colors.black12),
                            ),
                          ],
                        ),
                      );
                    },
                  )
          ],
        ),
      ),
    );
  }
}
