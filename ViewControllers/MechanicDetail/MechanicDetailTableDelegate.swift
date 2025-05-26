import UIKit

class MechanicDetailTableDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    private weak var viewController: MechanicDetailViewController?
    private let viewBuilder = MechanicDetailViewBuilder()
    
    init(viewController: MechanicDetailViewController) {
        self.viewController = viewController
        super.init()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewController?.mechanic?.openingHours.count ?? 0
        print("Number of opening hours rows: \(count)")
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hourCell", for: indexPath)
        
        guard let hour = viewController?.mechanic?.openingHours[indexPath.row] else {
            return cell
        }
        
        // Create a custom layout for better visibility
        let dayLabel = UILabel()
        dayLabel.text = hour.day
        dayLabel.font = .systemFont(ofSize: 16, weight: .medium)
        dayLabel.textColor = .label
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let timeLabel = UILabel()
        if hour.status {
            let startTime = viewBuilder.formatTime(hour.startTime)
            let endTime = viewBuilder.formatTime(hour.endTime)
            timeLabel.text = "\(startTime) - \(endTime)"
            timeLabel.textColor = .systemGreen
        } else {
            timeLabel.text = "Closed"
            timeLabel.textColor = .systemRed
        }
        timeLabel.font = .systemFont(ofSize: 14)
        timeLabel.textAlignment = .right
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Clear existing subviews
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        // Add labels to cell
        cell.contentView.addSubview(dayLabel)
        cell.contentView.addSubview(timeLabel)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            dayLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
            dayLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            
            timeLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
            timeLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            timeLabel.leadingAnchor.constraint(greaterThanOrEqualTo: dayLabel.trailingAnchor, constant: 8)
        ])
        
        cell.selectionStyle = .none
        cell.backgroundColor = .systemBackground
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
} 