import UIKit
class WorkoutHistory: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var workoutsTableView: UITableView!
    var completedWorkoutsArray = NSMutableArray()
    let screenRect = UIScreen.main.bounds
    let jsonManager = JSONManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "Metropolis-Bold", size: 20)!]
        self.navigationItem.title = "History"
        workoutsTableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.size.height))
        workoutsTableView.backgroundColor = UIColor.white
        workoutsTableView.delegate = self
        workoutsTableView.dataSource = self
        self.view.addSubview(workoutsTableView)
        completedWorkoutsArray = jsonManager.readJSONbyName(name: "history")
        completedWorkoutsArray = NSMutableArray(array: completedWorkoutsArray.reversed())
        workoutsTableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completedWorkoutsArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "workoutHistoryCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? WorkoutHistoryCell
        if(cell == nil){
            cell = WorkoutHistoryCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellIdentifier)
        }
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        let completedWorkoutDict = completedWorkoutsArray.object(at: indexPath.row) as! NSDictionary
        let muscleGroupsAsString = (completedWorkoutDict["muscle_groups"] as! Array).joined(separator: ",")
        let att = [NSAttributedString.Key.font : UIFont(name: "Metropolis-Bold", size: 14.0)]
        let boldString = NSMutableAttributedString(string:"Muscles: ", attributes: att as [NSAttributedString.Key : Any])
        let att2 = [NSAttributedString.Key.font : UIFont(name: "Metropolis-Medium", size: 14.0)]
        let normalString = NSMutableAttributedString(string:muscleGroupsAsString, attributes:att2 as [NSAttributedString.Key : Any])
        boldString.append(normalString)
        let dateString = completedWorkoutDict["date"] as! String
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("MMM d")
        let dateFormatter2 = DateFormatter()
        dateFormatter2.setLocalizedDateFormatFromTemplate("EEE")
        cell?.workoutNameLabel.text = (completedWorkoutDict["name"] as! String)
        cell?.muscleGroupsLabel.attributedText = boldString
        cell?.dateLabel.text = dateFormatter.string(from: dateString.stringToDate())
        cell?.dayLabel.text = dateFormatter2.string(from: dateString.stringToDate())
        return cell!
    }
}
