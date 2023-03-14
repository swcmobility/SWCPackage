

## Getting Started

## Requirements

* iOS 13.0+
* Swift 5

## Installation

### Swift Package Manager

- Package -> Package.swift -> Add Dependency
- Add `https://github.com/swcmobility/SWCPackage.git`
- Select "Up to Next Major" with "1.0.0"


## Usage

* Configure SWCPackage in your parent app's `AppDelegate`
* Call `SWCPackageHandler.configure()` inside 
`func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool` 

### Network Calls

* Use `SWCNetworkEngine` to make any URLRequest

#### Data Task
##### Predefined SWC request body
* Use `SWCRequestGenerator` to get predefined SWC request body
* Example:

```
        let engine = SWCNetworkEngine(moduleId: "id",
                                      validateTokenTimeStamp: false)
        var generator = SWCRequestGenerator(url: "End Point")
        generator.request.body.values = [.init(value: "Value 1",
                                               propertyName: "Property Name 1")]
        let customChunks: [String: Any] = ["key one": "value one",
                                           "key two": ["key abc": "value abc"]]
        generator.request.body.additionalChunks = customChunks
        do {
            let user = try await engine.getResponse(with: generator, responseType: ExpectedResponseModel.self)
        } catch let error {
            print(error.localizedDescription)
        }
```
##### Custom URLRequest
* To generate Custom URLRequest, confirm to `SWCRequestSource` protocol and use this new model with `SWCNetworkEngine`

```
        struct CustomRequestGenerator: SWCRequestSource {
            func generateRequest() -> URLRequest {
                /// implement your own URLRequest
            }
        }

```
* Using `CustomRequestGenerator` with `SWCNetworkEngine`

```
        let engine = SWCNetworkEngine()
        let request = CustomRequestGenerator()
        do {
                let response = try await engine.getResponse(with: request, responseType: ExpectedResponseModel.self)
        } catch let error {
                print(error.localizedDescription)
        }
    
```

##### Wrapper for custom URLRequest
* SWCPackage has a wrapper for custom URLRequest generation
* Use `SWCExternalRequestGenerator` wrapper for custom URLRequest generation
* `SWCExternalRequestGenerator` contains predefined `contentType` `accept` header fields and `httpMethod`
* You can add additional header values by calling `setHeader` method.
* `SWCExternalRequestGenerator` usage example

```
        let url = "Server path"
        let requestBody: [String: Any] = ["Parameter One": "Value One",
                                          "Parameter Two": "Value Two"]
        var generator = SWCExternalRequestGenerator(url: url, body: requestBody)
        generator.setHeader(value: .jsonOdataVerbose, field: .iFMATCH)
        let engine = SWCNetworkEngine()
        do {
            let response = try await engine.getResponse(with: generator, responseType: ExpectedResponseModel.self)
        } catch let error {
            print(error.localizedDescription)
        }
```
##### Custom `HTTPHeader` `HTTPHeaderValue` and `HTTPMethod`
* Create extenion for particular item
* Example
```
        extension HTTPHeaderValue {
                static let json: HTTPHeaderValue = "application/json"
        }

        extension HTTPHeader {
                static let accept: HTTPHeader = "Accept"
        }

        extension HTTPMethod {
                static let post: HTTPMethod = "POST"
        }
```
#### Upload Task

* Use `SWCUploadEngine` to perform any `uploadTask`
* Generate your `uploadTask` URLRequest by confirming to `SWCUploadSource` protocol
* Example for request generation

```
        struct MyUploadRequest: SWCUploadSource {
                let serverURL: URL
                var showLoader: Bool = true
                var fromFileURL: URL
                init(serverURL: URL, localFileURL: URL) {
                        fromFileURL = localFileURL
                        self.serverURL = serverURL
                }
                func generateRequest() -> URLRequest {
                        let request = URLRequest(url: serverURL)
                        return request
                }
        }

```
* `SWCUploadEngine` usage example

```
        var bag = Set<AnyCancellable>()
        let serverURL = URL(string: "server url")!
        let localFile = URL(filePath: "path to file")
        let request = MyUploadRequest(serverURL: serverURL, localFileURL: localFile)
        SWCUploadEngine
            .prepare
            .upload(with: request)
            .sink { [weak self] result in
                guard let self else { return }
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    print("Successfully uploaded")
                }
            } receiveValue: { percentage in
                print("Uploaded percentage ", percentage)
            }.store(in: &bag)

```

#### Download Task

* Use `SWCDownloadEngine` to perform any `downloadTask`
* `SWCDownloadEngine` usage example

```
        let serverURL = "Server path to file"
        SWCDownloadEngine
            .prepare
            .download(from: "serverURL", showLoader: true)
            .sink { [weak self] result in
                guard let self else { return }
                switch result {
                case .failure(let error):
                    print("Error while downloading ", error.localizedDescription)
                case .finished:
                    print("Download finished")
                }
            } receiveValue: { [weak self] output in
                guard let self else { return }
                switch output {
                case .completed(let localURL):
                    print("Download finished and stored to localURL ", localURL)
                case .downloading(let progress):
                    print("Downloaded percentage ", progress)
                }
            }

```
### Setting values to SWCPackage

* Use `SWCPackageHandler.set` metohd to provide values.
* Example

```
        let userData = SWCPackageHandler.UserData(userName: "abc", password: "bacdef", userGUID: "abc", prNumber: "123")
        SWCPackageHandler.set(userData: userData)
        
        SWCPackageHandler.set(aesKey: "key", aesIV: "iv")
        
```

### Retrieving values

* To get UserData use `SWCPackageHandler.getUserData()` method

### Local Storage

* SWCPackage contains local storage helpers.

#### UserDefaults Storage

* Use `SWCUserDefaultsManager` For handling UserDefaults storage
* Example for storing and retrieving values

```
        /// Storing
        SWCUserDefaultsManager.save(value: "Value one", forKey: .keyOne)
    
        /// Accessing stored value
        let value = SWCUserDefaultsManager.string(forKey: .keyOne)
```

* You can create key for SWCUserDefaultsManager by giving `extension` to `SWCUserDefaultsKey`

```
        extension SWCUserDefaultsKey {
                static let keyOne: SWCUserDefaultsKey = "KeyOne"
        }

```

#### Keychain Storage

* Use `SWCKeychainManager` For handling Keychain storage
* Example for storing and retrieving values


```
        /// Storing
        SWCKeychainManager.save(value: "Value One", forKey: .keyOne)
    
        /// Accessing stored value
        let value = SWCKeychainManager.string(forKey: .keyOne)
```
* You can create key for SWCKeychainManager by giving `extension` to `SWCKeychainKey`

```
        extension SWCKeychainKey {
                static let keyOne: SWCKeychainKey = "KeyOne"
        }

```
