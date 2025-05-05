import UIKit

class MechanicDetailTableDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    private weak var viewController: MechanicDetailViewController?
    private let viewBuilder = MechanicDetailViewBuilder()
    
    init(viewController: MechanicDetailViewController) {
        self.viewController = viewController
        super.init()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewController?.mechanic?.openingHours.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hourCell", for: indexPath)
        
        guard let hour = viewController?.mechanic?.openingHours[indexPath.row] else {
            return cell
        }
        
        // Configure cell
        var content = cell.defaultContentConfiguration()
        content.text = hour.day
        
        if hour.status == "Open" {
            let timeString = "\(viewBuilder.formatTime(hour.startTime)) - \(viewBuilder.formatTime(hour.endTime))"
            content.secondaryText = timeString
            content.secondaryTextProperties.color = .systemGreen
        } else {
            content.secondaryText = "Closed"
            content.secondaryTextProperties.color = .systemRed
        }
        
        cell.contentConfiguration = content
        cell.selectionStyle = .none
        
        return cell
    }
} 