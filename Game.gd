extends Node2D

onready var label: Label = $Label
onready var http: HTTPRequest = $HTTPRequest

var pending = false

func _ready():
  assert(OK == http.connect("request_completed", self, "_on_http_request_completed"))
  
  assert(OK == http.request("http://localhost:3000"))
  pending = true
  while pending:
    print_status()
    yield(get_tree().create_timer(1), "timeout")
    
func print_status() -> void:
  var status := "unknown"
  match http.get_http_client_status():
    HTTPClient.STATUS_CONNECTING: status = ('connecting')
    HTTPClient.STATUS_CONNECTED: status = ('connected')
    HTTPClient.STATUS_CANT_CONNECT: status = ('cannot connect')
    HTTPClient.STATUS_CANT_RESOLVE: status = ('cannot resolve')
    HTTPClient.STATUS_DISCONNECTED: status = ('disconnected')
    HTTPClient.STATUS_BODY: status = ('body?')
    HTTPClient.STATUS_CONNECTION_ERROR: status = ('connection error')
    HTTPClient.STATUS_REQUESTING: status = ('requesting')
    HTTPClient.STATUS_RESOLVING: status = ('resolving')
    var http_status:
      status = ('other: %s' % http_status)
  prints("{hour}:{minute}:{second}".format(OS.get_time()), 'client status:', status)
  
func _on_http_request_completed(result: int, code: int, headers: PoolStringArray, body: PoolByteArray):
  prints("Http request completed")
  pending = false
  match result:
    HTTPRequest.RESULT_SUCCESS:
      prints("success")
      prints("headers:", headers)
      var text =  body.get_string_from_utf8()
      prints("body:", text)
      label.text = text
    _:
      prints('not success')
  pass
