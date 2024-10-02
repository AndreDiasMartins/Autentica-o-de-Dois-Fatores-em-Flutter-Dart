
import 'package:postgres/postgres.dart';
import 'dart:math';

import 'package:projeto_auth/infoDisp.dart';

class PostgresConnection {
  final endpoint = Endpoint(
      host: 'localhost', // hostname
      database: 'FlutterTeste', // Nome do banco de dados
      username: 'postgres', //username para conexao
      port: 5432, // porta padrão postgres 5432
      password: 'postgres'); //senha para conexao

  final connectionSettings = const ConnectionSettings(sslMode: SslMode.disable);

  Future<int?> autenticar(String login, String Senha) async {
    final connection =
        await Connection.open(endpoint, settings: connectionSettings);
    final result = await connection.execute(
        Sql.named(
            'Select id from tbUsers where email = @login and senha=@senha'),
        parameters: {'login': login, 'senha': Senha});

    // Fechar a conexão
    await connection.close();

    if (result.isNotEmpty) {
      return result.first.toColumnMap()['id'];
    }
    return null;
  }

  Future<String?> createToken(int idUSer) async {
    final connection =
        await Connection.open(endpoint, settings: connectionSettings);

    final String token = gerarStringAleatoria(6);

    final result = await connection.execute(
        Sql.named(
            "insert into tbUserToken values((select coalesce(max(id), 0) +1 from tbUserToken), @token, @user, current_timestamp + interval '30' minute)"),
        parameters: {'token': token, 'user': idUSer});

    // Fechar a conexão
    await connection.close();

    if (result.affectedRows > 0) {
      return token;
    }
    return null;
  }

  
  Future<bool> validToken(int idUSer, String token) async {
    final connection =
          await Connection.open(endpoint, settings: connectionSettings);

    final result = await connection.execute(
            Sql.named('Select token from tbusertoken where iduser =@user and token=@token and exp > current_timestamp limit 1'), parameters: {'user': idUSer, 'token': token});
    
    if (result.isNotEmpty){
        AgilDeviceInfo InfoClass = AgilDeviceInfo();
        Map<String, String> InfoDisp = await InfoClass.getInfoMap();
      final InsertDevice = await connection.execute(
          Sql.named(
            'INSERT INTO device_details (iduser, device_type, os_info) VALUES (@iduser, @device_type, @os_info)'
          ),
          parameters: {
            'iduser': idUSer,
            'device_type': InfoDisp['hostname'],
            'os_info': InfoDisp['platform']
          }
        );
        return InsertDevice.affectedRows > 0;
     }
     
    // Fechar a conexão
    await connection.close();

    return result.isNotEmpty;
  }

Future<bool> validDispositivo(int idUSer) async {
    final connection =
          await Connection.open(endpoint, settings: connectionSettings);

    AgilDeviceInfo InfoClass = AgilDeviceInfo();
    Map<String, String> InfoDisp = await InfoClass.getInfoMap();
    
    final result = await connection.execute(
            Sql.named('Select iduser, device_type, os_info from device_details where iduser=@user and device_type=@device and os_info=@osInfo'), parameters: {'user': idUSer, 'device': InfoDisp['hostname'], 'osInfo':InfoDisp['platform']});
    // Fechar a conexão
    await connection.close();
    return result.affectedRows > 0;
  }



  Future<bool> DeleteTokens(int idUSer, String token) async {
    final connection =
          await Connection.open(endpoint, settings: connectionSettings);

    final result = await connection.execute(
            Sql.named('delete from tbusertoken where iduser=@user and token =@token'), parameters: {'user': idUSer, 'token':token });

    // Fechar a conexão
    await connection.close();

    return result.affectedRows > 0;
  }

  
  Future<bool> DeleteDispositivo(int idUSer) async {
    final connection =
          await Connection.open(endpoint, settings: connectionSettings);

    AgilDeviceInfo InfoClass = AgilDeviceInfo();
    Map<String, String> InfoDisp = await InfoClass.getInfoMap();

    final result = await connection.execute(
            Sql.named('delete from device_details where iduser=@user and device_type=@device and os_info=@osInfo '), parameters: {'user': idUSer, 'device':InfoDisp['hostname'], 'osInfo': InfoDisp['platform'] });
 
    // Fechar a conexão
    await connection.close();

    return result.affectedRows > 0;
  }


  Future<List<Map<String,dynamic>>> BuscarUsuarios() async {

    List<Map<String, dynamic>> lista = []; 

    final connection =
          await Connection.open(endpoint, settings: connectionSettings);
    
    final result = await connection.execute('select * from tbusers');
    // Fechar a conexão
    await connection.close();

    for (ResultRow row in result) {
      lista.add(row.toColumnMap());
    }
    return lista;  


  }


  Future<bool> InsertUsers(String Email, String Senha) async {
    final connection =
          await Connection.open(endpoint, settings: connectionSettings);
    
    final ValidEmail = await connection.execute(Sql.named('''SELECT * FROM tbusers WHERE email = @email'''), parameters: {'email': Email}); 
    if (ValidEmail.isNotEmpty) {
      return false;
    }
    else {
      final result = await connection.execute(
        Sql.named('''
          INSERT INTO tbusers (id, email, senha)
          VALUES ((SELECT COALESCE(MAX(id), 0) + 1 FROM tbusers), @email, @senha)
        '''),
        parameters: {'email': Email, 'senha': Senha},
      );
      return result.affectedRows > 0;
    }
  }



  Future<bool> UpdateUser(int idUser, String Email, String Senha) async {
    final connection =
          await Connection.open(endpoint, settings: connectionSettings);
    
    final result = await connection.execute(
      Sql.named('''
        UPDATE tbusers
        SET email = @email, senha = @senha
        WHERE id = @iduser
      '''),
      parameters: {'email': Email, 'senha': Senha, 'iduser': idUser},
    );

    return result.affectedRows > 0;

  }

  Future<bool> DeleteUser(int idUser) async {
    final connection =
          await Connection.open(endpoint, settings: connectionSettings);
    
    final result = await connection.execute(
        Sql.named('''
          DELETE FROM tbusers
          WHERE id = @iduser
        '''),
        parameters: {'iduser': idUser},
      );


    return result.affectedRows > 0;

  }

}





String GetDispInfo(int comprimento) {
  

  
  return '';

}




String gerarStringAleatoria(int comprimento) {
  const caracteres = '0123456789';
  final random = Random();

  return List.generate(
          comprimento, (_) => caracteres[random.nextInt(caracteres.length)])
      .join('');

}


