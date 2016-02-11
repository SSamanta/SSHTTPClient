# SSHTTPClient 

Lightweight swift **HTTPClient**.

**SSHTTPClient** is a lightweight swift class for network call using **NSURLSession**.

  - Easy to use
  - Using **NSURLSession**
  - Using **Swift2** 

### Available Pod 
`pod 'SSHTTPClient', '~>1.2.2'`

### Don't Like Pod?
Just Download project and copy `SSHTTPClient.swift` in your project you are Done!

## Example 

        // Sample service call
		let urlString = "http://itunes.apple.com/us/rss/topfreeapplications/limit=100/json"
        let sampleCall : SSHTTPClient  = SSHTTPClient(url: urlString , method: "GET", httpBody: "", headerFieldsAndValues: ["":""])
        sampleCall.getJsonData { (obj, error) -> Void in
            print(obj, terminator: "")
        }



