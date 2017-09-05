library mongodb_databases_client;

import 'dart:async';
import 'dart:convert';

import 'sv_client.dart';

// Import models
import 'package:sv_models/models.dart';

class MongodbDatabasesClient {
  String _backend;
  SvClient _client;

  // Function to delete session, implemented differently for client and server API clients
  var deleteSession;

  MongodbDatabasesClient(this._client, this._backend, this.deleteSession);

  Future insert(String org_id, String pool_id, String service_id, String database_name) async {
    // Log event
    _client.ga?.sendEvent('mongodbDatabases', 'insert', label: org_id);

    // Make REST request
    var response = await _client.post('$_backend/orgs/$org_id/pools/$pool_id/services/mongodb/$service_id/databases/$database_name');

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

  Future<List<MongodbDatabase>> list(String org_id, String pool_id, String service_id) async {
    List<MongodbDatabase> databases = new List<MongodbDatabase>();

    // Log event
    _client.ga?.sendEvent('mongodbDatabases', 'list', label: org_id);

    var response = await _client.get('$_backend/orgs/$org_id/pools/$pool_id/services/mongodb/$service_id/databases');

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
    var jsonMapList = JSON.decode(response.body);

    // Create database list
    for (var json in jsonMapList) {
      databases.add(new MongodbDatabase.fromJson(json));
    }

//    var listReply = new DatabasesListReply.fromJson(JSON.decode(response.body));

    return databases;
  }

  Future<MongodbDatabase> retrieve(String org_id, String pool_id, String service_id, String database_name) async {
    MongodbDatabase database;

    // Log event
    _client.ga?.sendEvent('mongodbDatabases', 'retrieve', label: org_id);

    var response = await _client.get('$_backend/orgs/$org_id/pools/$pool_id/services/mongodb/$service_id/databases/$database_name');

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
    database = new MongodbDatabase.fromJson(JSON.decode(response.body));

    return database;
  }

  Future update(String org_id, String pool_id, String service_id, String database_name, MongodbDatabase database) async {
    // Log event
    _client.ga?.sendEvent('mongodbDatabases', 'update', label: org_id);

    var response = await _client.put('$_backend/orgs/$org_id/pools/$pool_id/services/mongodb/$service_id/databases/$database_name',
                                     headers: {"Content-type": "application/json"},
                                     body: JSON.encode(database));

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
    _client.ga?.sendEvent('mongodbDatabases', 'delete', label: org_id);

    var response = await _client.delete('$_backend/orgs/$org_id/pools/$pool_id/services/mongodb/$service_id/databases/$database_name');

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

