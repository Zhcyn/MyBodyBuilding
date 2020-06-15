import UIKit
class WorkoutsList: UIViewController, UITableViewDelegate, UITableViewDataSource, EditWorkoutDelegate {
    var workoutsTableView: UITableView!
    var workoutsArray: NSMutableArray!
    var editMode = false
    let jsonManager = JSONManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "Metropolis-Bold", size: 20)!]
        self.navigationItem.title = "Workouts"
        let editButton:UIBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.editWorkout))
        self.navigationItem.rightBarButtonItem = editButton;
        let screenRect = UIScreen.main.bounds
        workoutsTableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.size.height))
        workoutsTableView.backgroundColor = UIColor.white
        workoutsTableView.delegate = self
        workoutsTableView.dataSource = self
        self.view.addSubview(workoutsTableView)
        workoutsArray = jsonManager.readJSONbyName(name: "workouts")
        workoutsTableView.reloadData()
    }
    func calculateWorkoutDuration(index : NSInteger) -> String {
        let workoutDict = workoutsArray.object(at: index) as! NSDictionary
        let exercisesArray = jsonManager.readJSONbyName(name: workoutDict["name"] as! String)
        var duration = "0"
        var durationInSeconds = 0
        for i in 0..<exercisesArray.count {
            let exerciseDict = exercisesArray.object(at: i) as! NSDictionary
            if(exerciseDict["isCardio"] as! Bool){
                durationInSeconds += Int(exerciseDict["cardio_minutes"] as! String)! * 60
            }else{
                let sets = Int(exerciseDict["sets"] as! String)!
                durationInSeconds += Int(exerciseDict["duration"] as! String)! * sets
                durationInSeconds += (workoutDict["rest"] as! NSNumber).intValue * (sets-1)
            }
            if (i != (exercisesArray.count) - 1) {
                durationInSeconds += (workoutDict["rest"] as! NSNumber).intValue
            }
        }
        let totalDuration:Double = Double(durationInSeconds) / 60.0
        duration = String(format: "%.1f", totalDuration)
        return duration
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workoutsArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70;
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            self.workoutsTableView.beginUpdates()
            jsonManager.deleteJSONByName(name: (workoutsArray.object(at: indexPath.row) as! NSDictionary)["name"] as! String)
            self.workoutsArray.removeObject(at: indexPath.row)
            jsonManager.saveArrayToJSONByName(array: workoutsArray, name: "workouts")
            self.workoutsTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            self.workoutsTableView.endUpdates()
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "workoutCell"
        var cell: WorkoutCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? WorkoutCell
        if(cell == nil){
            cell = WorkoutCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellIdentifier)
        }
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        let workoutName = workoutsArray.object(at: indexPath.row) as! NSDictionary
        let workoutNameWithoutExtension = (workoutName["name"] as! NSString).deletingPathExtension
        cell?.workoutLabel.text = workoutNameWithoutExtension
        cell?.workoutDuration.text = self.calculateWorkoutDuration(index: indexPath.row)
        let muscleGroupsAsString = (workoutName["muscle_groups"] as! Array).joined(separator: ",")
        let att = [NSAttributedString.Key.font : UIFont(name: "Metropolis-Bold", size: 14.0)]
        let boldString = NSMutableAttributedString(string:"Muscles: ", attributes: att as [NSAttributedString.Key : Any])
        let att2 = [NSAttributedString.Key.font : UIFont(name: "Metropolis-Medium", size: 14.0)]
        let normalString = NSMutableAttributedString(string:muscleGroupsAsString, attributes:att2 as [NSAttributedString.Key : Any])
        boldString.append(normalString)
        cell?.muscleGroupsLabel.attributedText = boldString
        if editMode{
            cell?.startWorkoutButton.setTitle("Edit", for: UIControl.State.normal)
            cell?.startWorkoutButton.backgroundColor = UIColor.init(red: 229.0/255.0, green: 93.0/255.0, blue: 41.0/255.0, alpha: 1)
            cell?.startWorkoutButton.tag = indexPath.row
        }else{
            cell?.startWorkoutButton.setTitle("Start", for: UIControl.State.normal)
            cell?.startWorkoutButton.backgroundColor = UIColor.init(red: 0, green: 179.0/255.0, blue: 85.0/255.0, alpha: 1)
            cell?.startWorkoutButton.tag = indexPath.row
        }
        cell?.startWorkoutButton.addTarget(self, action: #selector(startEditAction(sender:)), for: UIControl.Event.touchUpInside)
        return cell!
    }
    @objc func startEditAction(sender: UIButton) -> Void {
        if editMode{
            let editWorkout = EditWorkout()
            editWorkout.workoutNo = sender.tag
            editWorkout.delegate = self
            let navController = UINavigationController.init(rootViewController: editWorkout)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true, completion: nil)
        }else{
            let startWorkout = StartWorkout()
            startWorkout.workoutNo = sender.tag
            let navController = UINavigationController.init(rootViewController: startWorkout)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true, completion: nil)
        }
    }
    @objc func editWorkout() -> Void {
        if editMode{
            editMode = false
            self.workoutsTableView.reloadData()
        }else{
            editMode = true
            self.workoutsTableView.reloadData()
        }
    }
    func editCompleted() {
        workoutsArray = jsonManager.readJSONbyName(name: "workouts")
        editWorkout()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
