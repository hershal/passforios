//
//  PasswordCell.swift
//  passAutoFillExtension
//
//  Created by Sun, Mingshen on 12/31/20.
//  Copyright © 2020 Bob Sun. All rights reserved.
//

import passKit

class PasswordTableViewCell: UITableViewCell {
    private static let dateFormatterTime: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()

    private static let dateFormatterDate: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()

    func configure(with entry: PasswordTableEntry) {
        textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        textLabel?.text = entry.passwordEntity.synced ? entry.title : "↻ \(entry.title)"
        textLabel?.adjustsFontForContentSizeCategory = true

        accessoryType = .none
        detailTextLabel?.textColor = UIColor.lightGray
        detailTextLabel?.font = UIFont.preferredFont(forTextStyle: .footnote)
        detailTextLabel?.adjustsFontForContentSizeCategory = true

        if !entry.isDir {
            detailTextLabel?.text = formatDate(entry.passwordEntity.getLastUpdateDate())
        } else {
            accessoryType = .disclosureIndicator

            let count = entry.passwordEntity.children?.count ?? 0

            var lastUpdateDate = Date.distantPast
            for child in entry.passwordEntity.children! as! Set<PasswordEntity> where !child.isDir {
                let childDate = child.getLastUpdateDate()
                if childDate > lastUpdateDate {
                    lastUpdateDate = childDate
                }
            }

            let date = formatDate(lastUpdateDate)

            if count == 1 {
                detailTextLabel?.text = "\(date) - \(count) " + "Item".localize()
            } else {
                detailTextLabel?.text = "\(date) - \(count) " + "Items".localize()
            }
        }
    }

    private func formatDate(_ date: Date) -> String {
        let today = Calendar.current.startOfDay(for: Date())
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!

        if date > today {
            return PasswordTableViewCell.dateFormatterTime.string(from: date)
        } else if date > yesterday {
            return "Yesterday".localize()
        }
        return PasswordTableViewCell.dateFormatterDate.string(from: date)
    }
}
