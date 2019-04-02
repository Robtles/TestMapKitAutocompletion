//
//  ViewController.swift
//  TestMapKitAutocompletion
//
//  Created by Rob on 02/04/2019.
//  Copyright © 2019 com.rob. All rights reserved.
//

import MapKit
import UIKit
import Toast_Swift

final class SuggestionsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    // MARK: - Instance Properties
    
    var completerResults: [MKLocalSearchCompletion] = []
    
    var mapItemToPresent: MKMapItem?
    
    let searchCompleter = MKLocalSearchCompleter()
    
    // MARK: View Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var textField: UITextField!
    
    // MARK: Life Methods

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.textField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchCompleter.delegate = self
        self.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.title = "Address Search"
    }
    
    // MARK: Navigation Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toResultMapViewController", let itemToPresent = self.mapItemToPresent {
            (segue.destination as? ResultMapViewController)?.mapItem = itemToPresent
            self.mapItemToPresent = nil
        }
    }
    
    // MARK: Table Methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = self.completerResults[indexPath.row].title
        cell.detailTextLabel?.text = self.completerResults[indexPath.row].subtitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        self.search(self.completerResults[indexPath.row])
    }
    
    private func search(_ result: MKLocalSearchCompletion) {
        self.view.makeToast("Started fetching information...")
        let request = MKLocalSearch.Request(completion: result)
        let search = MKLocalSearch(request: request)
        search.start { result, error in
            self.view.hideAllToasts()
            if let result = result, let mapItem = result.mapItems.first {
                self.mapItemToPresent = mapItem
                self.performSegue(withIdentifier: "toResultMapViewController", sender: self)
            } else if let error = error {
                self.view.makeToast("Failed to fetch address information: \(error.localizedDescription)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.completerResults.count
    }
    
    // MARK: Text Field Methods
    
    @objc func textFieldDidChange(_ sender: UITextField) {
        self.searchCompleter.queryFragment = sender.text ?? ""
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.completerResults.removeAll()
        self.tableView.reloadData()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension SuggestionsTableViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.completerResults = completer.results
        self.tableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        self.view.makeToast("Failed to fetch addresses from server.")
    }
    
}
