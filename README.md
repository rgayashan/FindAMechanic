//
//  README.md
//  Find a Mechanic
//
//  Created by Rajitha Gayashan on 2025-04-26.
//

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
│   │   └── MechanicTableViewCell.swift
│   ├── MechanicDetail/
│   │   └── MechanicDetailViewController.swift
│   ├── Authentication/ (if needed)
│   │   ├── LoginViewController.swift
│   │   └── RegisterViewController.swift
│   └── Profile/ (if needed)
│       └── ProfileViewController.swift
│
├── Models/
│   ├── Mechanic.swift
│   ├── Appointment.swift
│   ├── Review.swift
│   └── User.swift
│
├── Services/
│   ├── LocationService.swift
│   ├── NetworkService.swift
│   ├── DataService.swift
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
│   │   └── LocationHelper.swift
│   └── Protocols/
│       └── MechanicListDelegate.swift
│
└── Resources/
    ├── Fonts/
    └── JSON/ (for mock data)
