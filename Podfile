# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'


target 'AutoLocalization' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks! :linkage => :static

  # Pods for AutoLocalization
  pod 'GoogleMLKit/Translate', '3.2.0'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings["ONLY_ACTIVE_ARCH"] = "YES"
    end
  end
end
