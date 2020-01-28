# Clearscore Challenge App
![Xcode](https://img.shields.io/badge/Xcode-11.3-blue.svg) ![Swift 5.1](https://img.shields.io/badge/Swift-5.1-orange.svg) ![min iOS](https://img.shields.io/badge/min%20iOS-13.3-lightgrey.svg)


## Getting Started
If you are ready to play with the project just open `DonutView.xcworkspace`. :rocket:

### Installing

Before open the project and build run the following command to install all the code dependencies:
```bash
pod install
swift package update
```

## Development
For this project I use [VIPER](https://www.objc.io/issues/13-architecture/viper/) as the architecture, it's important to understand this concept:

The reason behind why I choose VIPER, even tough the project are very simple, is because one of the requirements says "production grade" also "features that might be added in the future". Following those 2 requirements I though of VIPER being a good solution to decentralise UI from the logic, although allowing a much easier refactor on the Dashboard screen (i.e. adding new elements to this screen, changing completly UI)

**VIPER Diagram**

![diagram](https://i.imgur.com/YHOzL9s.png)

**VIPER Template**

For this project there's a [Xcode template](https://github.com/FelipeDocil/PokemonChallenge/blob/master/VIPER/Templates/) to automatically create a VIPER Module and reduce the manual boilerplate code.

To install the template locally just copy the `.xctemplate` files at `~/Library/Developer/Xcode/Templates/<custom_folder_name>` and restart your Xcode.

## Testing

All the tests runs on a iPhone 11 (13.3).

UI Tests are created on using Gherkin language and is stored on `DonutViewUITests/features` folder

A 3rd party library [Capriccio](https://github.com/shibapm/capriccio) generates the Swift code using this [template](https://github.com/FelipeDocil/PokemonChallenge/blob/master/VIPER/Templates/Gherkin.stencil) to generate the steps.

Greate article about [Gherkin language](https://automationpanda.com/2017/01/30/bdd-101-writing-good-gherkin/)

## Decisions

- **Cocoapods**: 
    The decision to use Cocoapods was because I added 3rd Party dependencies to Tests, such as Quick/Nimble and SnapshotTests. It could be done without Quick/Nimble, but I believe SnapshotTest is a valid test.
    Also I added a 3rd party library to handle the Donut view. I decided to do so I could focus on the archicture and tests over the UI. It's a good library, it has many stars and it's very customisable. If in the future are asked to do on-site the architecture also allows it, just create a custom View that has "similar" attributes and the View can use it without much changes.
- **Swift Package Manager**: 
    In order to support Capriccio I decided to use SPM, also a script was added in `DonutViewUITest` to automatically generate the Gherkin files.
- **Programmatically over Storyboard**: 
    Just a personal preference, wouldn't mind to do it using Storyboard. Or even SwiftUI, the decision not to use SwiftUI was because I had to create a custom View to create a bridge from the UIKit (3rd party Donut View) and SwiftUI and it was a risky to do it since I wasn't sure what would happen. 