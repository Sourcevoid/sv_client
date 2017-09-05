library postgresql_tables_client;

import 'dart:async';
import 'dart:convert';

import 'sv_client.dart';

// Import models
import 'package:sv_models/models.dart';

class PostgresqlTablesClient {
  String _backend;
  SvClient _client;

  // Function to delete session, implemented differently for client and server API clients
  var deleteSession;

  PostgresqlTablesClient(this._client, this._backend, this.deleteSession);

  Future<String> insert(String org_id, String pool_id, String service_id, String database_name, String schema_name, String table_name) async {
    // Create new object
    var table = new PostgresqlTable(org_id, pool_id, service_id, database_name, schema_name, table_name);

    // Log event
    _client.ga?.sendEvent('postgresqlTables', 'insert', label: org_id);

    // Make REST request
    var response = await _client.post('$_backend/orgs/$org_id/pools/$pool_id/services/postgresql/$service_id/databases/$database_name/schemas/$schema_name/tables/$table_name',
                                      headers: {"Content-type": "application/json"},
                                      body: JSON.encode(table));

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

    print(response.body);

    return response.body;

    // Decode reply
//    var reply = new PostgresqlTable.fromJson(JSON.decode(response.body));
//
//    return reply;
  }

  Future<List<PostgresqlTable>> list(String org_id, String pool_id, String service_id, String database_name, String schema_name) async {
    var tables = new List<PostgresqlTable>();

    // Log event
    _client.ga?.sendEvent('postgresqlTables', 'list', label: org_id);

    var response = await _client.get('$_backend/orgs/$org_id/pools/$pool_id/services/postgresql/$service_id/databases/$database_name/schemas/$schema_name/tables');

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
        tables.add(new PostgresqlTable.fromJson(item));
      }
    }

    return tables;
  }

  Future<PostgresqlTable> retrieve(String org_id, String pool_id, String service_id, String database_name, String schema_name, String table_name) async {
    // Log event
    _client.ga?.sendEvent('postgresqlTables', 'retrieve', label: org_id);

    var response = await _client.get('$_backend/orgs/$org_id/pools/$pool_id/services/postgresql/$service_id/databases/$database_name/schemas/$schema_name/tables/$table_name');

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

    return new PostgresqlTable.fromJson(reply);
  }

  Future delete(String org_id, String pool_id, String service_id, String database_name, String schema_name, String table_name) async {
    // Log event
    _client.ga?.sendEvent('postgresqlTables', 'delete', label: org_id);

    var response = await _client.delete('$_backend/orgs/$org_id/pools/$pool_id/services/postgresql/$service_id/databases/$database_name/schemas/$schema_name/tables/$table_name');

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

