import UIKit
import Firebase

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    let db = Firestore.firestore()
    
    
    var message: [Message] = [
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.appName
        navigationItem.hidesBackButton = true
        tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
        fetchMessage()
    }
    
    private func fetchMessage() {
        
        db.collection(Constants.FStore.collectionName)
            .order(by: Constants.FStore.dateField)
            .addSnapshotListener { (querySnapshot, error) in
            self.message = []
            if let e = error {
                print("issue with retrieving data:  \(e)")
            } else {
                if let querySnapshot = querySnapshot?.documents {
                    for docs in querySnapshot {
                        let data = docs.data()
                        if let sender = data[Constants.FStore.senderField] as? String, let body = data[Constants.FStore.bodyField] as? String {
                            let newMessage = Message(sender: sender, body: body)
                            self.message.append(newMessage)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.message.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text, let messageSeender = Auth.auth().currentUser?.email {
            if messageBody != "" {
                db.collection(Constants.FStore.collectionName).addDocument(data: [
                    Constants.FStore.senderField: messageSeender,
                    Constants.FStore.bodyField: messageBody,
                    Constants.FStore.dateField: Date().timeIntervalSince1970
                ]) { error in
                    if let e = error {
                        print("Issue to store data in  firestore: \(e)")
                    } else {
                        print("succesfully saved data")
                    }
                }
            }
        }
        messageTextfield.text=""
    }
    

    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do {
          try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
}

extension ChatViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return message.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! MessageCell
        cell.messageLabel.text = message[indexPath.row].body
        let message = message[indexPath.row]
        if message.sender == Auth.auth().currentUser?.email {
            cell.youImageView.isHidden = true
            cell.messageImageView.isHidden = false
            cell.messageBackView.backgroundColor = UIColor(named: Constants.BrandColor.lightPurple)
            cell.messageLabel.textColor = UIColor(named: Constants.BrandColor.purple)
        } else {
            cell.youImageView.isHidden = false
            cell.messageImageView.isHidden = true
            cell.messageBackView.backgroundColor = UIColor(named: Constants.BrandColor.purple)
            cell.messageLabel.textColor = UIColor(named: Constants.BrandColor.lightPurple)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
    }
}

extension ChatViewController: UITextFieldDelegate {
     
}
