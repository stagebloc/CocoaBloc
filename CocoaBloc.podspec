Pod::Spec.new do |s|
    s.name = 'CocoaBloc'
    s.version = '0.0.6'
    s.authors = {   'John Heaton'   => 'pikachu@stagebloc.com',
                    'Mark Glagola'  => 'mark@stagebloc.com',
                    'David Warner'  => 'spiderman@stagebloc.com',
                    'Josh Holat'    => 'bumblebee@stagebloc.com' }
    s.social_media_url = 'https://twitter.com/StageBloc'
    s.homepage = 'https://github.com/stagebloc/CocoaBloc'
    s.summary = 'StageBloc Cocoa SDK for the StageBloc v1 API'
    s.description = 'An Objective-C(Swift-compatible) library for using the StageBloc v1 REST API.'
    s.source = { :git => 'https://github.com/stagebloc/CocoaBloc.git', :branch => "fix/restructure" }
    s.requires_arc = true
    s.license = { :type => 'MIT', :file => 'LICENSE' }
    s.ios.deployment_target = '7.0'
    s.osx.deployment_target = '10.9'

    # Every subspec uses RAC
    s.dependency 'ReactiveCocoa'

    # s.default_subspecs = 'API'

    # Umbrella header
    s.source_files = 'Pod/Classes/CocoaBloc.h'

    s.subspec 'API' do |ss|
        ss.dependency 'AFNetworking'
        ss.dependency 'AFNetworking-RACExtensions'
        ss.dependency 'Mantle'

        ss.source_files = 'Pod/Classes/Internal/*', 'Pod/Classes/API/**/*'
        ss.private_header_files = 'Pod/Classes/Internal/*.h'
    end

    s.subspec 'UIKit' do |ss|
        ss.dependency 'CocoaBloc/API'
        ss.dependency 'PureLayout'

        ss.source_files = 'Pod/Classes/UIKit/*'
    end
end
