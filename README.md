# CocoaBloc
[![CI Status](https://img.shields.io/travis/stagebloc/CocoaBloc/master.svg?style=flat)](https://travis-ci.org/stagebloc/CocoaBloc/branches)
[![Version](https://img.shields.io/cocoapods/v/CocoaBloc.svg?style=flat)](http://cocoapods.org/pods/CocoaBloc)
[![License](https://img.shields.io/cocoapods/l/CocoaBloc.svg?style=flat)](http://cocoapods.org/pods/CocoaBloc)
[![Platform](https://img.shields.io/cocoapods/p/CocoaBloc.svg?style=flat)](http://cocoapods.org/pods/CocoaBloc)

CocoaBloc enables any Cocoa developer to have instant access to the StageBloc API via pre-built functions and models. As such, it should allow for much easier and faster development with the StageBloc API in mobile applications. There are two elements to CocoaBloc, the API and the UI elements.

## Setup

CocoaBloc can easily be added to any project via [CocoaPods](http://cocoapods.org/). Simply add the CocoaBloc pod to your `Podfile` and run a `pod install`.
```ruby
pod "CocoaBloc", :git => "https://github.com/stagebloc/CocoaBloc.git"
```

Once the source code is in your project, the one line of code below is all that is required to make CocoaBloc ready. A client ID and secret can be made within the developers section of your account on the StageBloc backend. These, along with the redirect URI for OAuth if you're intending to let users log in for authenticated requests, are supplied once for each app.

```objc
[SBClient setClientID:@"client_id" clientSecret:@"client_secret" redirectURI:@"my_app_uri://"];
```

## About Dependencies & Prerequisites

### [ReactiveCocoa](http://github.com/ReactiveCocoa/ReactiveCocoa.git)
CocoaBloc makes liberal use of the fantastic ReactiveCocoa (RAC), and in fact all API client (`SBClient`) methods do not fire off the requests themselves, but use the input parameters to compose a "cold" `RACSignal` which when subscribed to, performs the network request, validation, deserialization, and delivery back to you with either an error or tidy model object. Building our API this way gives it the ability for extremely useful transformations, chaining, limiting, etc to things like API requests, or serialization jobs.

### [Mantle](https://github.com/Mantle/Mantle)
All of the JSON<~>ObjC model mapping and translation is handled by Mantle. As such, you'll find the models to be easily convertible back to JSON and have all methods available to them that come with being an `MTLModel` subclass.

### [AFNetworking](https://github.com/AFNetworking/AFNetworking)
This framework has become the gold standard for easily working with modern web APIs with asyncrony in mind. We also leverage some extensions to AFNetworking that bridge it into the ReactiveCocoa world, giving us the core of how we operate the client object.

### So, what do I need to know?
Read the RAC documentation. Really. It's not much, and it will help you get you up in running if you're not already, with RAC and the functional-reactive mindset that accompanies it.

## Usage

To use CocoaBloc for unauthenticated requests, or for testing authenticated requests with a static token during development, all you need to do is instantiate a new client.

```objc
// Creates an unauthenticated client. This client can still be used to access API
// endpoints that do not require authentication (read-only, public data).
// NOTE: You may set the OAuth token of this client manually for testing purposes
SBClient *client = [SBClient new];
```

The proper way to obtain an authenticated client for StageBloc user is to use our pre-baked OAuth view controller, which lets the user securely log on on StageBloc's site (in-app web view), which feeds back a token that we use to craft you an `SBClient` that has:
  1. A reference to that token
  2. A populated model object for currently signed in user
  3. Access to make any authenticated requests

```objc
SBAuthenticationViewController *authVC = [SBAuthenticationViewController new];

// Subscription to this presentation signal will show the view controller.
// Cancellation or completion of the subscription will dismiss it.
// Upon success, the signal will send a next value of the authenticated client.
  @weakify(client);
  [[[authVC presentFromParent:self.window.rootViewController]
      flattenMap:^RACStream *(NSString *authorizationCode) {
          @strongify(client);
          return [client logInWithAuthorizationCode:authorizationCode];
      }]
      subscribeNext:^(SBUser *loggedInUser) {
          // Success
      }
      error:^(NSError *error) {
          // Handle error
      }
      completed:^{
          // Signal completed. This will happen if there is no error, but if no
          // next value has been sent yet, this means that the
          // user pressed cancel and dismissed log in view.
      }];
```

## Documentation
[appledoc](https://github.com/tomaz/appledoc) is used during each build to generate a docset from our header comments. It is mandatory that you document classes and methods that are public in the framework. The generated documentation files can be important into Dash quite easily and provides instantly updated, Apple-style, searchable/indexed documentation each build without any additional effort.

### Dash Setup
If you're a fan of [Dash](https://itunes.apple.com/us/app/dash/id458034879?ls=1&mt=12), the awesome documentation viewer app for OS X, you can import this dynamic docset and have always-updated docs from your last build.

![](https://cldup.com/MZLkzQDmed.png)

Just press the `+` button, navigate to `<this-repository>/Doc` and select the docset (you will need to compile at least once for this to be present). Now you have nice Apple-esque docs to work with rather than having to go header-hunting.

## Contributing

CocoaBloc will expand as the [StageBloc API](https://stagebloc.com/developers/api) expands and should theoretically have all available API endpoints implemented at any point in time. If you'd like to contribute and aid in this, check out the `Guidelines.txt` file!
