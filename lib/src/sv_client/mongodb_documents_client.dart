library mongodb_documents_client;

import 'dart:async';
import 'dart:convert';

import 'sv_client.dart';

import 'package:bson/bson.dart';

class MongodbDocumentsClient {
  String _backend;
  SvClient _client;

  // Function to delete session, implemented differently for client and server API clients
  var deleteSession;

  MongodbDocumentsClient(this._client, this._backend, this.deleteSession);

  Future insert(String org_id, String pool_id, String service_id, String database_name, String collection_name, document) async {
    // Log event
    _client.ga?.sendEvent('mongodbDocuments', 'insert', label: org_id);

    // Make REST request
    var response = await _client.post('$_backend/orgs/$org_id/pools/$pool_id/services/mongodb/$service_id/databases/$database_name/collections/$collection_name/documents',
                                      headers: {"Content-type": "application/json"},
                                      body: JSON.encode(document));

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

    return JSON.decode(response.body);
  }

  Future<List> list(String org_id, String pool_id, String service_id, String database_name, String collection_name, {int limit, int skip}) async {
    // Build option string if required
    var options = '';
    if(limit != null) {
      options = options + "limit=$limit&";
    }
    if(skip != null) {
      options = options + "skip=$skip";
    }

    // Log event
    _client.ga?.sendEvent('mongodbDocuments', 'list', label: org_id);

    // Make REST request
    var response = await _client.get('$_backend/orgs/$org_id/pools/$pool_id/services/mongodb/$service_id/databases/$database_name/collections/$collection_name/documents?${options}');

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

    // Decode documents
    var documents = JSON.decode(response.body);

    // NOTE: For now we skip creating object id's, we got a bug in dart2js where it work in our mustache templates
    // to use the object id as an css id in Dart, but when compiled to js it does not work. Like this:
    // <textarea id="id-{{_id.toHexString}}"></textarea>, so we skip creating object id instances for now
    // and just let them be string so we can use the strings directly as css id's instead.

    // Create ObjectId's
    //if(documents is List) {
      //for(var document in documents) {
        // Create ObjectId object
        //if(document["_id"] != null) {
        //  document['_id'] = new ObjectId.fromHexString((document['_id'] as String));
        //}
    //  }
    //}

    return documents;
  }

  Future retrieve(String org_id, String pool_id, String service_id, String database_name, String collection_name, String document_id) async {
    // Log event
    _client.ga?.sendEvent('mongodbDocuments', 'retrieve', label: org_id);

    // Make REST request
    var response = await _client.get('$_backend/orgs/$org_id/pools/$pool_id/services/mongodb/$service_id/databases/$database_name/collections/$collection_name/documents/$document_id');

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

    // Decode document
    var document = JSON.decode(response.body);

    // TODO: Make pull request to add this as fromJson() of ObjectId to mongo_dart
    // Create ObjectId object
    if(document["_id"] != null) {
      document['_id'] = new ObjectId.fromHexString((document['_id'] as String).substring(10, 34));
    }

    return document;
  }

  Future update(String org_id, String pool_id, String service_id, String database_name, String collection_name, String document_id, document, {bool upsert, bool multiUpdate}) async {
    // Build option string if required
    var options = '';
    if(upsert != null) {
      options = options + "limit=$upsert&";
    }
    if(multiUpdate != null) {
      options = options + "skip=$multiUpdate";
    }

    // Log event
    _client.ga?.sendEvent('mongodbDocuments', 'update', label: org_id);

    var response = await _client.put('$_backend/orgs/$org_id/pools/$pool_id/services/mongodb/$service_id/databases/$database_name/collections/$collection_name/documents/$document_id?${options}',
                                     headers: {"Content-type": "application/json"},
                                     body: JSON.encode(document));

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

    return JSON.decode(response.body);
  }

  Future delete(String org_id, String pool_id, String service_id, String database_name, String collection_name, String document_id) async {
    // Log event
    _client.ga?.sendEvent('mongodbDocuments', 'delete', label: org_id);

    // Make REST request
    var response = await _client.delete('$_backend/orgs/$org_id/pools/$pool_id/services/mongodb/$service_id/databases/$database_name/collections/$collection_name/documents/$document_id');

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

    return JSON.decode(response.body);
  }
}

