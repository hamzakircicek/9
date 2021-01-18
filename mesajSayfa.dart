


import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/bottom.dart';
import 'package:flutter_app/mesaj.dart';
import 'package:toast/toast.dart';
class mesajSayfasi extends StatefulWidget {
  String docc;
  mesajSayfasi({this.docc});

  @override
  _mesajSayfasiState createState() => _mesajSayfasiState();
}
FirebaseFirestore _firestore=FirebaseFirestore.instance;
FirebaseAuth _auth=FirebaseAuth.instance;
User user;


class _mesajSayfasiState extends State<mesajSayfasi> {
  var karsi;
  String email;
  var uid;
  var karsiUid;
  int f;
  var userPhoto;
  var userName;
  String pp;
  String ad;
  int bildirim=0;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firestore.collection('mesajSyf').where('kullanici', isEqualTo: _auth.currentUser.displayName).where('gorulme', isEqualTo: false).get().then((event) {
      for(var i in event.docs){
        _firestore.collection('mesajSyf').doc(i.id).update({'gorulme':true});
      }
    });
  }
  var url;
@override
  Widget build(BuildContext context) {



    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.blueGrey,
        ),
        leading:
        IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>bottom()));}



        ),
      ),


      body:
 Container(
      child: StreamBuilder(
          stream: _firestore.collection('mesajSyf').snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            return Container(
              child: Column(
                  children: snapshot.data.docs.map((e) {
                    karsi = e['kullanici'];

                    if (_auth.currentUser.uid.toString() == e['uid'] ||
                        _auth.currentUser.uid.toString() == e['karsiUid']) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                            onTap: () {
                              _firestore.collection('mesajSyf').where('gidenBildirim', isGreaterThan: 0  ).get().then((value) {
                                setState(() {
                                  _firestore.collection('mesajSyf').doc(e['docId']).update({'gidenBildirim':0});
                                });




                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>
                                      mesajSayfa(pp: e['pp'],
                                        kullanici: e['kullanici'],
                                        adim: e['gonderenAd'],
                                        karsiUid: e['karsiUid'],
                                        uid: e['uid'],
                                        dc: e['docId'],)));
                            },
                            child: Container(
                              child: Card(
                                child: ListTile(
                                  leading: Container(width: 40, height: 40,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              40),
                                          image: DecorationImage(
                                            image: NetworkImage("https://cdn2.iconfinder.com/data/icons/flat-mini-1/128/message_failed-512.png"),
                                            fit: BoxFit.cover,)
                                      )
                                  ),

                                  title: Text(e['gonderenAd'] ==
                                      _auth.currentUser.displayName
                                      ? e['kullanici']
                                      : e['gonderenAd']),
                                  subtitle:  RichText(
                                    overflow: TextOverflow
                                        .ellipsis,
                                    strutStyle: StrutStyle(
                                        fontSize: 12.0),
                                    text: TextSpan(
                                        style: TextStyle(
                                            color: Colors
                                                .grey),
                                        text: e['icerik']),
                                  ),
                                  trailing: Column(
                                    children: [
                                      Container(

                                        width: e['kullanici']==_auth.currentUser.displayName && e['gidenBildirim']!=0?25:0,
                                        height:  e['kullanici']==_auth.currentUser.displayName && e['gidenBildirim']!=0?25:0,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          color: Colors.green
                                        ),
                                        child: Center(child: Text(e["gidenBildirim"].toString(),style: TextStyle(color: Colors.white),)),
                                      ),
                                      SizedBox(height: 5,),
                                      Text(e['saat']+":"+e['dakika'],style: TextStyle(color: Colors.grey),),
                                    ],
                                  ),
                                ),
                              ),
                            )),
                      );
                    } else {
                      return Container();
                    }
                  }).toList()

              ),
            );
          })

    )
  );



  }



}
