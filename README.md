# PAKeychainService


A very simple Swift wrapper around the iOS Keychain.

## Usage

### Retrieve

````
if let emailValue = PAKeychainService.sharedService.getContentsOfKey("email") {
    ...
}
````

### Update / Save

````
PAKeychainService.sharedService.saveContentsForKey("new value", key: "email")
````
