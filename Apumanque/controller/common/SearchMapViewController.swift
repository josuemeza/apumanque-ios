//
//  SearchMapViewController.swift
//  Apumanque
//
//  Created by Jimmy Hernandez on 03-07-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import UIKit

class SearchMapViewController: ViewController {

    @IBOutlet weak var boxView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textFieldNameStore: UITextField!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    private(set) var stores = [Store]()
    var autoComplete = [String]()
    var autoCompletePosibilities = [String]()
    var autoCompletePosibilitiesTMP = [Store]()
    var isStoreValid = false
    var storeID = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stores = Store.all(on: managedObjectContext) ?? []
        
        autoCompletePosibilitiesTMP = stores
        autoCompletePosibilitiesTMP = autoCompletePosibilitiesTMP.filter{$0.floor  != "0"}
        
        autoCompletePosibilities = autoCompletePosibilitiesTMP.map{$0.name!}
        
        print("TIENDA \(stores[0].name)")
        
        textFieldNameStore.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.layer.cornerRadius = 5
        
        let tapKeyboard = UITapGestureRecognizer(target: self.view, action: Selector("endEditing:"))
        tapKeyboard.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapKeyboard)
        

        // Do any additional setup after loading the view.
        boxView.roundOut(radious: 8.0)
        searchView.roundOut(radious: 8.0)
        
    }
    
    func searchAutocompleteEntriesWith(substring: String) {
        autoComplete.removeAll(keepingCapacity: false)
        
        for key in autoCompletePosibilities {
            
            let myString: NSString! = key.lowercased() as NSString
            let substringRange: NSRange! = myString.range(of: substring.lowercased())
            if substringRange.location == 0 {
                autoComplete.append(key)
            }
        }
        tableView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: TextFieldDelegate Methods
extension SearchMapViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.restorationIdentifier == "storeName" {
            let substring = (textField.text! as NSString).replacingCharacters(in: range, with: string.lowercased())
            searchAutocompleteEntriesWith(substring: substring.lowercased())
            if string.count > 0 {
                tableView.isHidden = false
            }
        }
        
        return true
    }
    
}

//MARK: - UITableView methods
extension SearchMapViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if autoComplete.count > 4 {
            let h = 44 * 4
            heightConstraint.constant = CGFloat(h)
            return 4
        } else {
            let h = 44 * autoComplete.count
            heightConstraint.constant = CGFloat(h)
            return autoComplete.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.textLabel!.text = autoComplete[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell: UITableViewCell = tableView.cellForRow(at: indexPath)!
        textFieldNameStore.text = selectedCell.textLabel!.text!
        tableView.isHidden = true
        view.endEditing(true)
    }
    
    
}
