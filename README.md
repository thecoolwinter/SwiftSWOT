# SwiftSWOT

[![Platforms](https://img.shields.io/badge/platforms-macOS%2010.15%20|%20Ubuntu%2016.04%20LTS-ff0000.svg?style=flat)](http://cocoapods.org/pods/FASwift)
[![Swift 5.3](https://img.shields.io/badge/swift-5.3-orange.svg?style=flat)](http://swift.org)
[![Vapor 4](https://img.shields.io/badge/vapor-4.0-blue.svg?style=flat)](https://vapor.codes)

`SwiftSWOT` is a Vapor service for verifying academic emails against the [SWOT database](https://github.com/leereilly/swot).

SWOT is a community-driven database that has a large list of valid academic emails. This is useful for things like providing student discounts. This package checks against that database to give a reasonably good idea of if a given email is an academic email.

## Instalation

Instalation is done through the Swift Package Manager

```swift
.package(url: "https://github.com/thecoolwinter/SwiftSWOT.git", from: "1.0.1")

.target(name: "App", dependencies: [
    .product(name: "Vapor", package: "vapor"),
    .product(name: "SwiftSWOT", package: "SwiftSWOT")
])
```

## Usage

#### Validate Academic Emails

In your request path, validate emails using the `SWOT` variable on the request.

```swift
app.on(.GET, "validateStudent", ":email") { (req) -> [String: String] in
    guard let email = try? req.parameters.require("email") else {
        return [
            "valid": "false",
            "reason": "Please provide an email to validate."
        ]
    }
    
    let isValidEmail = req.SWOT.validateEmail(email)
    if isValidEmail {
        return [
            "valid": "true"
        ]
    } else {
        return [
            "valid": "false",
            "reason": "Not a valid academic email address."
        ]
    }
}
```

You can also get the academic institution's name from the email. 

```swift
app.on(.GET, "institution", ":email") { (req) -> [String: String] in
    guard let email = try? req.parameters.require("email") else {
        return [
            "valid": "false",
            "reason": "Please provide an email to validate.",
            "institutionName": ""
        ]
    }
    
    let institutionName = req.SWOT.institutionFromEmail(email)
    if institutionName != nil {
        return [
            "valid": "true",
            "institutionName": institutionName!
        ]
    } else {
        return [
            "valid": "false",
            "reason": "Not a valid academic email address.",
            "institutionName": ""
        ]
    }
}
```



#### Configuration & Customization

The configuration can be set using the `SwiftSWOTConfig` object on your app.

You can configure: 

- Blacklist
- Custom institutions that might not be in the database
- Toggle logging

```swift
app.SWOT.configuration = .init(loggingEnabled: true, // Default `false`
                                blacklist: [ // Array of domain names to ignore
                                	"gmail.com",
                                  "yahoo.org"
                                ],
                                trustedDomains: [
                                	"my.gcu.edu": "Grand Canyon University"
                                ])
```

`trustedDomains` is a dictionary of `Domain : Institution Name`. The domain is what SWOT wil search for when validating an email, Institution Name is what will be returned from `req.SWOT.institutionFromEmail(email)`

*Note: `gmail.com` and` yahoo.org` are there for example, they will return false if checked against the database.*

