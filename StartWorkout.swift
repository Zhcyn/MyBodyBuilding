import UIKit
import AudioToolbox
class StartWorkout: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var separatedExercisesArray: NSMutableArray = []
    var countdownTimer: Timer!
    var startPauseWorkoutButton: UIButton!
    var isWorkoutActive = false
    var workoutNo = 0
    var exercisesTableView: UITableView!
    var workoutNameWithoutExtension: String!
    var workoutDict: NSDictionary!
    let jsonManager = JSONManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        let screenRect = UIScreen.main.bounds
        let workoutsArray = jsonManager.readJSONbyName(name: "workouts")
        workoutDict = workoutsArray.object(at: self.workoutNo) as? NSDictionary
        workoutNameWithoutExtension = workoutDict["name"] as? String
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "Metropolis-Bold", size: 20)!]
        self.navigationItem.title = workoutNameWithoutExtension
        let cancelButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(StartWorkout.cancelButtonHit))
        self.navigationItem.rightBarButtonItem = cancelButton
        exercisesTableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.size.height - 80))
        exercisesTableView.backgroundColor = UIColor.white
        exercisesTableView.delegate = self
        exercisesTableView.dataSource = self
        self.view.addSubview(exercisesTableView)
        startPauseWorkoutButton = UIButton(type: UIButton.ButtonType.custom)
        startPauseWorkoutButton.setTitle("START", for: UIControl.State.normal)
        startPauseWorkoutButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        startPauseWorkoutButton.titleLabel?.font = UIFont(name: "Metropolis-Medium", size: 18.0)
        startPauseWorkoutButton.titleLabel?.textAlignment = NSTextAlignment.center
        startPauseWorkoutButton.backgroundColor = UIColor.init(red: 0, green: 179.0/255.0, blue: 85.0/255.0, alpha: 1)
        startPauseWorkoutButton.frame = CGRect(x: 0, y: screenRect.size.height - 80, width: screenRect.size.width, height: 80)
        startPauseWorkoutButton.addTarget(self, action: #selector(StartWorkout.startPauseWorkout), for: UIControl.Event.touchUpInside)
        self.view.addSubview(startPauseWorkoutButton)
        self.seperateExercisesBySetsAndRests(rawExercisesArray: jsonManager.readJSONbyName(name: workoutDict["name"] as! String))
    }
    @objc func startPauseWorkout() -> () {
        if (isWorkoutActive) {
            isWorkoutActive = false;
            startPauseWorkoutButton.backgroundColor = UIColor(red: 0, green: 179.0/255.0, blue: 85.0/255.0, alpha: 1)
            startPauseWorkoutButton.setTitle("START", for: UIControl.State.normal)
            countdownTimer.invalidate()
            let indexOfObject = self.getIndexOfFirstUncompletedExercise()
            let separatedExerciseDict = separatedExercisesArray.object(at: indexOfObject) as! NSDictionary
            let mutableDict: NSMutableDictionary = NSMutableDictionary(dictionary: separatedExerciseDict)
            mutableDict["status"] = "2"
            separatedExercisesArray.replaceObject(at: indexOfObject, with: mutableDict)
            exercisesTableView.reloadData()
        }else{
            isWorkoutActive = true;
            startPauseWorkoutButton.backgroundColor = UIColor(red: 229.0/255.0, green: 93.0/255.0, blue: 41.0/255.0, alpha: 1)
            startPauseWorkoutButton.setTitle("PAUSE", for: UIControl.State.normal)
            countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(StartWorkout.updateTimer), userInfo: nil, repeats: true)
        }
    }
    func getIndexOfFirstUncompletedExercise() -> Int {
        for i in 0..<separatedExercisesArray.count{
            let separatedExerciseDict = separatedExercisesArray.object(at: i) as! NSDictionary
            let durationAsString:String = String(format: "%@", separatedExerciseDict["duration"] as! CVarArg)
            let duration = Int(durationAsString)!
            if(duration>0){
                return i;
            }
        }
        return -1
    }
    @objc func updateTimer() -> () {
        let indexOfObject = self.getIndexOfFirstUncompletedExercise()
        if (indexOfObject == -1) {
            countdownTimer.invalidate()
            jsonManager.saveCompletedWorkout(dict: workoutDict)
            let alertController = UIAlertController(title: ("You have completed the " + workoutNameWithoutExtension), message: "You can check your completed workouts on History page", preferredStyle: UIAlertController.Style.alert)
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            })
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        let separatedExerciseDict = separatedExercisesArray.object(at: indexOfObject) as! NSDictionary
        let durationAsString:String = String(format: "%@", separatedExerciseDict["duration"] as! CVarArg)
        var duration = Int(durationAsString)!
        duration -= 1
        if(duration>0){
            let separatedExerciseDict = separatedExercisesArray.object(at: indexOfObject) as! NSDictionary
            let mutableDict: NSMutableDictionary = NSMutableDictionary(dictionary: separatedExerciseDict)
            mutableDict["duration"] = String(format: "%d", duration)
            mutableDict["status"] = "1"
            if(duration < 6 && mutableDict["name"] as! String == "Rest"){
                mutableDict["name"] = "Get Ready"
                AudioServicesPlaySystemSoundWithCompletion(kSystemSoundID_Vibrate, {})
            }
            separatedExercisesArray.replaceObject(at: indexOfObject, with: mutableDict)
            exercisesTableView.reloadData()
        }else{
            AudioServicesPlaySystemSoundWithCompletion(kSystemSoundID_Vibrate, {})
            separatedExercisesArray.removeObject(at: indexOfObject)
            exercisesTableView.reloadData()
        }
    }
    func seperateExercisesBySetsAndRests(rawExercisesArray: NSMutableArray) -> () {
        for i in 0..<rawExercisesArray.count {
            let exerciseDict = rawExercisesArray.object(at: i) as! NSDictionary
            if(exerciseDict["isCardio"] as! Bool){
                let cardioSeconds = Int(exerciseDict["cardio_minutes"] as! String)! * 60
                let separatedExercise = ["name" : exerciseDict["name"], "duration" : String(format: "%d", cardioSeconds), "status" : "0"]
                separatedExercisesArray.add(separatedExercise)
            }else{
                let sets = Int(exerciseDict["sets"] as! String)!
                for j in 0..<sets {
                    let separatedExercise = ["name" : exerciseDict["name"], "duration" : exerciseDict["duration"], "reps" : exerciseDict["reps"], "status" : "0"]
                    separatedExercisesArray.add(separatedExercise)
                    if (j != sets-1){
                        let separatedExercise = ["name" : "Rest", "duration" : workoutDict["rest"], "status" : "0"]
                        separatedExercisesArray.add(separatedExercise)
                    }
                }
            }
            if (i != rawExercisesArray.count - 1) {
                let separatedExercise = ["name" : "Rest", "duration" : workoutDict["rest"], "status" : "0"]
                separatedExercisesArray.add(separatedExercise)
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return separatedExercisesArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "separatedCell"
        var cell: SeparatedExerciseCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? SeparatedExerciseCell
        if(cell == nil){
            cell = SeparatedExerciseCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellIdentifier)
        }
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        let separatedExerciseDict = separatedExercisesArray.object(at: indexPath.row) as! NSDictionary
        let durationAsString:String = String(format: "%@", separatedExerciseDict["duration"] as! CVarArg)
        let duration = Int(durationAsString)!
        let minutes = duration/60
        let seconds = duration%60
        cell?.countdownLabel.text = String(format: "%d:%02d", minutes, seconds)
        cell?.exerciseNameLabel.text = separatedExerciseDict["name"] as? String
        if let reps = separatedExerciseDict["reps"]{
            cell?.repsLabel.isHidden = false
            cell?.repsStaticLabel.isHidden = false
            cell?.repsLabel.text = reps as? String
        }else{
            cell?.repsLabel.isHidden = true
            cell?.repsStaticLabel.isHidden = true
        }
        if (Int(separatedExerciseDict["status"] as! String)! == 0) {
            cell?.backgroundColor = UIColor.white
            cell?.countdownLabel.textColor = UIColor.black
            cell?.exerciseNameLabel.textColor = UIColor.black
            cell?.exerciseNameLabel.font = UIFont(name: "Metropolis-Medium", size: 22.0)
            cell?.repsLabel.textColor = UIColor.black
            cell?.repsStaticLabel.textColor = UIColor.black
        }else if (Int(separatedExerciseDict["status"] as! String)! == 1){
            cell?.backgroundColor = UIColor(red: 0, green: 179.0/255.0, blue: 85.0/255.0, alpha: 1)
            cell?.countdownLabel.textColor = UIColor.white
            cell?.exerciseNameLabel.textColor = UIColor.white
            cell?.exerciseNameLabel.font = UIFont(name: "Metropolis-Bold", size: 22.0)
            cell?.repsLabel.textColor = UIColor.white
            cell?.repsStaticLabel.textColor = UIColor.white
        }else if (Int(separatedExerciseDict["status"] as! String)! == 2){
            cell?.backgroundColor = UIColor(red: 229.0/255.0, green: 93.0/255.0, blue: 41.0/255.0, alpha: 1)
            cell?.countdownLabel.textColor = UIColor.white
            cell?.exerciseNameLabel.textColor = UIColor.white
            cell?.exerciseNameLabel.font = UIFont(name: "Metropolis-Bold", size: 22.0)
            cell?.repsLabel.textColor = UIColor.white
            cell?.repsStaticLabel.textColor = UIColor.white
        }
        return cell!
    }
    @objc func cancelButtonHit() -> () {
        if (isWorkoutActive) {
            countdownTimer.invalidate()
        }
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
