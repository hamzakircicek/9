
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/ilkekran.dart';
import 'package:toast/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/mesajSayfa.dart';
import 'package:toast/toast.dart';
class mesajSayfa extends StatefulWidget {
  String kullanici;
  String adim;
   String karsiUid;
   String uid;
   String dc;
   var pp;
   var karsiPp;

  mesajSayfa({this.kullanici,this.adim,this.karsiUid, this.uid,this.dc,this.pp,this.karsiPp});
  @override
  _mesajSayfaState createState() => _mesajSayfaState();
}
String e;
bool ben=false;
FirebaseFirestore _firestore=FirebaseFirestore.instance;
FirebaseAuth _auth=FirebaseAuth.instance;

class _mesajSayfaState extends State<mesajSayfa> {
  String email=_auth.currentUser.email;
  String r;
  var karsiP;
  bool gorulme=false;
  String clr;
  TextEditingController txt=new TextEditingController();
  int gelenBildirim=0;
  int gidenBildirim=0;
@override
  void initState() {
    r=widget.dc;
    karsiP=widget.karsiPp;
    _firestore.collection('mesaj').doc(r).collection('ic').where('gorulme', isEqualTo: false).where("kullanici", isEqualTo: _auth.currentUser.displayName).get().then((value) {


      for(var i in value.docs){
        _firestore.collection('mesaj').doc(r).collection('ic').doc(i.id).update({'gorulme':true});

      }

    });

    super.initState();
    setState(() {
      gidenBildirim=0;
    });
  }
  @override
  Widget build(BuildContext context) {

    DateTime now = DateTime.now();

   String saat= now.hour.toString();
   String dk=now.minute.toString();

    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
          title:Text(_auth.currentUser.displayName==widget.kullanici?widget.adim:widget.kullanici,style: TextStyle(color: Colors.black87,fontSize: 17),) ,
        ),
        body: StreamBuilder(

                 stream: _firestore.collection('mesaj').doc(r).collection('ic').orderBy("now", descending: true).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.data == null) {
                      return CircularProgressIndicator();
                    }
                    return ListView(

                      children: [
                        Container(
                          height: 510,
                          child: ListView.builder(
                              reverse: true,
                              scrollDirection: Axis.vertical,
                                  itemCount: snapshot.data.docs.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    DocumentSnapshot doc = snapshot.data.docs[index];
                                    return dondur(doc['icerik'], doc['saat'], doc['dakika'],
                                      doc['gorulme'], doc['gonderenAd']);
                                  }


                              ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 20,right: 20),
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.bottomCenter,
                          child: Row(

                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(

                                child: Padding(
                                  padding: const EdgeInsets.only(bottom:8.0),
                                  child: TextField(

                                    controller: txt,
                                    decoration: InputDecoration(

                                      hintText: "Birşeyler Yaz",


                                    ),


                                  ),
                                ),
                              ),

                              Container(
                                child: IconButton(icon: Icon(Icons.send), onPressed: () async{
                                  if(txt.text==""){
                                    Toast.show(
                                        "Lütfen Birşeyler Yazın",
                                        context,
                                        duration: Toast
                                            .LENGTH_LONG,
                                        gravity: Toast
                                            .BOTTOM);
                                  }else{
                                    await _firestore.collection('mesaj').doc(r).collection('ic').where('gorulme', isEqualTo: false).
                                    where("gonderenAd", isEqualTo: _auth.currentUser.displayName).get().then((value) {
                                      gidenBildirim=value.docs.length+1;
                                    });
                                    mesajj(false,now,saat,dk,karsiP,_auth.currentUser.photoURL,widget.dc,_auth.currentUser.email,ben, _auth.currentUser.uid,
                                        _auth.currentUser.uid==widget.karsiUid?widget.uid:widget.karsiUid, txt.text,
                                        _auth.currentUser.displayName==widget.kullanici?widget.adim:widget.kullanici,_auth.currentUser.displayName);


                                    mesajjSyf(false,txt.text,now,saat,dk,karsiP,_auth.currentUser.photoURL,_auth.currentUser.displayName,_auth.currentUser.displayName==widget.kullanici?widget.adim:widget.kullanici,
                                      widget.dc,_auth.currentUser.uid,_auth.currentUser.uid==widget.karsiUid?widget.uid:widget.karsiUid,_auth.currentUser.email,);}
                                  if (!mounted) return;
                                  setState(() {

                                    txt.text="";

                                  });

                                }),
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  }),


         );
  }
  void mesajj(bool gorulme, nw,saatt,dk,karsiPp,pp,String docId,String gonderenEmail,bool onayDurumu,String uid,String karsiUid,String icerik,String kullanici,String gonderenAd) async{
    try{

      Map<String, dynamic> aktar= Map();

      aktar['gidenBildirim']=gidenBildirim;
      aktar['gorulme']=gorulme;
      aktar['now']=nw;
      aktar['saat']=saatt;
      aktar['dakika']=dk;
      aktar['karsiPp']=karsiPp;
      aktar['pp']=pp;
      aktar['docId']=docId;
      aktar['gonderenEmail']=gonderenEmail;
      aktar['onayDurumu']=onayDurumu;
      aktar['uid']=uid;
      aktar['karsiUid']=karsiUid;
      aktar['icerik']=icerik;
      aktar['kullanici']=kullanici;
      aktar['gonderenAd']=gonderenAd;
      await _firestore.collection('mesaj').doc(r).collection('ic').doc().set(aktar, SetOptions(merge: true));

    }catch(e){
      debugPrint(e);
    }
  }
  void mesajjSyf(bool gorulme,String icerik,nw,saatt,dk,karsiPp,pp,String gonderenAd,String kullanici,String docId,String uid,String karsiUid,String gonderenEmail) async{
    try{

      Map<String, dynamic> aktar= Map();
      aktar['gorulme']=gorulme;
      aktar['gidenBildirim']=gidenBildirim;
      aktar['icerik']=icerik;
      aktar['now']=nw;
      aktar['saat']=saatt;
      aktar['dakika']=dk;
      aktar['karsiPp']=karsiPp;
      aktar['pp']=pp;
      aktar['gonderenAd']=gonderenAd;
      aktar['kullanici']=kullanici;
      aktar['docId']=docId;
      aktar['uid']=uid;
      aktar['karsiUid']=karsiUid;
      aktar['gonderenEmail']=gonderenEmail;
      await _firestore.collection('mesajSyf').doc(r).set(aktar, SetOptions(merge: false));

    }catch(e){
      debugPrint(e);
    }
  }
  Widget dondur(String icerik, saat, dk, gorulme,gonderen){

    if(gonderen==_auth.currentUser.displayName) {
               return

             Container(

             alignment: Alignment.centerRight,
             child: Column(

             children: [
             Container(
             constraints: BoxConstraints(maxWidth: 225),
             margin: EdgeInsets.all(4),
             padding: EdgeInsets.all(10),
             decoration: BoxDecoration(
             borderRadius: BorderRadius.circular(15),
             gradient: LinearGradient(
             colors: [ Colors.green, Colors.teal.shade800]

             ),
             ),
             child: Column(
             children: [
             Text(

             icerik,
             style: TextStyle(color: Colors.white),

    ),

    Container(
    alignment: Alignment.bottomRight,

    child: Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
    Text(saat == "0" ? "00" + ":" +
    dk : saat + ":" +
    dk, style: TextStyle(
    color: Colors.white70, fontSize: 9,)),
    SizedBox(width: 5,),
    Icon(gorulme == false ? Icons
        .done_all_rounded : Icons
        .done_all_rounded,
    color: gorulme == false ? Colors
        .grey : Colors.lightBlue, size: 15,)
    ],
    ),
    ),
    ],
    ),
    ),

    ],
    ),
    );
    }
    else{
      return Column(

      children: [
      Container(
      constraints:BoxConstraints(maxWidth: 225),
      margin: EdgeInsets.all(4),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      gradient: LinearGradient(
      colors: [ Colors.blue,Colors.indigoAccent]

      ),
      ),
      child: Column(
      children: [
      Text(
      icerik, style: TextStyle(color: Colors.white),
      ),
      SizedBox(height: 8,),
      Text(saat=="0" ?"00"+":"+dk :saat+":"+dk,style: TextStyle(color: Colors.white70,fontSize: 9,)),
      ],
      ),
      ),

      ],
      crossAxisAlignment: CrossAxisAlignment.start,
      );

    }
    }


}
