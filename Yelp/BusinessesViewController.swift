//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import SWActivityIndicatorView
import AFNetworking

class BusinessesViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, FilterViewControlerDelegate,UISearchBarDelegate{

    @IBOutlet weak var activityIndicatorView: SWActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noResultLabel: UILabel!
    
    var businesses = [Business]()
    var filterBusinesses = [Business]()
    var searchBar : UISearchBar!
    var refreshControl:UIRefreshControl!
    var baseFilter = [String : AnyObject]()
    var isSearch = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = ColorUtils.UIColorFromRGB("00255e");
        navigationController?.navigationBar.tintColor = UIColor.whiteColor();
        navigationController?.navigationBar.titleTextAttributes =  [NSForegroundColorAttributeName: UIColor.whiteColor()];
        //title = "YelpBlue"
        
        // initialize UISearchBar
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        // init table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableViewAutomaticDimension
       
        let defaults = NSUserDefaults.standardUserDefaults()
        let outData = defaults.dataForKey("FILTER_KEY")
        if outData != nil {
            baseFilter = NSKeyedUnarchiver.unarchiveObjectWithData(outData!) as? [String : AnyObject] ?? [String : AnyObject]()
        }
       fecthDataWithFilter(baseFilter)
        
        // Refresh UI
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: "refreshDataWithBaseFilter", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)

   }
    
    func fecthDataWithFilter(filter: [String:AnyObject]) {
        self.activityIndicatorView.hidesWhenStopped = true
        self.noResultLabel.hidden = true
        self.activityIndicatorView.startAnimating()
        self.tableView.hidden = true
        let term = filter["term"] as? String ?? "Restaurants"
        print("term", term)
        let sort = CategoriesFiltersUtils.getSortTypeFromString(filter["distance"] as? String)
        print("sort", sort)
        let cate = CategoriesFiltersUtils.getListCategoryFromListBool(filter["categories"] as? [Int:Bool] ?? [Int:Bool]())
         print("cate", cate)
        let deal = filter["deal"] as? Bool ?? false
        print("deal", deal)
        let distance = filter["distance"] as? Float ?? nil
        print("distance", distance)
        Business.searchWithTerm(term, sort: sort , categories: cate , deals: deal, distance:  distance) { (businesses: [Business]!, error: NSError!) -> Void in
            guard error == nil else  {
                print("error loading from URL", error!)
                self.activityIndicatorView.stopAnimating()
                self.noResultLabel.hidden = false
                return
            }
            if businesses.count == 0 {
                self.activityIndicatorView.stopAnimating()
                self.noResultLabel.hidden = false
                return
            }
            self.businesses = businesses
            for business in businesses {
                print(business.name!)
                //print(business.address!)
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
                self.activityIndicatorView.stopAnimating()
                self.tableView.hidden = false
            })
        }
        
    }
    func refreshDataWithBaseFilter() {
        
        let term = baseFilter["term"] as? String ?? "Restaurants"
        print("term", term)
        let sort = CategoriesFiltersUtils.getSortTypeFromString(baseFilter["distance"] as? String)
        print("sort", sort)
        let cate = CategoriesFiltersUtils.getListCategoryFromListBool(baseFilter["categories"] as? [Int:Bool] ?? [Int:Bool]())
        print("cate", cate)
        let deal = baseFilter["deal"] as? Bool ?? false
        print("deal", deal)
        let distance = baseFilter["distance"] as? Float ?? nil
        print("distance", distance)
        Business.searchWithTerm(term, sort: sort , categories: cate , deals: deal, distance: distance) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            for business in businesses {
                print(business.name!)
                //print(business.address!)
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            })
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true;
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        fecthDataWithFilter(baseFilter)
        self.tableView.addSubview(refreshControl)
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        //searchSettings.searchString = searchBar.text
        searchBar.resignFirstResponder()
        let newTerm = searchBar.text
        var newFilter = baseFilter
        newFilter["term"] = newTerm ?? ""
        fecthDataWithFilter(newFilter)
        print("Search new filter")
        //doSearch()
        self.refreshControl.removeFromSuperview();
    }
    
    @available(iOS 2.0, *)
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.businesses.count
    }

    @available(iOS 2.0, *)
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("bussinessCell") as! BussinessCellTableViewCell
        let current = businesses[indexPath.row]
        cell.nameLabel.text = current.name
        cell.addressLabel.text = current.address
        cell.thumbnailImageView.setImageWithURL(current.imageURL ?? NSURL())
        cell.ratingImageView.setImageWithURL(current.ratingImageURL ?? NSURL())
        cell.distanceLabel.text = current.distance
        cell.reivewLabel.text = "\(current.reviewCount as! Int) Reviews"
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationControler = segue.destinationViewController as! UINavigationController
        let nextViewControler = navigationControler.topViewController
        if nextViewControler is FilterViewControler {
            (nextViewControler as! FilterViewControler).delegate = self
        } else if nextViewControler is DetailViewController {
            let indexPath = self.tableView.indexPathForSelectedRow!
            (nextViewControler as! DetailViewController).selectedBusiness = businesses[indexPath.row]
        }
        
    }
    
    func FilterViewControlerDelegate(filterViewControlerDelegate : FilterViewControler, didFilterUpdate filters : [String: AnyObject] ) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let data = NSKeyedArchiver.archivedDataWithRootObject(filters)
        defaults.setObject(data, forKey: "FILTER_KEY")
        defaults.synchronize()
        fecthDataWithFilter(filters)
    }
}
