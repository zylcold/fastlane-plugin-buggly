# buggly plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-buggly)

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-buggly`, add it to your project by running:

```bash
fastlane add_plugin buggly
```

## About buggly

上传Bugly

**Note to author:** Add a more detailed description about this plugin here. If your plugin contains multiple actions, make sure to mention them here.

Basic usage
Just add the action upload_to_buggly to your lanes.

sample code:

    lane :beta do
      increment_build_number 
      gym
      buggly(appId:your_buggly_app_id,
              appKey:your_buggly_app_key)
    end
You can found your buggly app id and app key when you register your app in buggly. For more infomation about buggly see: https://bugly.qq.com

You can also set the buggly app id and app key in the Appfile.

Appfile:

    app_identifier "xxx.xxx.xxxx" # The bundle identifier of your app
    apple_id "xxxx@xxxx.com" # Your Apple email address

    buggly_app_id "your_buggly_app_id"
    buggly_app_key "your_buggly_app_key"
    More Reference can be shown by following command.

fastlane action upload_to_buggly
## Run tests for this plugin

To run both the tests, and code style validation, run

```
rake
```

To automatically fix many of the styling issues, use
```
rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
