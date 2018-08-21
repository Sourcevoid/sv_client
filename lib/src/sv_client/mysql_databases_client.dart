library mysql_databases_client;

import 'dart:async';
import 'dart:convert';

import 'sv_client.dart';

// Import models
import 'package:sv_models/models.dart';

class MysqlDatabasesClient {
  String _backend;
  SvClient _client;

  // Function to delete session, implemented differently for client and server API clients
  var deleteSession;

  MysqlDatabasesClient(this._client, this._backend, this.deleteSession);

  Future insert(String org_id, String pool_id, String service_id, String database_name) async {
    // Log event
    _client.ga?.sendEvent('mysqlDatabases', 'insert', label: org_id);

    // Make REST request
    var response = await _client.post('$_backend/orgs/$org_id/pools/$pool_id/services/mysql/$service_id/databases/$database_name');

    // Handle response
    if(response.statusCode == 401) {
      // Log event
      _client.ga?.sendException(response.reasonPhrase);

      // Sign out stale session credentials and throw error
      deleteSession();
      throw(response.body);
    } else if(response.statusCode != 200) {
      // Log event
      _client.ga?.sendException(response.reasonPhrase);

      // Throw error that callee can choose how to handle
      throw(response.body);
    }
  }

  Future<List<MysqlDatabase>> list(String org_id, String pool_id, String service_id) async {
    List<MysqlDatabase> databases = new List<MysqlDatabase>();

    // Log event
    _client.ga?.sendEvent('mysqlDatabases', 'list', label: org_id);

    var response = await _client.get('$_backend/orgs/$org_id/pools/$pool_id/services/mysql/$service_id/databases');

    // Handle response
    if(response.statusCode == 401) {
      // Log event
      _client.ga?.sendException(response.reasonPhrase);

      // Sign out stale session credentials and throw error
      deleteSession();
      throw(response.body);
    } else if(response.statusCode != 200) {
      // Log event
      _client.ga?.sendException(response.reasonPhrase);

      // Throw error that callee can choose how to handle
      throw(response.body);
    }

    // Decode json
    var jsonMapList = json.decode(response.body);

    // Create database list
    for (var json in jsonMapList) {
      databases.add(new MysqlDatabase.fromJson(json));
    }

//    var listReply = new DatabasesListReply.fromJson(json.decode(response.body));

    return databases;
  }

  Future<MysqlDatabase> retrieve(String org_id, String pool_id, String service_id, String database_name) async {
    MysqlDatabase database;

    // Log event
    _client.ga?.sendEvent('mysqlDatabases', 'retrieve', label: org_id);

    var response = await _client.get('$_backend/orgs/$org_id/pools/$pool_id/services/mysql/$service_id/databases/$database_name');

    // Handle response
    if(response.statusCode == 401) {
      // Log event
      _client.ga?.sendException(response.reasonPhrase);

      // Sign out stale session credentials and throw error
      deleteSession();
      throw(response.body);
    } else if(response.statusCode != 200) {
      // Log event
      _client.ga?.sendException(response.reasonPhrase);

      // Throw error that callee can choose how to handle
      throw(response.body);
    }

    // Decode reply
    database = new MysqlDatabase.fromJson(json.decode(response.body));

    return database;
  }

  Future update(String org_id, String pool_id, String service_id, String database_name, MysqlDatabase database) async {
    // Log event
    _client.ga?.sendEvent('mysqlDatabases', 'update', label: org_id);

    var response = await _client.put('$_backend/orgs/$org_id/pools/$pool_id/services/mysql/$service_id/databases/$database_name',
                                     headers: {"Content-type": "application/json"},
                                     body: json.encode(database));

    // Handle response
    if(response.statusCode == 401) {
      // Log event
      _client.ga?.sendException(response.reasonPhrase);

      // Sign out stale session credentials and throw error
      deleteSession();
      throw(response.body);
    } else if(response.statusCode != 200) {
      // Log event
      _client.ga?.sendException(response.reasonPhrase);

      // Throw error that callee can choose how to handle
      throw(response.body);
    }

    return response.body;
  }

  Future delete(String org_id, String pool_id, String service_id, String database_name) async {
    // Log event
    _client.ga?.sendEvent('mysqlDatabases', 'delete', label: org_id);

    var response = await _client.delete('$_backend/orgs/$org_id/pools/$pool_id/services/mysql/$service_id/databases/$database_name');

    // Handle response
    if(response.statusCode == 401) {
      // Log event
      _client.ga?.sendException(response.reasonPhrase);

      // Sign out stale session credentials and throw error
      deleteSession();
      throw(response.body);
    } else if(response.statusCode != 200) {
      // Log event
      _client.ga?.sendException(response.reasonPhrase);

      // Throw error that callee can choose how to handle
      throw(response.body);
    }

    return response.body;
  }
}

