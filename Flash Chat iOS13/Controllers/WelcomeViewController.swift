import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAnimationOnTitle()
    }
    
    private func setAnimationOnTitle() {
        titleLabel.text = ""
        let title = Constants.appName
        var charIndex = 0.0
        for letter in title {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 * charIndex) {
                self.titleLabel.text?.append(letter)
            }
//            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex , repeats: false) { (timer) in
//                self.titleLabel.text?.append(letter)
//            }
            charIndex += 1.0
        }
        
    }
}
