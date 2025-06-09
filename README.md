//
//  README.md
//  Find a Mechanic
//
//  Created by Rajitha Gayashan on 2025-04-26.
//

# Find A Mechanic

## Overview
Find A Mechanic is an iOS application designed to help users find and connect with nearby mechanics. The app allows users to browse mechanic listings, view detailed information, and send inquiries directly through the app.

## Features
- Map-based search to find mechanics in your area
- List view of all nearby mechanics
- Detailed mechanic profiles with ratings, services, and contact information
- Inquiry system to contact mechanics directly
- User reviews and ratings
- Form validation for contact information

## Technical Details

### Architecture
The app follows a modular architecture with clear separation of concerns:
- MVVM pattern for view controllers
- Delegate pattern for communication between components
- Factory pattern for UI elements creation
- Coordinator pattern for complex setup operations

### Project Structure
```
FindAMechanic/
│
├── FindAMechanic/
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   ├── Info.plist
│   ├── Config-Dev.plist
│   ├── Config-Prod.plist
│   └── Assets.xcassets/
│
├── Storyboards/
│   ├── Main.storyboard
│   └── LaunchScreen.storyboard
│
├── ViewControllers/
│   ├── SplashViewController/
│   ├── MachanicList/
│   │   ├── MechanicListViewController.swift
│   │   └── MechanicTableViewCell.swift
│   ├── MechanicDetail/
│   │   ├── MechanicDetailViewController.swift
│   │   └── MechanicDetailComponents.swift
│   └── Inquiry/
│       ├── InquiryPopupViewController.swift
│       ├── InquiryUIFactory.swift
│       └── InquiryFormHandler.swift
│
├── Models/
│   ├── Mechanic.swift
│   ├── InquiryForm.swift
│   └── User.swift
│
├── Services/
│   ├── LocationService.swift
│   ├── NetworkService.swift
│   └── DataService.swift
│
├── Utilities/
│   ├── Constants.swift
│   ├── Extensions/
│   │   ├── UIView+Extensions.swift
│   │   └── String+Extensions.swift
│   └── Helpers/
│       ├── AlertHelper.swift
│       └── LocationHelper.swift
│
└── Resources/
    └── JSON/ (for mock data)
```

## Key Components

### InquiryPopupViewController
Handles the inquiry form functionality:
- Form validation and submission
- User input handling
- UI feedback

### MechanicListViewController
Manages the list of mechanics:
- Displays mechanic listings
- Handles search functionality
- Table view management

### MechanicDetailViewController
Shows detailed mechanic information:
- Mechanic profile display
- Service information
- Contact details

## Requirements
- iOS 16.0+
- Xcode 14.0+
- Swift 5.7+
- CocoaPods for dependency management

## Dependencies
- Alamofire: For network requests and API communication

## Future Improvements
- Implement user authentication
- Add appointment scheduling
- Implement push notifications
- Add unit and UI tests
- Support more localization options
