//
//  extensions.swift
//  Insta
//
//  Created by 18529728 on 27.04.2021.
//

import UIKit

extension Collection {
    /// Возвращает элемент по указанному индексу, если он находится в пределах границ, иначе nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension UIColor {
    static let purple = UIColor(red: 0.544, green: 0.578, blue: 0.933, alpha: 1)
    static let purpleText = UIColor(red: 0.376, green: 0.353, blue: 0.757, alpha: 1)
    static let textLight = UIColor(red: 0.459, green: 0.478, blue: 0.58, alpha: 1)
    static let redLine = UIColor(red: 1, green: 0.225, blue: 0.037, alpha: 1)
    static let redDate = UIColor(red: 0.804, green: 0.149, blue: 0.271, alpha: 1)
    static let redBack = UIColor(red: 0.992, green: 0.929, blue: 0.941, alpha: 1)
    static let backLight = UIColor(red: 0.957, green: 0.957, blue: 0.965, alpha: 1)
    static let backLight12 = UIColor(red: 0.957, green: 0.957, blue: 0.965, alpha: 0.12)
    static let grayClock = UIColor(red: 0.623, green: 0.656, blue: 0.729, alpha: 1)
    static let orangeDate = UIColor(red: 1, green: 0.69, blue: 0.225, alpha: 1)
    static let orangeLight = UIColor(red: 0.996, green: 0.945, blue: 0.894, alpha: 1)
    static let grayAccount = UIColor(red: 0.867, green: 0.867, blue: 0.894, alpha: 1)
    static let projectShadow = UIColor(red: 0.23, green: 0.318, blue: 0.4, alpha: 0.15)
    static let grayFooter = UIColor(red: 0.941, green: 0.949, blue: 0.953, alpha: 1)
    static let darkBlue = UIColor(red: 0.161, green: 0.2, blue: 0.286, alpha: 1)
    static let gradient1Start = UIColor(red: 0.443, green: 0.479, blue: 0.858, alpha: 1)
    static let gradient1End = UIColor(red: 0.551, green: 0.443, blue: 0.858, alpha: 1)
    static let lightGreen = UIColor(red: 0.224, green: 0.792, blue: 0.656, alpha: 1)
    static let tasksBack = UIColor(red: 0.918, green: 0.918, blue: 0.937, alpha: 1)
    static let lightBlue = UIColor(red: 0.545, green: 0.576, blue: 0.933, alpha: 1)
    static let searchPlaceholder = UIColor(red: 0.922, green: 0.922, blue: 0.961, alpha: 0.6)
    static let searchDarkPlaceholder = UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.6)
    static let datePickerDateSelect = UIColor(red: 0.345, green: 0.337, blue: 0.839, alpha: 1)
    static let leftTaskGradient = UIColor(red: 1, green: 0.224, blue: 0.369, alpha: 1)
    static let highPriority = UIColor(red: 1, green: 0.225, blue: 0.37, alpha: 1)
    static let lightestGray = UIColor(red: 0.231, green: 0.263, blue: 0.337, alpha: 1)
    static let searchDatePickerLines = UIColor(red: 0.902, green: 0.902, blue: 0.902, alpha: 0.14)
    static let searchDateSeparatorLine = UIColor(red: 0.138, green: 0.138, blue: 0.138, alpha: 0.12)
    static let searchTasksFooterText = UIColor(red: 0.624, green: 0.416, blue: 0.773, alpha: 1)
    static let addTaskViewBackgroundColor = UIColor(red: 0.357, green: 0.741, blue: 0.649, alpha: 1)
    static let tasksTabColor = UIColor(red: 0.918, green: 0.616, blue: 0.42, alpha: 1)
    static let userTasksGreetingGradientStart = UIColor(red: 41.0/255.0, green: 51.0/255.0, blue: 73.0/255.0, alpha: 0)
    static let xmarkGrey = UIColor(red: 0.873, green: 0.873, blue: 0.887, alpha: 1)
    static let lightestGrayClock = UIColor(red: 0.322, green: 0.341, blue: 0.388, alpha: 1)
    static let redPin = UIColor(red: 0.933, green: 0.592, blue: 0.439, alpha: 1)
    static let lightGray = UIColor(red: 0.498, green: 0.533, blue: 0.616, alpha: 1)
    static let switchNotificationColor = UIColor(red: 0.204, green: 0.78, blue: 0.349, alpha: 1)
    static let dashboardTabColor = UIColor(red: 234 / 255, green: 113 / 255, blue: 104 / 255, alpha: 1)
    static let dashboardCellSeparator = UIColor(red: 0.352, green: 0.381, blue: 0.483, alpha: 1)
    static let dashboardDeleteBackground = UIColor(red: 0.353, green: 0.38, blue: 0.482, alpha: 1)
    static let dashboardExpired = UIColor(red: 0.827, green: 0.325, blue: 0.42, alpha: 1)
}

