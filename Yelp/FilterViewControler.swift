//
//  FilterViewControler.swift
//  Yelp
//
//  Created by Giao Tuan on 11/18/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

class FilterViewControler: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func onDoneFilterClicked(sender: UIBarButtonItem) {
        filterBuffer["categories"] = categoryState
        delegate?.FilterViewControlerDelegate(self, didFilterUpdate: filterBuffer)
        dismissViewControllerAnimated(true, completion: nil)

    }
    @IBAction func onCanceClicked(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    var filterBuffer = [String: AnyObject]();
    var distanceArray : [Float?]! = [nil, 0.3, 1, 5, 20]
    var sortArray = ["Best Match", "Distance", "Highest Rated"]
    var isDistanceExpanded = false
    var isSortExpanded = false
    var isCategoryExpanded = false
    var categoryState = [Int:Bool]()
    
    var delegate : FilterViewControlerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // navigation init
        navigationController?.navigationBar.barTintColor = ColorUtils.UIColorFromRGB("00255e");
        navigationController?.navigationBar.tintColor = UIColor.whiteColor();
        navigationController?.navigationBar.titleTextAttributes =  [NSForegroundColorAttributeName: UIColor.whiteColor()];
        title = "Filter"

        // Load default data
        let defaults = NSUserDefaults.standardUserDefaults()
        let outData = defaults.dataForKey("FILTER_KEY")
        if outData != nil {
            filterBuffer = NSKeyedUnarchiver.unarchiveObjectWithData(outData!) as? [String : AnyObject] ?? [String : AnyObject]()
        }
        
        
        // table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100;
        // Do any additional setup after loading the view.
        
        if filterBuffer["sort"] == nil {
            filterBuffer["sort"] = "Best Match"
        }
        categoryState = filterBuffer["categories"] as? [Int:Bool]  ?? [Int:Bool]()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension FilterViewControler : UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate, OptionCellDelegate{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return distanceArray.count
        case 2:
            return sortArray.count
        case 3:
            return CategoriesFiltersUtils.yelpCategories().count
        case 4:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 5
        case 1:
            return 20
        case 2:
            return 20
        case 3:
            return 20
        case 4:
            return 1
        default:
            return 20
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 20
        case 1:
            return 20
        case 2:
            return 20
        case 3:
            return 1
        case 4:
            return 1
        default:
            return 20
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return ""
        case 1:
            return "Distance"
        case 2:
            return "Sort by"
        case 3:
            return "Category"
        case 4:
            return ""
        default:
            return ""
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("switchCell") as! SwitchCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.delegate = self
            cell.titleLabel.text = "Offering a Deal"
            cell.onSwitch.on = filterBuffer["deal"] as? Bool ?? false
            return cell;
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("optionCell") as! OptionCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            let index = indexPath.row
            cell.delegate = self
            generateDistanceView(index, cell: cell)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("optionCell") as! OptionCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            let index = indexPath.row
            cell.delegate = self
            generateSortView(index, cell: cell)
            return cell
        case 3:
            let cell = tableView.dequeueReusableCellWithIdentifier("switchCell") as! SwitchCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            let index = indexPath.row
            cell.delegate = self
            generateCaetegoryView(index, cell: cell)
            return cell;
        case 4:
             let cell = tableView.dequeueReusableCellWithIdentifier("moreCell") as! MoreCell
             return cell
        default:
            return UITableViewCell()
        }
    }
    
    func switchCell(switchCell : SwitchCell, didValueChange value : Bool) {
        let indexPath = tableView.indexPathForCell(switchCell)!
        switch indexPath.section {
        case 0:
            filterBuffer["deal"] = value
            break;
        case 3:
            categoryState[indexPath.row] = value
            break;
        default:
            break;
            
        }
        

    }

    func optionCell(optionCell : OptionCell, onRowSelect selected : Bool) {
        
        let index = tableView.indexPathForCell(optionCell)
        if index != nil {
            switch index!.section {
              case 1:
                    if isDistanceExpanded {
                        filterBuffer["distance"] = distanceArray[index!.row]
                        isDistanceExpanded = false
                    } else {
                        isDistanceExpanded = true
                    }
                    tableView.reloadData()
                    break;
            case 2:
                if isSortExpanded {
                    filterBuffer["sort"] = sortArray[index!.row]
                    isSortExpanded = false
                } else {
                    isSortExpanded = true
                }
                tableView.reloadData()
                break;
            default:
                break;
            }
            
        }
       
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 1:
            if !isDistanceExpanded {
                if indexPath.row == 0 {
                    return 40
                } else {
                    return 0
                }
            } else {
                return 40
            }
        case 2:
            if !isSortExpanded {
                if indexPath.row == 0 {
                    return 40
                } else {
                    return 0
                }
            } else {
                return 40
            }
        case 3:
            if !isCategoryExpanded {
                if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 {
                    return 40
                } else {
                    return 0
                }
            } else {
                return 40
            }
        default:
            return 40
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    // generate view for distance section
    func generateDistanceView(row : Int,cell : OptionCell) {
        let currentDistance = filterBuffer["distance"] as? Float
        if isDistanceExpanded {
            cell.hidden = false
            if row == 0 {
                cell.titleLabel.text = "Auto"
            } else {
                cell.titleLabel.text = "\(distanceArray[row]! as Float)"
            }
            if currentDistance == distanceArray[row] {
                cell.optionImage.image = UIImage(named: "ic_check")
            } else {
                cell.optionImage.image = UIImage(named: "ic_uncheck")
            }
        } else {
            if row == 0 {
                cell.optionImage.image = UIImage(named: "ic_expand")
                if currentDistance == nil {
                    cell.titleLabel.text = "Auto"
                } else {
                    cell.titleLabel.text = "\(currentDistance! as Float)"
                }
            } else {
                cell.hidden = true
            }
            
        }
   }
    // generate view for distance section
    func generateSortView(row : Int,cell : OptionCell) {
        let currentSort = filterBuffer["sort"] as? String
        if isSortExpanded {
            cell.hidden = false
            cell.titleLabel.text = sortArray[row]
            if currentSort == sortArray[row] {
                cell.optionImage.image = UIImage(named: "ic_check")
            } else {
                cell.optionImage.image = UIImage(named: "ic_uncheck")
            }
        } else {
            if row == 0 {
                cell.optionImage.image = UIImage(named: "ic_expand")
                cell.titleLabel.text = currentSort
            } else {
                cell.hidden = true
            }
            
        }

    }
    
    // Generate category view
    func generateCaetegoryView(row : Int,cell : SwitchCell) {
        cell.titleLabel.text = CategoriesFiltersUtils.yelpCategories()[row]["name"]
        cell.onSwitch.on = categoryState[row] ?? false
        if isCategoryExpanded {
            cell.hidden = false
        } else {
            if row == 0 || row == 1 || row == 2 {
                cell.hidden = false
            } else {
                cell.hidden = true
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 4 {
            
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! MoreCell
            if isCategoryExpanded {
                cell.moreLabel.text = "See More"
            } else {
                 cell.moreLabel.text = "See Less"
            }
            isCategoryExpanded = !isCategoryExpanded
            tableView.reloadData()
        }
    }
    
    }

protocol FilterViewControlerDelegate {
    func FilterViewControlerDelegate(filterViewControlerDelegate : FilterViewControler, didFilterUpdate filters : [String: AnyObject] )
    
}
