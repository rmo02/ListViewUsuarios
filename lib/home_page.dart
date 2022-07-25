import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:listhttp/usuario_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuários'),
      ),
      body: FutureBuilder<dynamic>(
        future: pegarUsuarios(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return ListView.builder(
              itemCount: snapshot.data!.length,
                itemBuilder: (context, index){
                var usuario = snapshot.data![index];
                  return ListTile(
                    onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(
                              builder: (context) => UsuarioPage(usuario: usuario)
                          ));
                    },
                    leading: CircleAvatar(
                      child: Text(usuario['id'].toString()),
                    ),
                    title: Text(usuario['name']),
                    subtitle: Text(usuario['website']),
                  );
                });
          } else if (snapshot.hasError){
            return Center(
                child: Text('${snapshot.error}'));
          }
          return Center(
              child: CircularProgressIndicator());
        },
      ),
    );
  }

  pegarUsuarios() async {
    var url = Uri.parse('https://jsonplaceholder.typicode.com/users');
    var resposta = await http.get(url);
    if(resposta.statusCode == 200){
      return jsonDecode(resposta.body);
    } else {
      throw Exception('Nao foi possivel carregar usuários');
    }
  }

}
