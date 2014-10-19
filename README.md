CocoaBloc
=========

CocoaBloc enables any Cocoa developer to have instant access to the StageBloc API via pre-built functions and models. As such, it should allow for much easier and faster development with the StageBloc API in mobile applications. There are two elements to CocoaBloc, the API and the UI elements.

## Setup

CocoaBloc can easily be added to any project via [CocoaPods](http://cocoapods.org/). Simply add the CocoaBloc pod to your `Podfile` and run a `pod install`.
```
pod "CocoaBloc"
```

Once the source code is in your project, the one line of code below is all that is required to make CocoaBloc ready. A client ID and secret can be made within the developers section of your account on the StageBloc backend.

```
[SBClient setClientID:@"client_id" clientSecret:@"client_secret"];
```

## Usage

To use CocoaBloc, all you need to do is instantiate a new client.

```
SBClient *client = [SBClient new];
```

## Contributing

CocoaBloc will expand as the [StageBloc API](https://stagebloc.com/developers/api) expands and should theoretically have all available API endpoints implemented at any point in time. If you'd like to contribute and aid in this, check out the `Guidelines.txt` file!
