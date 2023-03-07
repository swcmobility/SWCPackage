

## Getting Started

Smart Office Work Center Package
### Requirements

* iOS 13.0+
* Swift 5

### Installation

#### Swift Package Manager

- Package -> Package.swift -> Add Dependency
- Add `https://github.com/dewamobility/SWCPackage.git`
- Select "Up to Next Major" with "1.0.0"


### Usage

* Configure SWCPackage in your parent app's `AppDelegate`
* Call `SWCPackageHandler.configure()` inside 
`func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool` 

#### Network Calls

* Use `SWCNetworkEngine` to make any URLRequest
* Use `SWCRequestGenerator` to get predefined SWC request body
* Example:

```
        let engine = SWCNetworkEngine(moduleId: "id",
                                      validateTokenTimeStamp: false)
        var generator = SWCRequestGenerator(url: "End Point")
        generator.request.body.values = [.init(value: "Value 1",
                                               propertyName: "Property Name 1")]
        do {
            let user = try await engine.getResponse(with: generator, responseType: ExpectedResponseModel.self)
        } catch let error {
            print(error.localizedDescription)
        }
```

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

#### Local Storage

* SWCPackage contains local storage helpers.

##### UserDefaults Storage

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

##### Keychain Storage

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
