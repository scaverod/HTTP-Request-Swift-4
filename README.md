# HTTP-Request-Swift-4
If you want to make requests to a server using Swift 4, this class will make your life easier :)


## How to use it?

You will need just to call this function: 
```
static func makeRequest(type: RequestType, url: String, token: String, params: String)
```
Where: 
- type: Type of the call (POST, GET, DELETE).
- url: where it should be send the request.
- token: for the authentication, barear's value. It could be "" if is not needed.
- params: It will be added to the body in post calls. It could be "" if is not needed.

It's as easy as:
```
let response = ServerController.makeRequest(type: ServerController.RequestType.GET, url: "yoururl", token: token, params: params)
```       


The response save to values: 
- Int: Http status code.
- Data: Data response.

And now it's time to process that data in case that it was successfully.

## Full example:

```    
 static func login (email: String, pwd: String) -> (Bool, String){
        var document: DocumenJSON?
        var token: String = ""
        var correct = true
        let params = "email=\(email)&password=\(pwd)"
        let response = ServerController.makeRequest(type: ServerController.RequestType.POST, url: "/login", token: "", params: params)
            if response.0 != 200 {
                print("LoginRequest-> login -> Error: \n Code: \(response.0) \n Description: \(String(describing: String(data: response.1, encoding: .utf8)))")
                correct = false
                token = "Email or password incorrect."
            } else {
                do {
                    document = try JSONDecoder().decode(DocumenJSON.self, from: response.1)
                    token = (document?.value?.token)!
                } catch let jsonErr {
                    print("Error serializing json:", jsonErr)
                }
            }
        return (correct, token)
        }
 ```    


## Installation:

Just copy the class ServerController in you project and start using it :)
