source 'https://github.com/CocoaPods/Specs.git'

inhibit_all_warnings!

    pod 'ReactiveCocoa'

workspace 'CocoaBloc'
xcodeproj './Projects/Library/CocoaBloc.xcodeproj'

target :CocoaBloc do
    pod 'SDWebImage'
    pod 'AFNetworking'
    pod 'AFNetworking-RACExtensions'
    pod 'ReactiveViewModel'
    pod 'Mantle'
    pod 'PureLayout'
end

target :CocoaBlocTests do
    pod 'Specta', :git => "https://github.com/specta/specta.git"
    pod 'Expecta'
end

target :"CB Test App" do
    pod 'CocoaBloc', :path => "./"
end
