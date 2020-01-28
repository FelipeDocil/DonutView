platform :ios, '13.2'

inhibit_all_warnings!

target 'DonutView' do
  use_frameworks!

  pod 'HGCircularSlider'

  target 'DonutViewTests' do
    inherit! :search_paths
    pod "Quick", "2.2.0"
    pod "Nimble", "8.0.4"
    pod "SnapshotTesting", "1.6.0"
    pod "SnapshotTesting-Nimble", :git => "https://github.com/FelipeDocil/swift-snapshot-testing-nimble.git", :branch => "master"
  end

  target 'DonutViewUITests' do
    # inherit! :search_paths
  end

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
        config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
        config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
        config.build_settings['ENABLE_BITCODE'] = "NO"
      end
    end
  end
end