# AutoLocalization Framework

AutoLocalization is a Swift framework designed to simplify and streamline the localization process in iOS applications. With AutoLocalization, you can easily manage and switch between multiple languages in your app, ensuring a smooth and efficient localization workflow.

## Installation

To integrate AutoLocalization into your Xcode project, follow these steps:

## Usage

### Basic Localization in a View Controller

To use AutoLocalization in your view controller, follow these steps:

1. Import the AutoLocalization framework
   
```swift
import AutoLocalization
```

2. To localize interface of your UIViewController:
   First use ```setViewControllerToLocalize``` method to set View Controller you would like to localize.
   
   Then call method ```localizeInterface(from:, to:, options:)``` passing language of your interface, language you would like to localize interface to and localization options where you can define which UIKit interface elements you want to localize.
   
   You can choose different options of the below:
   1) Only one type of elements, e.g. ```.labels```
   2) Multiple types of elements, e.g. ```[.labels, .buttons]```
   3) All types of elements excluding some, e.g. ```.all.excluding(.textFields)```
   4) All possible types of elements ```.all```

The example of interface localization at the View Controller appearance:

```swift
override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    AutoLocalization.shared
      .setViewControllerToLocalize(self)
      .localizeInterface(from: .english, to: .ukrainian, options: .all)
}
```

> [!IMPORTANT]
> Note, that your View Controller must already be on the screen to localize elements, so here we call ```localizeInterface(from:, to:, options:)``` **EXACTLY** in ```viewDidAppear``` method.

### Language Selection List in a Separate ViewController

You can also create a language selection list in a separate view controller. Here's an example:

1. Import the AutoLocalization framework.
   
```swift
import AutoLocalization
```

2. Create an instance of UILanguageListView in your view controller.
   
```swift
override func viewDidLoad() {
    super.viewDidLoad()
    
    let languageListView = UILanguageListView(self, options: .all, onLanguageChosenAction: { _ in
        self.dismiss(animated: true)
    })
    view.addSubview(languageListView)
}
```

This setup allows users to select their preferred language from a list, triggering the chosen language's localization.
