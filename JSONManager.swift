import UIKit
class JSONManager: NSObject {
    func readJSONbyName(name: String) -> NSMutableArray {
        let filePath = NSString(string: NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])
        var fileAtPath = filePath.strings(byAppendingPaths: [name + ".json"])
        if (FileManager.default.fileExists(atPath: fileAtPath[0])) {
            let fileData = try! Data.init(contentsOf: URL.init(fileURLWithPath: fileAtPath[0]))
            let jsonObject = try! JSONSerialization.jsonObject(with: fileData, options: JSONSerialization.ReadingOptions.mutableContainers)
            return jsonObject as! NSMutableArray
        }else{
            return NSMutableArray()
        }
    }
    func deleteJSONByName(name: String) -> () {
        let filePath = NSString(string: NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])
        var fileAtPath = filePath.strings(byAppendingPaths: [name + ".json"])
        if (FileManager.default.fileExists(atPath: fileAtPath[0])) {
            try! FileManager.default.removeItem(at: URL.init(fileURLWithPath: fileAtPath[0]))
            print(fileAtPath[0] + "\nFILE DELETED")
        }
    }
    func saveArrayToJSONByName (array: NSMutableArray, name: String) -> () {
        let jsonData: Data = try! JSONSerialization.data(withJSONObject: array, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString: String = String.init(data: jsonData, encoding: String.Encoding.utf8)!
        let filePath = NSString(string: NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])
        var fileAtPath = filePath.strings(byAppendingPaths: [name + ".json"])
        if (!FileManager.default.fileExists(atPath: fileAtPath[0])) {
            FileManager.default.createFile(atPath: fileAtPath[0], contents: nil, attributes: nil)
        }
        try! jsonString.data(using: String.Encoding.utf8)?.write(to: URL(fileURLWithPath: fileAtPath[0]), options: Data.WritingOptions.atomic)
    }
    func addNewWorkoutToList(dict: NSDictionary){
        let workouts = readJSONbyName(name: "workouts")
        if(workouts.count>0){
            for i in 0..<workouts.count{
                let dictionary = workouts.object(at: i) as! NSDictionary
                if(dict["name"] as! String == dictionary["name"] as! String){
                    workouts.removeObject(at: i)
                    break
                }
            }
        }
        workouts.add(dict)
        saveArrayToJSONByName(array: workouts, name: "workouts")
    }
    func saveCompletedWorkout(dict: NSDictionary){
        let completedWorkouts = readJSONbyName(name: "history")
        let completedWorkoutDict = NSMutableDictionary()
        completedWorkoutDict["name"] = dict["name"] as! NSString
        completedWorkoutDict["muscle_groups"] = dict["muscle_groups"]
        completedWorkoutDict["date"] = Date().dateToString()
        completedWorkouts.add(completedWorkoutDict)
        saveArrayToJSONByName(array: completedWorkouts, name: "history")
    }
}
