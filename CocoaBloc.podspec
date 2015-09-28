Pod::Spec.new do |s|
    s.name = 'CocoaBloc'
    s.version = '1.0.7'
    s.authors = {   'John Heaton'   => 'pikachu@stagebloc.com',
                    'David Warner'  => 'spiderman@stagebloc.com',
                    'Josh Holat'    => 'bumblebee@stagebloc.com' }
    s.social_media_url = 'https://twitter.com/StageBloc'
    s.homepage = 'https://github.com/stagebloc/CocoaBloc'
    s.summary = 'StageBloc iOS SDK for the StageBloc REST API'
    s.description = 'An Objective-C(Swift-compatible) library for using the StageBloc v1 REST API.'
    s.source = { :git => 'https://github.com/stagebloc/CocoaBloc.git',
                 :tag => '1.0.7' }
    s.requires_arc = true
    s.license = { :type => 'MIT', :file => 'LICENSE' }
    s.ios.deployment_target = '8.0'
    s.osx.deployment_target = '10.9'

    # Every subspec uses RAC
    s.dependency 'ReactiveCocoa', '~> 2.0'

    s.subspec 'API' do |ss|
        ss.dependency 'AFNetworking', '~> 2.0'
        ss.dependency 'AFNetworking-RACExtensions', '~> 0.1.6'
        ss.dependency 'Mantle', '~> 1.0'

        ss.public_header_files = 'Pod/Classes/API/**/*.h'
        ss.private_header_files = 'Pod/Classes/Internal/*.h'
        ss.source_files = 'Pod/Classes/Internal/*', 'Pod/Classes/API/**/*'
    end

    # s.subspec 'UIKit' do |ss|
    #     ss.ios.dependency 'CocoaBloc/API'
    #     ss.ios.dependency 'PureLayout', '~> 2.0'
    #     ss.ios.dependency 'CocoaBloc-UI', '~> 0.0.3'
    #     ss.ios.dependency 'SZTextView', '~> 1.2'
    #
    #     ss.ios.source_files = 'Pod/Classes/UIKit/*'
	  #   ss.ios.resources = ['Pod/Assets/UIKit/*']
    # end
end
