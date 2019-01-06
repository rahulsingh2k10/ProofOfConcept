//
//  ViewController.swift
//  ProofOfConcept
//
//  Created by Rahul Singh on 05/01/19.
//  Copyright © 2019 Rahul Singh. All rights reserved.
//

import UIKit
import CoreData

class ViewController: BaseViewController, NSFetchedResultsControllerDelegate {
    /// Outlet for TableView to display the content
    @IBOutlet weak private var appTableView: UITableView!

    /// This is used to manage the results of a **Planet**'s fetch request and display data.
    private var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!

    // MARK: - ViewController Life Cycle Methods -
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.topItem?.title = Constants.HOME_TITLE

        let nib = UINib(nibName: Constants.PLANET_TABLEVIEW_CELL_IDENTIFIER, bundle: nil)
        appTableView.register(nib, forCellReuseIdentifier: Constants.PLANET_TABLEVIEW_CELL_IDENTIFIER)

        loadSavedData()
    }

    // MARK: - Base Class Methods -
    override func networkStatusUpdated(status: ConnectionType) {
        super.networkStatusUpdated(status: status)

        switch status {
        case .wifi, .cellular:
            callTransaction()
        default:
            break
        }
    }
}

// MARK: - Private Methods -
extension ViewController {
    /**
      * This method fetches the **Planet** details from the Core Data and reloads the TableView.
      */
    private func loadSavedData() {
        if fetchedResultsController == nil {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: PLANET_ENTITY_NAME)

            let sort = NSSortDescriptor(key: PLANET_NAME, ascending: true)
            request.sortDescriptors = [sort]

            fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                                  managedObjectContext: CoreDataManager.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController.delegate = self
        }

        do {
            try fetchedResultsController.performFetch()
            appTableView.reloadData()
        } catch {
            print("Fetch failed")
        }
    }

    /**
      * This method calls the API and fetches the data from the server. Once, the data is received,
        it populates the **Planet** details onto the table.
      */
    private func callTransaction() {
        let endPoint = "\(Constants.BASE_URL)\(Constants.PLANET_END_POINT)"
        NetworkManager.sharedInstance.fetchData(urlString: endPoint) {[unowned self] (error) in
            if let err = error {
                self.presentAlert(title: Constants.ERROR_TITLE,
                                  message: err.localizedDescription)
            } else {
                self.loadSavedData()
            }
        }
    }
}


// MARK: - UITableViewDataSource Methods -
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Constants.PLANET_NAME_TITLE
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.fetchedObjects else {
            return 0
        }

        return sectionInfo.count
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.PLANET_TABLEVIEW_CELL_IDENTIFIER,
                                                 for: indexPath) as! PlanetTableViewCell

        let person = fetchedResultsController.object(at: indexPath) as! NSManagedObject
        let name = person.value(forKey: PLANET_NAME) as? String
        cell.planetNameLabel.text = name ?? Constants.NA_STRING

        return cell
    }
}
