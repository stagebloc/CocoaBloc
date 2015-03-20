source 'https://github.com/CocoaPods/Specs.git'

inhibit_all_warnings!

workspace 'CocoaBloc'
xcodeproj './Projects/Library/CocoaBloc.xcodeproj'

target :CocoaBloc do
    pod 'ReactiveCocoa'
    pod 'SDWebImage'
    pod 'AFNetworking'
    pod 'AFNetworking-RACExtensions'
    pod 'ReactiveViewModel'
    pod 'Mantle'
    pod 'PureLayout'
end

target :CocoaBlocTests do
    pod 'Specta', '~> 0.4'
    pod 'Expecta'
end

target :"CB Test App" do
    pod 'CocoaBloc', :path => "./"
end
