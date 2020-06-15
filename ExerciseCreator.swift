import UIKit
class ExerciseCreator: UIViewController, UITextFieldDelegate {
    var setsLabel: UILabel!
    var setsDownButton: UIButton!
    var setsUpButton: UIButton!
    var setCount = 1;
    var repsLabel: UILabel!
    var repsDownButton: UIButton!
    var repsUpButton: UIButton!
    var repsCount = 1;
    var durationLabel: UILabel!
    var durationDownButton: UIButton!
    var durationUpButton: UIButton!
    var durationSeconds = 30;
    var cardioTimeLabel: UILabel!
    var cardioDownButton: UIButton!
    var cardioUpButton: UIButton!
    var cardioMinutes = 1;
    var exerciseNameTextField: UITextField!
    var segmentedControl: UISegmentedControl!
    var onDoneBlock : ((NSDictionary) -> Void)?
    var viewReady : (() -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        let screenRect = UIScreen.main.bounds
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenRect.size.width, height: 50))
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "Metropolis-Medium", size: 18)!]
        let cancelItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(ExerciseCreator.closeModal))
        let doneItem = UIBarButtonItem(title: "Add", style: UIBarButtonItem.Style.plain, target: self, action: #selector(ExerciseCreator.saveExercise))
        let navigationItems = UINavigationItem(title: "Create Exercise")
        navigationItems.rightBarButtonItem = doneItem
        navigationItems.leftBarButtonItem = cancelItem
        navigationBar.items = [navigationItems]
        self.view.addSubview(navigationBar)
        let exerciseName = UILabel(frame: CGRect(x: 20, y: 70, width: screenRect.size.width/2 - 20, height: 30))
        exerciseName.textColor = UIColor.black
        exerciseName.backgroundColor = UIColor.clear
        exerciseName.font = UIFont(name: "Metropolis-Medium", size: 16.0)
        exerciseName.text = "Exercise Name";
        exerciseName.numberOfLines = 0;
        exerciseName.textAlignment = NSTextAlignment.left;
        self.view.addSubview(exerciseName)
        exerciseNameTextField = UITextField(frame: CGRect(x: screenRect.size.width/2 - 30, y: 70, width: screenRect.size.width/2 + 10, height: 30))
        exerciseNameTextField.borderStyle = UITextField.BorderStyle.roundedRect
        exerciseNameTextField.font = UIFont(name: "Metropolis-Medium", size: 16.0)
        exerciseNameTextField.placeholder = "Exercise Name"
        exerciseNameTextField.autocorrectionType = UITextAutocorrectionType.no
        exerciseNameTextField.keyboardType = UIKeyboardType.default
        exerciseNameTextField.returnKeyType = UIReturnKeyType.done
        exerciseNameTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        exerciseNameTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        exerciseNameTextField.delegate = self
        self.view.addSubview(exerciseNameTextField)
        segmentedControl = UISegmentedControl(items: ["Weights", "Cardio"])
        segmentedControl.frame = CGRect(x: 20, y: 120, width: screenRect.size.width - 40, height: 30)
        segmentedControl.addTarget(self, action: #selector(ExerciseCreator.segmentControlAction(segment:)), for: UIControl.Event.valueChanged)
        segmentedControl.selectedSegmentIndex = 0;
        self.view.addSubview(segmentedControl)
        setsLabel = UILabel(frame: CGRect(x: screenRect.size.width/2 - 50, y: 170, width: 100, height: 30))
        setsLabel.textColor = UIColor.black
        setsLabel.backgroundColor = UIColor.clear
        setsLabel.font = UIFont(name: "Metropolis-Medium", size: 16.0)
        setsLabel.text = "1 Set";
        setsLabel.numberOfLines = 0;
        setsLabel.textAlignment = NSTextAlignment.center;
        setsLabel.accessibilityIdentifier = "SetsLabel"
        self.view.addSubview(setsLabel)
        setsDownButton = UIButton(type: UIButton.ButtonType.custom)
        setsDownButton.setImage(UIImage(named: "down"), for: UIControl.State.normal)
        setsDownButton.frame = CGRect(x: 20, y: 170, width: 30, height: 30)
        setsDownButton.addTarget(self, action: #selector(ExerciseCreator.decreaseSets), for: UIControl.Event.touchUpInside)
        self.view.addSubview(setsDownButton)
        setsUpButton = UIButton(type: UIButton.ButtonType.custom)
        setsUpButton.setImage(UIImage(named: "up"), for: UIControl.State.normal)
        setsUpButton.frame = CGRect(x: screenRect.size.width - 50, y: 170, width: 30, height: 30)
        setsUpButton.addTarget(self, action: #selector(ExerciseCreator.increaseSets), for: UIControl.Event.touchUpInside)
        self.view.addSubview(setsUpButton)
        repsLabel = UILabel(frame: CGRect(x: screenRect.size.width/2 - 50, y: 220, width: 100, height: 30))
        repsLabel.textColor = UIColor.black
        repsLabel.backgroundColor = UIColor.clear
        repsLabel.font = UIFont(name: "Metropolis-Medium", size: 16.0)
        repsLabel.text = "1 Rep";
        repsLabel.numberOfLines = 0;
        repsLabel.textAlignment = NSTextAlignment.center;
        repsLabel.accessibilityIdentifier = "RepsLabel"
        self.view.addSubview(repsLabel)
        repsDownButton = UIButton(type: UIButton.ButtonType.custom)
        repsDownButton.setImage(UIImage(named: "down"), for: UIControl.State.normal)
        repsDownButton.frame = CGRect(x: 20, y: 220, width: 30, height: 30)
        repsDownButton.addTarget(self, action: #selector(ExerciseCreator.decreaseReps), for: UIControl.Event.touchUpInside)
        self.view.addSubview(repsDownButton)
        repsUpButton = UIButton(type: UIButton.ButtonType.custom)
        repsUpButton.setImage(UIImage(named: "up"), for: UIControl.State.normal)
        repsUpButton.frame = CGRect(x: screenRect.size.width - 50, y: 220, width: 30, height: 30)
        repsUpButton.addTarget(self, action: #selector(ExerciseCreator.increaseReps), for: UIControl.Event.touchUpInside)
        self.view.addSubview(repsUpButton)
        durationLabel = UILabel(frame: CGRect(x: screenRect.size.width/2 - 90, y: 270, width: 180, height: 30))
        durationLabel.textColor = UIColor.black
        durationLabel.backgroundColor = UIColor.clear
        durationLabel.font = UIFont(name: "Metropolis-Medium", size: 16.0)
        durationLabel.text = "Duration: 30 Seconds";
        durationLabel.numberOfLines = 0;
        durationLabel.textAlignment = NSTextAlignment.center;
        self.view.addSubview(durationLabel)
        durationDownButton = UIButton(type: UIButton.ButtonType.custom)
        durationDownButton.setImage(UIImage(named: "down"), for: UIControl.State.normal)
        durationDownButton.frame = CGRect(x: 20, y: 270, width: 30, height: 30)
        durationDownButton.addTarget(self, action: #selector(ExerciseCreator.decreaseRest), for: UIControl.Event.touchUpInside)
        self.view.addSubview(durationDownButton)
        durationUpButton = UIButton(type: UIButton.ButtonType.custom)
        durationUpButton.setImage(UIImage(named: "up"), for: UIControl.State.normal)
        durationUpButton.frame = CGRect(x: screenRect.size.width - 50, y: 270, width: 30, height: 30)
        durationUpButton.addTarget(self, action: #selector(ExerciseCreator.increaseRest), for: UIControl.Event.touchUpInside)
        self.view.addSubview(durationUpButton)
        cardioTimeLabel = UILabel(frame: CGRect(x: screenRect.size.width/2 - 50, y: 180, width: 100, height: 30))
        cardioTimeLabel.textColor = UIColor.black
        cardioTimeLabel.backgroundColor = UIColor.clear
        cardioTimeLabel.font = UIFont(name: "Metropolis-Medium", size: 16.0)
        cardioTimeLabel.text = "1 Minutes";
        cardioTimeLabel.numberOfLines = 0;
        cardioTimeLabel.textAlignment = NSTextAlignment.center;
        cardioTimeLabel.accessibilityIdentifier = "CardioLabel"
        self.view.addSubview(cardioTimeLabel)
        cardioDownButton = UIButton(type: UIButton.ButtonType.custom)
        cardioDownButton.setImage(UIImage(named: "down"), for: UIControl.State.normal)
        cardioDownButton.frame = CGRect(x: 20, y: 180, width: 30, height: 30)
        cardioDownButton.addTarget(self, action: #selector(ExerciseCreator.decreaseCardioMinutes), for: UIControl.Event.touchUpInside)
        self.view.addSubview(cardioDownButton)
        cardioUpButton = UIButton(type: UIButton.ButtonType.custom)
        cardioUpButton.setImage(UIImage(named: "up"), for: UIControl.State.normal)
        cardioUpButton.frame = CGRect(x: screenRect.size.width - 50, y: 180, width: 30, height: 30)
        cardioUpButton.addTarget(self, action: #selector(ExerciseCreator.increaseCardioMinutes), for: UIControl.Event.touchUpInside)
        self.view.addSubview(cardioUpButton)
        self.hideCardioUI()
        self.viewReady!()
    }
    func setExerciseValues(name: String, sets: String, reps: String, duration: String, isCardio: Bool){
        exerciseNameTextField.text = name
        if isCardio{
            showCardioUI()
            hideWeightsUI()
            cardioMinutes = Int(duration)!
            cardioTimeLabel.text = duration + " Minutes"
            segmentedControl.selectedSegmentIndex = 1
        }else{
            setCount = Int(sets)!
            repsCount = Int(reps)!
            durationSeconds = Int(duration)!
            setsLabel.text = sets + " Sets"
            repsLabel.text = reps + " Reps"
            durationLabel.text = "Duration: " + duration + " Seconds"
            segmentedControl.selectedSegmentIndex = 0
        }
    }
    func hideCardioUI () -> (){
        cardioTimeLabel.isHidden = true
        cardioDownButton.isHidden = true
        cardioUpButton.isHidden = true
    }
    func showCardioUI () -> (){
        cardioTimeLabel.isHidden = false
        cardioDownButton.isHidden = false
        cardioUpButton.isHidden = false
    }
    func hideWeightsUI () -> (){
        setsLabel.isHidden = true
        setsDownButton.isHidden = true
        setsUpButton.isHidden = true
        repsLabel.isHidden = true
        repsDownButton.isHidden = true
        repsUpButton.isHidden = true
        durationLabel.isHidden = true
        durationDownButton.isHidden = true
        durationUpButton.isHidden = true
    }
    func showWeightsUI () -> (){
        setsLabel.isHidden = false
        setsDownButton.isHidden = false
        setsUpButton.isHidden = false
        repsLabel.isHidden = false
        repsDownButton.isHidden = false
        repsUpButton.isHidden = false
        durationLabel.isHidden = false
        durationDownButton.isHidden = false
        durationUpButton.isHidden = false
    }
    @objc func segmentControlAction(segment: UISegmentedControl) -> () {
        if(segment.selectedSegmentIndex == 0){
            self.hideCardioUI()
            self.showWeightsUI()
        }else{
            self.showCardioUI()
            self.hideWeightsUI()
        }
    }
    @objc func decreaseSets () -> (){
        if(setCount>1){
            setCount -= 1
            setsLabel.text = String(format: "%d Sets", setCount)
        }
    }
    @objc func increaseSets () -> (){
        setCount += 1
        setsLabel.text = String(format: "%d Sets", setCount)
    }
    @objc func decreaseReps () -> (){
        if(repsCount>1){
            repsCount -= 1
            repsLabel.text = String(format: "%d Reps", repsCount)
        }
    }
    @objc func increaseReps () -> (){
        repsCount += 1
        repsLabel.text = String(format: "%d Reps", repsCount)
    }
    @objc func decreaseRest () -> (){
        if(durationSeconds>10){
            durationSeconds -= 10
            durationLabel.text = String(format: "Duration: %d Seconds", durationSeconds)
        }
    }
    @objc func increaseRest () -> (){
        durationSeconds += 10
        durationLabel.text = String(format: "Duration: %d Seconds", durationSeconds)
    }
    @objc func decreaseCardioMinutes () -> (){
        if(cardioMinutes>1){
            cardioMinutes -= 1
            cardioTimeLabel.text = String(format: "%d Minutes", cardioMinutes)
        }
    }
    @objc func increaseCardioMinutes () -> (){
        cardioMinutes += 1
        cardioTimeLabel.text = String(format: "%d Minutes", cardioMinutes)
    }
    @objc func closeModal() -> () {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func saveExercise() -> () {
        if(exerciseNameTextField.text == ""){
            let alertController = UIAlertController(title: "Please enter an exercise name", message: nil, preferredStyle: UIAlertController.Style.alert)
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        var exerciseDictionary: NSDictionary!
        if (segmentedControl.selectedSegmentIndex == 0) {
            exerciseDictionary =  ["name" : exerciseNameTextField.text!, "sets" : String(format: "%d", setCount), "reps" : String(format: "%d", repsCount), "duration" : String(format: "%d", durationSeconds), "isCardio" : false]
        }else{
            exerciseDictionary =  ["name" : exerciseNameTextField.text!, "cardio_minutes" : String(format: "%d", cardioMinutes), "isCardio" : true]
        }
        if let callback = self.onDoneBlock {
            callback (exerciseDictionary)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
