extends Node

const API_KEY := "AIzaSyCORK7a5-N3d50tKeEETzVhEhuy7A1gJxk"
const PROJECT_ID := "prueba-front-746df"
const APP_ID := "1:241178780844:web:c2d571d111f0f73e836b09"

const FIRESTORE_URL := "https://firestore.googleapis.com/v1/projects/%s/databases/(default)/documents/" % PROJECT_ID


func _get_request_headers() -> PoolStringArray:
	return PoolStringArray([
		["Content-Type: application/json"]
	])


func save_document(path: String, fields: Dictionary, http: HTTPRequest) -> void:
	var document := { "fields": fields }
	var body := to_json(document)
	var url := FIRESTORE_URL + path
	http.request(url, _get_request_headers(), false, HTTPClient.METHOD_POST, body)


func get_document_or_collection(path: String, http: HTTPRequest) -> void:
	var url := FIRESTORE_URL + path
	print(url)
	http.request(url, _get_request_headers(), false, HTTPClient.METHOD_GET)


func update_document(path: String, fields: Dictionary, http: HTTPRequest) -> void:
	var document := { "fields": fields }
	var body := to_json(document)
	var url := FIRESTORE_URL + path
	http.request(url, _get_request_headers(), false, HTTPClient.METHOD_PATCH, body)


func delete_document(path: String, http: HTTPRequest) -> void:
	var url := FIRESTORE_URL + path
	http.request(url, _get_request_headers(), false, HTTPClient.METHOD_DELETE)

