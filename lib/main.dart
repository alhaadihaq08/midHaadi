import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Dosen>> fetchMhss(http.Client client) async {
  final response =
      await client.get('https://mobileteknologi.000webhostapp.com/readDatajson.php');

  // Use the compute function to run parseMhss in a separate isolate.
  return compute(parseMhss, response.body);
}

// A function that converts a response body into a List<Mhs>.
List<Dosen> parseMhss(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Dosen>((json) => Dosen.fromJson(json)).toList();
}

class Dosen {
  final String nip;
  final String nama_pegawai;
  final String depatemen;
  final String jabatan;
  final String pendidikan_terakhir;

  Dosen({this.nip, this.nama_pegawai, this.depatemen, this.jabatan, this.pendidikan_terakhir});

  factory Dosen.fromJson(Map<String, dynamic> json) {
    return Dosen(
      nip: json['nip'] as String,
      nama_pegawai: json['nama_pegawai'] as String,
      depatemen: json['depatemen'] as String,
      jabatan: json['jabatan'] as String,
      pendidikan_terakhir: json['pendidikan_terakhir'] as String,
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Data Pegawai';

    return MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<List<Dosen>>(
        future: fetchMhss(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? DosensList(DosenData: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class DosensList extends StatelessWidget {
  final List<Dosen> DosenData;

  DosensList({Key key, this.DosenData}) : super(key: key);



Widget viewData(var data,int index)
{
return Container(
    width: 200,
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.green,
      elevation: 10,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
            //ClipRRect(
              //      borderRadius: BorderRadius.only(
                //      topLeft: Radius.circular(8.0),
                  //    topRight: Radius.circular(8.0),
                   // ),
                   // child: Image.network(
                    //    "https://elearning.binadarma.ac.id/pluginfile.php/1/theme_lambda/logo/1602057627/ubd_logo.png"
                    //    width: 100,
                     //   height: 50,
                        //fit:BoxFit.fill

                   // ),
                 // ),
            
          ListTile(
           //leading: Image.network(
             //   "https://elearning.binadarma.ac.id/pluginfile.php/1/theme_lambda/logo/1602057627/ubd_logo.png",
             // ),
            title: Text(data[index].nip, style: TextStyle(color: Colors.white)),
            subtitle: Text(data[index].nama_pegawai, style: TextStyle(color: Colors.white)),
          ),
          ButtonTheme.bar(
            child: ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: const Text('Edit', style: TextStyle(color: Colors.white)),
                  onPressed: () {},
                ),
                FlatButton(
                  child: const Text('Delete', style: TextStyle(color: Colors.white)),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: DosenData.length,
      itemBuilder: (context, index) {
        return viewData(DosenData,index);
      },
    );
  }
}