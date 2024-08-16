import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

/// Start FastAPI Group Code

class FastAPIGroup {
  static String getBaseUrl() => 'https://db.quilldb.io';
  static Map<String, String> headers = {};
  static ListDatabasesDbGetCall listDatabasesDbGetCall =
      ListDatabasesDbGetCall();
  static CreateDatabaseDbDbNamePostCall createDatabaseDbDbNamePostCall =
      CreateDatabaseDbDbNamePostCall();
  static CreateCollectionDbDbNameCollectionNamePostCall
      createCollectionDbDbNameCollectionNamePostCall =
      CreateCollectionDbDbNameCollectionNamePostCall();
  static CreateDocumentDbDbNameCollectionNameDocumentPostCall
      createDocumentDbDbNameCollectionNameDocumentPostCall =
      CreateDocumentDbDbNameCollectionNameDocumentPostCall();
  static GetDocumentsDbDbNameCollectionNameDocumentsGetCall
      getDocumentsDbDbNameCollectionNameDocumentsGetCall =
      GetDocumentsDbDbNameCollectionNameDocumentsGetCall();
  static GetDocumentDbDbNameCollectionNameDocumentDocIdGetCall
      getDocumentDbDbNameCollectionNameDocumentDocIdGetCall =
      GetDocumentDbDbNameCollectionNameDocumentDocIdGetCall();
  static UpdateDocumentDbDbNameCollectionNameDocumentDocIdPutCall
      updateDocumentDbDbNameCollectionNameDocumentDocIdPutCall =
      UpdateDocumentDbDbNameCollectionNameDocumentDocIdPutCall();
  static DeleteDocumentDbDbNameCollectionNameDocumentDocIdDeleteCall
      deleteDocumentDbDbNameCollectionNameDocumentDocIdDeleteCall =
      DeleteDocumentDbDbNameCollectionNameDocumentDocIdDeleteCall();
  static DebugDocumentDebugDocumentPostCall debugDocumentDebugDocumentPostCall =
      DebugDocumentDebugDocumentPostCall();
}

class ListDatabasesDbGetCall {
  Future<ApiCallResponse> call() async {
    final baseUrl = FastAPIGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'list_databases_db_get',
      apiUrl: '$baseUrl/db',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CreateDatabaseDbDbNamePostCall {
  Future<ApiCallResponse> call({
    String? dbName = '',
  }) async {
    final baseUrl = FastAPIGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'create_database_db__db_name__post',
      apiUrl: '$baseUrl/db/$dbName',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CreateCollectionDbDbNameCollectionNamePostCall {
  Future<ApiCallResponse> call({
    String? dbName = '',
    String? collectionName = '',
  }) async {
    final baseUrl = FastAPIGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'create_collection_db__db_name___collection_name__post',
      apiUrl: '$baseUrl/db/$dbName/$collectionName',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CreateDocumentDbDbNameCollectionNameDocumentPostCall {
  Future<ApiCallResponse> call({
    String? dbName = '',
    String? collectionName = '',
  }) async {
    final baseUrl = FastAPIGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'create_document_db__db_name___collection_name__document_post',
      apiUrl: '$baseUrl/db/$dbName/$collectionName/document',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetDocumentsDbDbNameCollectionNameDocumentsGetCall {
  Future<ApiCallResponse> call({
    String? dbName = '',
    String? collectionName = '',
  }) async {
    final baseUrl = FastAPIGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'get_documents_db__db_name___collection_name__documents_get',
      apiUrl: '$baseUrl/db/$dbName/$collectionName/documents',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetDocumentDbDbNameCollectionNameDocumentDocIdGetCall {
  Future<ApiCallResponse> call({
    String? dbName = '',
    String? collectionName = '',
    String? docId = '',
  }) async {
    final baseUrl = FastAPIGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName:
          'get_document_db__db_name___collection_name__document__doc_id__get',
      apiUrl: '$baseUrl/db/$dbName/$collectionName/document/$docId',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class UpdateDocumentDbDbNameCollectionNameDocumentDocIdPutCall {
  Future<ApiCallResponse> call({
    String? dbName = '',
    String? collectionName = '',
    String? docId = '',
  }) async {
    final baseUrl = FastAPIGroup.getBaseUrl();

    const ffApiRequestBody = '''
{
  "_id": "",
  "content": {}
}''';
    return ApiManager.instance.makeApiCall(
      callName:
          'update_document_db__db_name___collection_name__document__doc_id__put',
      apiUrl: '$baseUrl/db/$dbName/$collectionName/document/$docId',
      callType: ApiCallType.PUT,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class DeleteDocumentDbDbNameCollectionNameDocumentDocIdDeleteCall {
  Future<ApiCallResponse> call({
    String? dbName = '',
    String? collectionName = '',
    String? docId = '',
  }) async {
    final baseUrl = FastAPIGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName:
          'delete_document_db__db_name___collection_name__document__doc_id__delete',
      apiUrl: '$baseUrl/db/$dbName/$collectionName/document/$docId',
      callType: ApiCallType.DELETE,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class DebugDocumentDebugDocumentPostCall {
  Future<ApiCallResponse> call() async {
    final baseUrl = FastAPIGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'debug_document_debug_document_post',
      apiUrl: '$baseUrl/debug/document',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

/// End FastAPI Group Code

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}
