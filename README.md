# MZStoryPreviewer

[![CI Status](https://img.shields.io/travis/mozead1996/MZStoryPreviewer.svg?style=flat)](https://travis-ci.org/mozead1996/MZStoryPreviewer)
[![Version](https://img.shields.io/cocoapods/v/MZStoryPreviewer.svg?style=flat)](https://cocoapods.org/pods/MZStoryPreviewer)
[![License](https://img.shields.io/cocoapods/l/MZStoryPreviewer.svg?style=flat)](https://cocoapods.org/pods/MZStoryPreviewer)
[![Platform](https://img.shields.io/cocoapods/p/MZStoryPreviewer.svg?style=flat)](https://cocoapods.org/pods/MZStoryPreviewer)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

![GIF](https://github.com/mozead1996/MZStoryPreviewer/blob/master/README%20FILES/ezgif-7-6c955d60668c.gif)


## Requirements

## Installation

MZStoryPreviewer is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MZStoryPreviewer'
```
## Usage 

In your storyboard file give your UIView class MZStoryPreviewer and make it inherite from MZStoryPreviewer
![doc](https://github.com/mozead1996/MZStoryPreviewer/blob/master/README%20FILES/Screen%20Shot%202020-10-29%20at%201.00.53%20AM.png)

Then drag outlet of your view and ```import MZStoryPreviewer``` 
After that conform your ViewController to ```MZStoryPreviewerDataSource``` and ``` MZStoryPreviewerDelegate ```
```swift
extension ViewController: MZStoryPreviewerDataSource, MZStoryPreviewerDelegate {
    
    func mzStoryPreviewer(_ previewer: MZStoryPreviewer, didSelectItemAt: Int) {
        
    }
    func mzStoryPreviewer(storyUsersFor previewer: MZStoryPreviewer) -> [MZStoryUser] {
        return users
    }
}
```

By assuming that each user have an array of stories and each story has a type , you have two Protocols create your custom models for 
User and Story DataModel and conform to ```MZStoryUser``` for user  and ```MZStoryItem``` for the story 
```swift
public protocol MZStoryUser{
    var userName : String{get}
    var userImageURLPath : String?{get}
    var userStoryItems : [MZStoryItem]{get}
}
//-----------------------------------
public protocol MZStoryItem {
    var type: MZStoryItemType { get set }
    var image: UIImage? { get }
    var url: URL? { get }
    var duration  : TimeInterval {get set}
}
```
## Author

mozead1996, mohamedzead2021@gmail.com

## License

MZStoryPreviewer is available under the MIT license. See the LICENSE file for more info.
