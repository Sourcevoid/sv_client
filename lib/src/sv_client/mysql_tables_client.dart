library mysql_tables_client;

import 'dart:async';
import 'dart:convert';

import 'sv_client.dart';

// Import models
import 'package:sv_models/models.dart';

class MysqlTablesClient {
  String _backend;
  SvClient _client;

  // Function to delete session, implemented differently for client and server API clients
  var deleteSession;

  MysqlTablesClient(this._client, this._backend, this.deleteSession);

  Future<MysqlTable> insert(String org_id, String pool_id, String service_id, String database_name, String table_name) async {
    // Create new object
    var newColl = new MysqlTable(org_id, pool_id, service_id, database_name, table_name);

    // Log event
    _client.ga?.sendEvent('mysqlTables', 'insert', label: org_id);

    // Make REST request
    var response = await _client.post('$_backend/orgs/$org_id/pools/$pool_id/services/mysql/$service_id/databases/$database_name/tables',
                                       headers: {"Content-type": "application/json"},
                                       body: JSON.encode(newColl));

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
    var reply = new MysqlTable.fromJson(JSON.decode(response.body));

    return reply;
  }

  Future<List<MysqlTable>> list(String org_id, String pool_id, String service_id, String database_name) async {
    var tables = new List<MysqlTable>();

    // Log event
    _client.ga?.sendEvent('mysqlTables', 'list', label: org_id);

    var response = await _client.get('$_backend/orgs/$org_id/pools/$pool_id/services/mysql/$service_id/databases/$database_name/tables');

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
    var reply = JSON.decode(response.body);
    if(reply is List) {
      for(var item in reply) {
        tables.add(new MysqlTable.fromJson(item));
      }
    }

    return tables;
  }

  Future<MysqlTable> retrieve(String org_id, String pool_id, String service_id, String database_name, String table_name) async {
    // Log event
    _client.ga?.sendEvent('mysqlTables', 'retrieve', label: org_id);

    var response = await _client.get('$_backend/orgs/$org_id/pools/$pool_id/services/mysql/$service_id/databases/$database_name/tables/$table_name');

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
    var reply = JSON.decode(response.body);

    return new MysqlTable.fromJson(reply);
  }

  Future delete(String org_id, String pool_id, String service_id, String database_name, String table_name) async {
    // Log event
    _client.ga?.sendEvent('mysqlTables', 'delete', label: org_id);

    var response = await _client.delete('$_backend/orgs/$org_id/pools/$pool_id/services/mysql/$service_id/databases/$database_name/tables/$table_name');

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

