library mongodb_collections_client;

import 'dart:async';
import 'dart:convert';

import 'sv_client.dart';

// Import models
import 'package:sv_models/models.dart';

class MongodbCollectionsClient {
  String _backend;
  SvClient _client;

  // Function to delete session, implemented differently for client and server API clients
  var deleteSession;

  MongodbCollectionsClient(this._client, this._backend, this.deleteSession);

  Future<MongodbCollection> insert(String org_id, String pool_id, String service_id, String database_name, String collection_name) async {
    // Create new object
    var newColl = new MongodbCollection(org_id, pool_id, service_id, database_name, collection_name);

    // Log event
    _client.ga?.sendEvent('mongodbCollections', 'insert', label: org_id);

    // Make REST request
    var response = await _client.post('$_backend/orgs/$org_id/pools/$pool_id/services/mongodb/$service_id/databases/$database_name/collections',
                                      headers: {"Content-type": "application/json"},
                                      body: json.encode(newColl));

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
    var reply = new MongodbCollection.fromJson(json.decode(response.body));

    return reply;
  }

  Future<List<MongodbCollection>> list(String org_id, String pool_id, String service_id, String database_name) async {
    var collections = new List<MongodbCollection>();

    // Log event
    _client.ga?.sendEvent('mongodbCollections', 'list', label: org_id);

    var response = await _client.get('$_backend/orgs/$org_id/pools/$pool_id/services/mongodb/$service_id/databases/$database_name/collections');

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
    var reply = json.decode(response.body);
    if(reply is List) {
      for(var item in reply) {
        collections.add(new MongodbCollection.fromJson(item));
      }
    }

    return collections;
  }

  Future<MongodbCollection> retrieve(String org_id, String pool_id, String service_id, String database_name, String collection_name) async {
    // Log event
    _client.ga?.sendEvent('mongodbCollections', 'retrieve', label: org_id);

    var response = await _client.get('$_backend/orgs/$org_id/pools/$pool_id/services/mongodb/$service_id/databases/$database_name/collections/$collection_name');

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
    var reply = json.decode(response.body);

    return new MongodbCollection.fromJson(reply);
  }

  Future delete(String org_id, String pool_id, String service_id, String database_name, String collection_name) async {
    // Log event
    _client.ga?.sendEvent('mongodbCollections', 'delete', label: org_id);

    var response = await _client.delete('$_backend/orgs/$org_id/pools/$pool_id/services/mongodb/$service_id/databases/$database_name/collections/$collection_name');

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

