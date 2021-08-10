//
//  StringFormatter.swift
//  Vita
//
//  Created by Chappy Asel on 8/7/21.
//

import Foundation

enum DateFormat: Int {
    /// MMMM d
    case normal
    /// MMM d
    case short
    /// E, MMMM d
    case shortWeekday
    /// EEEE, MMMM d
    case longWeekday
    /// MMMM d ''yy
    case year = 10
    /// MMM d ''yy
    case shortYear
    /// E, MMM d ''yy
    case shortWeekdayYear
    /// h:mm a, MMM d ''yy
    case full
    /// MMMM d yyyy
    case longYear = 20
    /// MMMM yyyy
    case month
}

protocol VStringFormatter {
    
    // MARK: - Dates
    
    /// Formats date to the specificed date format
    static func string(for date: Date, format: DateFormat) -> String

    /// Formats date to the specificed date format with attributes (eg. Aug 7_th_ '21)
    static func string(for date: Date,
                       format: DateFormat,
                       attributes: [NSAttributedString.Key: Any]?,
                       suffixAttributes: [NSAttributedString.Key: Any]?) -> NSAttributedString

    // MARK: - Numbers

    /// Formats to up to 3 decimal places if needed with shortening (eg. 12345.12 -> "12.3k")
    static func string(for number: Double) -> String

    static func string(for number: Double, unit: String?) -> String

    static func string(for number: Double,
                       attributes: [NSAttributedString.Key: Any],
                       unit: String?,
                       unitAttributes: [NSAttributedString.Key: Any]?) -> NSAttributedString

    /// Warning: always use string(for value:) to avoid incorrectly attributed multipliers (eg. 'k')
    static func string(for numberString: String,
                       attributes: [NSAttributedString.Key: Any],
                       unit: String?,
                       unitAttributes: [NSAttributedString.Key: Any]?) -> NSAttributedString

    // MARK: - Durations

    /// Formats double duration (eg. 12345.0 -> '3h 26m')
    static func string(forDuration duration: Double) -> String
    
}

class StringFormatter: VStringFormatter {
    
    // MARK: - Dates
    
    static func string(for date: Date, format: DateFormat) -> String {
        return string(for: date, format:format, attributes:nil, suffixAttributes:nil).string
    }
    
    static func string(for date: Date,
                       format: DateFormat,
                       attributes: [NSAttributedString.Key : Any]?,
                       suffixAttributes: [NSAttributedString.Key : Any]?) -> NSAttributedString {
        let f = DateFormatter()
        switch format {
        case .normal, .year, .longYear:
            f.dateFormat = "MMMM d"
        case .short, .shortYear:
            f.dateFormat = "MMM d"
        case .shortWeekday:
            f.dateFormat = "E, MMMM d"
        case .longWeekday:
            f.dateFormat = "EEEE, MMMM d"
        case .shortWeekdayYear:
            f.dateFormat = "E, MMM d"
        case .full:
            f.dateFormat = "h:mm a, MMM d"
        case .month:
            f.dateFormat = "MMMM"
        }

        let str = NSMutableAttributedString(string: f.string(from: date), attributes: attributes)

        if f.dateFormat.contains("d") {
            str.append(NSAttributedString(string: suffix(for: date), attributes: suffixAttributes))
        }

        if format.rawValue >= 20 {
            f.dateFormat = " yyyy"
            str.append(NSAttributedString(string: f.string(from: date), attributes: attributes))
        } else if format.rawValue >= 10 {
            f.dateFormat = " ''yy"
            str.append(NSAttributedString(string: f.string(from: date), attributes: attributes))
        }

        return str
    }
    
    // MARK: - Numbers
    
    static func string(for number: Double) -> String {
        return string(for: number, unit:nil)
    }
    
    static func string(for number: Double, unit: String?) -> String {
        let vals = stringAndMult(for: number)
        let unitStr = unit != nil ? "\(vals.1) \(unit!)" : (vals.1)
        return vals.0 + unitStr
    }
    
    static func string(for number: Double,
                       attributes: [NSAttributedString.Key : Any],
                       unit: String?,
                       unitAttributes: [NSAttributedString.Key : Any]?) -> NSAttributedString {
        let vals = stringAndMult(for: number)
        let str = NSMutableAttributedString(string: vals.0, attributes: attributes)
        if unit != nil {
            str.append(NSAttributedString(string: vals.1 + unit!, attributes: unitAttributes))
        }
        return str
    }
    
    static func string(for numberString: String,
                       attributes: [NSAttributedString.Key : Any],
                       unit: String?,
                       unitAttributes: [NSAttributedString.Key : Any]?) -> NSAttributedString {
        let str = NSMutableAttributedString(string: numberString, attributes: attributes)
        if unit != nil {
            str.append(NSAttributedString(string: " " + unit!, attributes: unitAttributes))
        }
        return str
    }
    
    // MARK: - Durations
    
    static func string(forDuration duration: Double) -> String {
        var res: String
        if duration >= 3600 {
            res = String(format: "%ld:%.02ld", Int(duration) / 3600, Int(fmod((duration / 60), 60)))
        } else {
            res = String(format: "%ld", Int(fmod((duration / 60), 60)))
        }
        return res + ":" + string(forSeconds: fmod(duration, 60))
    }
    
    // MARK: - Private helpers
    
    private static func string(forSeconds seconds: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumIntegerDigits = 2
        formatter.roundingIncrement = 0.001
        return formatter.string(from: NSNumber(value: seconds))!
    }
    
    private static func format(value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.roundingIncrement = 0.001
        formatter.usesGroupingSeparator = true
        return formatter.string(from: NSNumber(value: value))!
    }

    private static func stringAndMult(for value: Double) -> (String, String) {
        if value < 1_000 { // 999
            return (format(value: value), "")
        }
        if value < 10_000 { // 9.99k
            return (String(format: "%.2f", value / 1000.0), "k")
        }
        if value < 100_000 { // 99.9k
            return (String(format: "%.1f", value / 1000.0), "k")
        }
        if value < 1_000_000 { // 999k
            return (String(format: "%ld", Int(value) / 1000), "k")
        }
        if value < 10_000_000 { // 9.99m
            return (String(format: "%.2f", value / 1000000.0), "m")
        }
        if value < 100_000_000 { // 99.9m
            return (String(format: "%.1f", value / 1000000.0), "m")
        }
        if value < 1_000_000_000 { // 999m
            return (String(format: "%ld", Int(value) / 1000000), "m")
        }
        return (String(format: "%.1f", value / 1000000000.0), "b") // 99.9b
    }

    private static func suffix(for date: Date) -> String {
        let dayOfMonth = Calendar.current.component(.day, from: date)
        switch (dayOfMonth) {
            case 1, 21, 31:
                return "st"
            case 2, 22:
                return "nd"
            case 3, 23:
                return "rd"
            default:
                return "th"
        }
    }
    
}
