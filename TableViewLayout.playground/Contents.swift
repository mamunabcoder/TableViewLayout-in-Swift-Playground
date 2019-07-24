//: A UIKit based Playground for presenting user interface

import PlaygroundSupport
import UIKit

let CellIdentifier = "Cell"

class TableViewController : UIViewController {
    var table:UITableView!
    var reasons = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Playground first tableview"
        reasons = ["the labs are great", "the sessions teach new things", "the people are awesome", "the keynote rocks", "I must hug Joe Groff"]
        table.register(reasonTableViewCell.self, forCellReuseIdentifier: CellIdentifier)

        table.dataSource = self
        table.delegate = self
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white

        //Design table view layout
        table = UITableView()
        table.frame = CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.height)!, width: 375, height: UIScreen.main.bounds.height)
        
        view.addSubview(table)
        self.view = view
    }
}

extension TableViewController : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reasons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // attempt to dequeue a cell
        var cell: reasonTableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as? reasonTableViewCell
        cell.accessoryType = .disclosureIndicator
        if cell == nil {
            // none to dequeue – make a new one
            cell = UITableViewCell(style: .default, reuseIdentifier: CellIdentifier) as? reasonTableViewCell
            cell?.accessoryType = .disclosureIndicator
        }
        
        
        // configure cell here
        let reason = reasons[indexPath.row]
        cell.titleLabel?.text = "Reason #\(indexPath.row + 1)"
        cell.desTextLabel?.text = "I want to attend because \(reason)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let cell = tableView.cellForRow(at: indexPath) as? reasonTableViewCell
            else { return }
        guard let text = cell.desTextLabel?.text
        else { return }
        
        if indexPath.row % 2 == 0 {
            let detail = DetailViewController()
            detail.message = text
            navigationController?.pushViewController(detail, animated: true)
        }  else {
            let drawView = DrawSqaureViewControler()
            navigationController?.pushViewController(drawView, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

class reasonTableViewCell : UITableViewCell {
    var titleLabel: UILabel?
    var desTextLabel:UILabel?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleLabel =  UILabel()
        desTextLabel =  UILabel()
        self.contentView.addSubview(titleLabel!)
        self.contentView.addSubview(desTextLabel!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel!.frame = CGRect(x: 15, y: 5, width: self.contentView.frame.width, height: 20)
        desTextLabel!.frame = CGRect(x: 15, y: 25, width: self.contentView.frame.width, height: 30)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

class DetailViewController : UIViewController {
    var message = ""
    var animator: UIDynamicAnimator?
    
    override func loadView() {
        title = "Please let me go!"
        view = UIView()
        view.backgroundColor = UIColor.white
    }
    
    override func viewDidLayoutSubviews() {
        guard animator == nil else { return }
        
        // 1: split the message up into words
        let words = message.components(separatedBy: " ")
        
        // 2: create an empty array of labels
        var labels = [UILabel]()
        
        // 3: convert each word into a label
        for (index, word) in words.enumerated() {
            let label = UILabel()
            label.font = UIFont.preferredFont(forTextStyle: .title1)
            
            // 4: position the labels one above the other
            label.center = CGPoint(x: view.frame.midX, y: 50 + CGFloat(30 * index))
            label.text = word
            label.sizeToFit()
            view.addSubview(label)
            
            labels.append(label)
        }
        
        // 5: create a gravity behaviour for our labels
        let gravity = UIGravityBehavior(items: labels)
        animator = UIDynamicAnimator(referenceView: view)
        animator?.addBehavior(gravity)
        
        // 6: create a collision behavior for our labels
        let collisions = UICollisionBehavior(items: labels)
        
        // 7: give some boundaries for the collisions
        collisions.translatesReferenceBoundsIntoBoundary = true
        animator?.addBehavior(collisions)
    }
}

class DrawSqaureViewControler : UIViewController {
    
    var yellowView:UIView!
    var redViewView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "View Square draw"
    }

    override func loadView() {
        super.loadView()
        
        let view = UIView()
        view.backgroundColor = .white
        
        yellowView = UIView()
        yellowView.backgroundColor = .yellow
        view.addSubview(yellowView)
        
        redViewView = UIView()
        redViewView.backgroundColor = .red
        view.addSubview(redViewView)
        
        //Layout
        yellowView.translatesAutoresizingMaskIntoConstraints = false
        redViewView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            yellowView.topAnchor.constraint(equalTo: view.topAnchor, constant: 64),
            yellowView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            yellowView.widthAnchor.constraint(equalToConstant: 100),
            yellowView.heightAnchor.constraint(equalToConstant: 100),
            
            redViewView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            redViewView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            redViewView.widthAnchor.constraint(equalToConstant: 100),
            redViewView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        self.view = view
    }
}

//Present the view controller in the Live View window
let tableViewController = TableViewController();
let nav = UINavigationController(rootViewController: tableViewController)
PlaygroundPage.current.liveView = nav
