//
//  TankTableViewController.swift
//  Table View
//
//  Created by Андрей on 06.07.2022.
//

import UIKit

class TankTableViewController: UITableViewController {
    
    // MARK: - Properties
    let cellManager = CellManager()
    let dataManager = DataManager()
    var tanks: [Tank]! {
        didSet {
            dataManager.saveTanks(tanks)
        }
    }
    
    // MARK: - UIView Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tanks =  dataManager.loadTanks() ?? Tank.loadDefaults()
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "EditSegue" else { return }
        guard let selectedPath = tableView.indexPathForSelectedRow else { return }
        
        let tank = tanks[selectedPath.row]
        let destination = segue.destination as! AddEditTableViewController
        destination.tank = tank
    }
    
}

// MARK: - UITableViewDataSource
extension TankTableViewController /*: UITableViewDataSource */ {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tanks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tank = tanks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TankCell")! as! TankCell
        cellManager.configure(cell, with: tank)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedTank = tanks.remove(at: sourceIndexPath.row)
        tanks.insert(movedTank, at: destinationIndexPath.row)
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate
extension TankTableViewController /*: UITableViewDelegate */ {
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            tanks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .insert:
            break
        case .none:
            break
        @unknown default:
            print(#line, #function, "Unknown case in file \(#file)")
            break
        }
    }
}

extension TankTableViewController {
    @IBAction  func unwind(_ segue: UIStoryboardSegue) {
        guard segue.identifier == "saveSegue" else { return }
        
        let source = segue.source as! AddEditTableViewController
        let tank = source.tank
        
        if let selectedPath = tableView.indexPathForSelectedRow {
            // Edited cell
            tanks[selectedPath.row] = tank
            tableView.reloadRows(at: [selectedPath], with: .automatic)
        } else {
             // Added.cell
            let indexPath = IndexPath(row: tanks.count, section: 0)
            tanks.append(tank)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
}
