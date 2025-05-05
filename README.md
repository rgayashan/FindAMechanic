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

### Recent Refactoring
The app has undergone significant refactoring to improve its maintainability, readability, and performance:

#### 1. View Controller Refactorings
- **MechanicListViewController**: Reduced from 343 to ~150 lines by extracting search and table handling
- **MechanicDetailViewController**: Reduced from 741 to ~230 lines using component extraction and delegates
- **InquiryPopupViewController**: Reduced from 380 to ~109 lines via delegation and composition

#### 2. UI Improvements
- **Form Validation**: Added email and phone number validation with visual feedback
- **Keyboard Handling**: Automatically adjusts view when keyboard appears
- **Touch Handling**: Dismisses keyboard when tapping outside input fields

#### 3. Code Organization
We've organized the code into specialized components:
- **UI Factories**: Create UI elements with consistent styling
- **Layout Managers**: Handle layout constraints
- **Delegate Handlers**: Manage delegate methods
- **Validation**: Validate user inputs with visual feedback
- **Coordinators**: Orchestrate setup and configuration

### Project Structure
```
Find a Mechanic/
│
├── App/
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   ├── Info.plist
│   └── Assets.xcassets/
│
├── Storyboards/
│   ├── Main.storyboard
│   ├── LaunchScreen.storyboard
│   └── CustomCells/
│       └── MechanicTableViewCell.xib
│
├── ViewControllers/
│   ├── Home/
│   │   └── MapViewController.swift
│   ├── MechanicList/
│   │   ├── MechanicListViewController.swift
│   │   ├── MechanicListSearchHandler.swift
│   │   ├── MechanicListTableHandler.swift
│   │   └── MechanicTableViewCell.swift
│   ├── MechanicDetail/
│   │   ├── MechanicDetailViewController.swift
│   │   ├── MechanicDetailComponents.swift
│   │   ├── MechanicDetailLayout.swift
│   │   ├── MechanicDetailViewBuilder.swift
│   │   ├── MechanicDetailTableDelegate.swift
│   │   └── MechanicDetailMapDelegate.swift
│   ├── Inquiry/
│   │   ├── InquiryPopupViewController.swift
│   │   ├── InquiryUIFactory.swift
│   │   ├── InquiryLayoutConstraints.swift
│   │   ├── InquiryFormHandler.swift
│   │   ├── InquiryDelegateHandler.swift
│   │   ├── InquiryKeyboardHandler.swift
│   │   ├── InquiryValidationDisplay.swift
│   │   ├── InquiryValidationSetup.swift
│   │   └── InquirySetupCoordinator.swift
│   ├── Authentication/ (if needed)
│   │   ├── LoginViewController.swift
│   │   └── RegisterViewController.swift
│   └── Profile/ (if needed)
│       └── ProfileViewController.swift
│
├── Models/
│   ├── Mechanic.swift
│   ├── InquiryForm.swift
│   ├── Appointment.swift
│   ├── Review.swift
│   └── User.swift
│
├── Services/
│   ├── LocationService.swift
│   ├── NetworkService.swift
│   ├── DataService.swift
│   ├── InquiryService.swift
│   └── AuthenticationService.swift
│
├── Utilities/
│   ├── Constants.swift
│   ├── Extensions/
│   │   ├── UIView+Extensions.swift
│   │   ├── MKMapView+Extensions.swift
│   │   └── String+Extensions.swift
│   ├── Helpers/
│   │   ├── AlertHelper.swift
│   │   ├── LocationHelper.swift
│   │   └── InquiryPopupHelper.swift
│   └── Protocols/
│       ├── MechanicListDelegate.swift
│       └── InquiryPopupDelegate.swift
│
└── Resources/
    ├── Fonts/
    └── JSON/ (for mock data)
```

## Key Components Explained

### InquiryPopupViewController
This component has been heavily refactored to improve maintainability:

- **InquiryUIFactory**: Creates UI components with consistent styling
- **InquiryLayoutConstraints**: Manages all layout constraints
- **InquiryFormHandler**: Handles form data and validation logic
- **InquiryDelegateHandler**: Manages text field and text view delegates
- **InquiryKeyboardHandler**: Handles keyboard appearance and dismissal
- **InquiryValidationDisplay**: Shows validation errors to the user
- **InquirySetupCoordinator**: Orchestrates the setup of all components

### MechanicListViewController
Streamlined through component extraction:

- **MechanicListSearchHandler**: Manages search functionality
- **MechanicListTableHandler**: Handles table view operations

### MechanicDetailViewController
Improved through component extraction:

- **MechanicDetailComponents**: Creates UI components
- **MechanicDetailLayout**: Manages layout constraints
- **MechanicDetailViewBuilder**: Builds content views
- **MechanicDetailTableDelegate**: Handles table view delegation
- **MechanicDetailMapDelegate**: Manages map view delegation

## Validation Features
- Email format validation
- Phone number format validation
- Required field validation
- Visual error feedback
- Inline validation as user types

## Requirements
- iOS 14.0+
- Xcode 13.0+
- Swift 5.0+

## Future Improvements
- Add unit and UI tests
- Implement user authentication
- Add appointment scheduling
- Implement push notifications
- Support more localization options
