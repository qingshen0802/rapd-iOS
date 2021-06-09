# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require 'bubble-wrap'
require 'bubble-wrap/location'
require 'bubble-wrap/media'
require 'bundler'
Bundler.require
require 'sugarcube-attributedstring'

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  app.pods do
    pod 'AFNetworking', '1.3.4'
    pod 'FileMD5Hash'
    pod 'RestKit', '0.24.1'
    pod 'SDWebImage'
    pod 'NSDate+TimeAgo'
    pod 'SVPullToRefresh'
    pod 'SWTableViewCell'
    pod 'SVProgressHUD'
    pod 'ActionSheetPicker-3.0', '~> 2.0.4'
    pod 'TRLKBadgeView'
    pod 'libPusher', '1.6.1'
    pod 'Stripe'
    pod 'HockeySDK'
    pod 'SCFacebook'
    pod 'MFSideMenu'
    pod 'BDGShare'
    pod 'CardIO'
    pod "EFCircularSlider", "~> 0.1.0"
    pod 'BEMSimpleLineGraph'
    pod 'KIImagePager'
    pod 'BKMoneyKit'
    pod 'VMaskTextField'
    pod 'Google-Maps-iOS-SDK'
    pod 'UITextView+Placeholder'
  end

  app.vendor_project('vendor/RSA', :static)

  FB_APP_ID = '173075966512385'
  app.info_plist['FacebookAppID'] = FB_APP_ID
  app.info_plist['FacebookDisplayName'] = 'Trat.to'
  app.info_plist['LSApplicationQueriesSchemes'] = ['fbapi', 'fb-messenger-api', 'fbauth2', 'fbshareextension']
  app.info_plist['CFBundleURLTypes'] = [{ 'CFBundleURLSchemes' => ["fb#{FB_APP_ID}"] }]

  app.info_plist['UIViewControllerBasedStatusBarAppearance'] = true
  app.info_plist['NSAppTransportSecurity'] = {'NSAllowsArbitraryLoads' => true}
  app.frameworks += %w(QuartzCore CoreGraphics UIKit AdSupport Accounts Social MessageUI)

  app.name = 'Tratto'
  app.version = '1.0.18'
  app.identifier = 'br.com.kcapt.tratto'
  # app.deployment_target = "8.0"
  app.interface_orientations = [:portrait]
  app.device_family = [:iphone]
  app.info_plist['CFBundleShortVersionString'] = app.version
  app.info_plist['UIBackgroundModes'] = ['fetch', 'remote-notification']
  app.info_plist['NSLocationAlwaysUsageDescription'] = 'Trat.to wants to access your location'
  app.info_plist['NSLocationWhenInUseUsageDescription'] = 'Trat.to wants to access your location'
  app.info_plist['NSPhotoLibraryUsageDescription'] = "Trat.to wants to access your photos"

  # app.development do
  #   app.entitlements["aps-environment"] = "development"
  #
  #   app.codesign_certificate = MotionProvisioning.certificate(
  #     type: :development,
  #     platform: :ios)
  #
  #   app.provisioning_profile = MotionProvisioning.profile(
  #     bundle_identifier: app.identifier,
  #     app_name: app.name,
  #     platform: :ios,
  #     type: :development)
  # end
  #
  # app.release do
  #   app.entitlements["aps-environment"] = "production"
  #
  #   app.codesign_certificate = MotionProvisioning.certificate(
  #     type: :distribution,
  #     platform: :ios)
  #
  #   app.provisioning_profile = MotionProvisioning.profile(
  #     bundle_identifier: app.identifier,
  #     app_name: app.name,
  #     platform: :ios,
  #     type: :distribution)
  # end

  if app.hockeyapp?
    app.hockeyapp do
      set :api_token, '81055aeb3f4843a7ac5cd9b3b10a45fb'
      set :beta_id, '9cb346e6badd4f8aa6b54fabeece293a'
      set :status, "2"
      set :notify, "0"
      set :notes_type, "1"
    end
  end

  app.fonts = ['Roboto regular.ttf', 'Roboto 100.ttf', 'Roboto 300.ttf', 'Roboto 500.ttf', 'Roboto 700.ttf', 'Roboto 900.ttf', 'Roboto italic.ttf']

end
