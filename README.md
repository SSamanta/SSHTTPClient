# SSHTTPClient

SSHTTPClient is a resuable swift class for network call using NSURLSession.

  - Easy to use
  - NSURLSession native support
  - Using Swift

SSHTTPClient is a lightweight resuable component using swift language and NSURLSession class:
### Version
1.0.0


### Installation
Add [SSHTTPClient.swift] class in your project

### Installation

Sample service call

```sh
$ let urlString : NSString = "http://itunes.apple.com/us/rss/topfreeapplications/limit=100/json"
```

```sh
$ let sampleCall : SSHTTPClient  = SSHTTPClient(url: urlString , method: "GET", httpBody: "", headerFieldsAndValues: ["":""])
$ sampleCall.getJsonData { (obj, error) -> Void in
$  print(obj)
$ }

```
License
----

NONE
