//
//  SchedulePage.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 04/12/17.
//  Copyright © 2017 Shreyas Aiyar. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import CoreData

class SchedulePage: UIViewController,NVActivityIndicatorViewable,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,AddToFavoritesProtocol,UITabBarControllerDelegate,UIScrollViewDelegate,RemoveFromFavoritesProtocol{
    
    @IBOutlet var favoritesView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: Creating Objects
    let cacheCheck = CacheCheck()
    let httpRequestObject = HTTPRequest()
    let scheduleNetworkingObject = ScheduleNetworking()
    let categoriesURL = "https://api.mitportals.in/schedule/"
    var scheduleDataSource:[[NSManagedObject]] = [[]]
    var filteredDataSource:[[NSManagedObject]] = [[]]
    var favoritesDataSource:[Schedules] = []
    var currentIndex:Int = 0
    var searchBar = UISearchBar()
    var shouldShowSearchResults = false
    var isSelectedIndex:[Int] = [-1,-1,-1,-1]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        favoritesView.layer.cornerRadius = 10
        createBarButtonItems()
        configureNavigationBar()
        fetchFavorites()
        fetchSchedules()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.delegate = self
    }
    
    func addToFavorites(eid:String) {
        scheduleNetworkingObject.addFavoritesToCoreData(eid: eid)
        fetchFavorites()
        tableView.reloadData()
        
    }
    
    func removeFromFavorites(eid: String) {
        scheduleNetworkingObject.removeFavorites(eid: eid)
        fetchFavorites()
        tableView.reloadData()
    }
    
    //MARK: Reload Data When Reload Button Clicked
    override func reloadData(){
        //fetchSchedules()
        self.tableView.reloadData()
    }

    //MARK: Configure Search Button
     override func searchButtonPressed() {
        super.searchButtonPressed()
        searchBar.text = ""
        searchBar.prompt = "Search Here"
        searchBar.showsCancelButton = true
        searchBar.alpha = 1
        navigationItem.titleView = searchBar
        self.searchBar.becomeFirstResponder()
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        searchBar.showsCancelButton = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        hideSearchBar()
        tableView.reloadData()
    }


    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduleDataSource[currentIndex].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell") as! ScheduleCell
        cell.delegate1 = self
        cell.delegate2 = self
        cell.eid = scheduleDataSource[currentIndex][indexPath.row].value(forKey: "eid") as! String
        cell.eventName.text! = scheduleDataSource[currentIndex][indexPath.row].value(forKey: "ename") as! String
        cell.time.text! = (scheduleDataSource[currentIndex][indexPath.row ].value(forKey: "stime") as! String) + " - " + (scheduleDataSource[currentIndex][indexPath.section].value(forKey: "etime") as! String)
        cell.location.text! = scheduleDataSource[currentIndex][indexPath.row].value(forKey: "venue") as! String
        if favoritesDataSource.contains(where: {$0.eid == cell.eid}){
            cell.favouriteButton.isSelected = true
        }else{
         cell.favouriteButton.isSelected = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isSelectedIndex[currentIndex] = indexPath.row
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return CGFloat(70)
    }
    
    
    @IBAction func segmentedValueChanged(_ sender: Any) {
        currentIndex = segmentedControl.selectedSegmentIndex
        self.tableView.reloadSections([0], with: .automatic)
    }
    
    
    func fetchSchedules(){
        startAnimating()
        scheduleNetworkingObject.fetchSchedules(){
            self.scheduleDataSource = self.scheduleNetworkingObject.fetchScheduleFromCoreData()
            self.tableView.reloadData()
            self.stopAnimating()
        }
    }
    
    func fetchFavorites(){
        self.favoritesDataSource = scheduleNetworkingObject.fetchFavoritesFromCoreData()
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        self.tableView.setContentOffset(CGPoint.zero, animated: true)
    }

}
