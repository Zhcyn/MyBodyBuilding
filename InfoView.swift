import UIKit
import MessageUI
class InfoView: UIViewController, MFMailComposeViewControllerDelegate {
    let screenRect = UIScreen.main.bounds
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "Metropolis-Bold", size: 20)!]
        self.navigationItem.title = "Info"
        let barHeight = self.navigationController?.navigationBar.frame.maxY
        let info1 = UILabel(frame: CGRect(x: 10, y: barHeight! + 15, width: screenRect.size.width - 20, height: 40))
        info1.textColor = UIColor.black
        info1.backgroundColor = UIColor.clear
        info1.font = UIFont(name: "Metropolis-Medium", size: 16.0)
        info1.numberOfLines = 2
        info1.textAlignment = NSTextAlignment.left
        info1.text = "- Duration is the time you spend to complete 1 set of an exercise"
        self.view.addSubview(info1)
        let info2 = UILabel(frame: CGRect(x: 10, y: barHeight! + 65, width: screenRect.size.width - 20, height: 80))
        info2.textColor = UIColor.black
        info2.backgroundColor = UIColor.clear
        info2.font = UIFont(name: "Metropolis-Medium", size: 16.0)
        info2.numberOfLines = 4
        info2.textAlignment = NSTextAlignment.left
        info2.text = "- If you enter wrong duration on your exercise, you can edit it later. When you enter correct durations, you will see the increase on your productivity."
        self.view.addSubview(info2)
        let info3 = UILabel(frame: CGRect(x: 10, y: barHeight! + 155, width: screenRect.size.width - 20, height: 40))
        info3.textColor = UIColor.black
        info3.backgroundColor = UIColor.clear
        info3.font = UIFont(name: "Metropolis-Medium", size: 16.0)
        info3.numberOfLines = 2
        info3.textAlignment = NSTextAlignment.left
        info3.text = "- In order to use the Watch app, your phone needs to be somewhere close."
        self.view.addSubview(info3)
        let requestFeatureButton:UIButton = UIButton(type: UIButton.ButtonType.custom)
        requestFeatureButton.setTitle("Request Feature", for: UIControl.State.normal)
        requestFeatureButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        requestFeatureButton.titleLabel?.font = UIFont(name: "Metropolis-Medium", size: 18.0)
        requestFeatureButton.titleLabel?.textAlignment = NSTextAlignment.center
        requestFeatureButton.backgroundColor = UIColor.init(red: 97.0/255.0, green: 131.0/255.0, blue: 218.0/255.0, alpha: 1)
        requestFeatureButton.frame = CGRect(x: 0, y: screenRect.size.height*0.8, width: screenRect.size.width, height: screenRect.size.height*0.1)
        requestFeatureButton.addTarget(self, action: #selector(requestFeature), for: UIControl.Event.touchUpInside)
        requestFeatureButton.accessibilityIdentifier = "Create Workout"
        self.view.addSubview(requestFeatureButton)
        let bugReportButton:UIButton = UIButton(type: UIButton.ButtonType.custom)
        bugReportButton.setTitle("Bug Report", for: UIControl.State.normal)
        bugReportButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        bugReportButton.titleLabel?.font = UIFont(name: "Metropolis-Medium", size: 18.0)
        bugReportButton.titleLabel?.textAlignment = NSTextAlignment.center
        bugReportButton.backgroundColor = UIColor.init(red: 229.0/255.0, green: 93.0/255.0, blue: 41.0/255.0, alpha: 1)
        bugReportButton.frame = CGRect(x: 0, y: screenRect.size.height*0.9, width: screenRect.size.width, height: screenRect.size.height*0.1)
        bugReportButton.addTarget(self, action: #selector(bugReport), for: UIControl.Event.touchUpInside)
        self.view.addSubview(bugReportButton)
    }
    @objc func requestFeature() {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        composeVC.setToRecipients(["marufnebilogunc@gmail.com"])
        composeVC.setSubject("Feature Request")
        guard MFMailComposeViewController.canSendMail() else {
            print("error")
            return
        }
        self.present(composeVC, animated: true, completion: nil)
    }
    @objc func bugReport() {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        composeVC.setToRecipients(["marufnebilogunc@gmail.com"])
        composeVC.setSubject("Bug Report")
        guard MFMailComposeViewController.canSendMail() else {
            print("error")
            return
        }
        self.present(composeVC, animated: true, completion: nil)
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Swift.Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
