Pod::Spec.new do |s|
    s.name = 'CocoaBloc'
    s.version = '0.0.5'
    s.authors = {   'John Heaton'   => 'pikachu@stagebloc.com',
                    'Mark Glagola'  => 'mark@stagebloc.com',
                    'David Warner'  => 'spiderman@stagebloc.com',
                    'Josh Holat'    => 'bumblebee@stagebloc.com' }
    s.social_media_url = 'https://twitter.com/StageBloc'
    s.homepage = 'https://github.com/stagebloc/CocoaBloc'
    s.summary = 'StageBloc Cocoa SDK for the StageBloc v1 API'
    s.description = 'An Objective-C(Swift-compatible) library for using the StageBloc v1 REST API.'
    s.source = { :git => 'https://github.com/stagebloc/CocoaBloc.git' }
    s.requires_arc = true
    s.ios.deployment_target = '7.0'
    s.osx.deployment_target = '10.9'

    # Every subspec uses RAC
    s.dependency 'ReactiveCocoa'

    # Umbrella header
    s.source_files = 'Source/CocoaBloc/CocoaBloc.h'

    s.subspec 'API' do |ss|
        ss.dependency 'AFNetworking'
        ss.dependency 'AFNetworking-RACExtensions'
        ss.dependency 'Mantle'

        ss.source_files = 'Source/CocoaBloc/API/{Client,Models}/*.{h,m}', 'Source/CocoaBloc/Internal/Categories/*.{h,m}', 'Source/CocoaBloc/API/*.h'
        ss.private_header_files = 'Source/CocoaBloc/Internal/**/*.h'
    end

    s.subspec 'UI' do |ss|
        ss.dependency 'CocoaBloc/API'
        ss.dependency 'PureLayout'

        ss.header_mappings_dir = 'Source/CocoaBloc/OAuth'
        ss.source_files = 'Source/CocoaBloc/OAuth/*.{h,m}'
    end

end
