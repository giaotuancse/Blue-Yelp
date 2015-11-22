//
//  DetailViewController.swift
//  Yelp
//
//  Created by Giao Tuan on 11/22/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {
    @IBOutlet weak var backgroundImageView: UIImageView!
    var selectedBusiness: Business!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    let regionRadius: CLLocationDistance = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // init navigation controller
        navigationController?.navigationBar.barTintColor = ColorUtils.UIColorFromRGB("00255e");
        navigationController?.navigationBar.tintColor = UIColor.whiteColor();
        navigationController?.navigationBar.titleTextAttributes =  [NSForegroundColorAttributeName: UIColor.whiteColor()];
        title = selectedBusiness.name
        // Do any additional setup after loading the view.
        loadBussinessView()
        // Add rotation listener
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name:
            UIDeviceOrientationDidChangeNotification, object: nil)
        
        // init map with marker
        let initialLocation = CLLocation(latitude: selectedBusiness.latitude, longitude: selectedBusiness.longitude);centerMapOnLocation(initialLocation)
        let location = CLLocationCoordinate2DMake(selectedBusiness.latitude, selectedBusiness.longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title =  selectedBusiness.name
        annotation.subtitle = selectedBusiness.distance
        mapView.addAnnotation(annotation)
        
    }
    
    func loadBussinessView() {
        backgroundImageView.setImageWithURL(selectedBusiness.imageURL ?? NSURL())
        rotated()
        titleLabel.text = selectedBusiness.name
        addressLabel.text = selectedBusiness.address
        posterImageView.setImageWithURL(selectedBusiness.imageURL ?? NSURL())
        ratingImageView.setImageWithURL(selectedBusiness.ratingImageURL ?? NSURL())
        distanceLabel.text = selectedBusiness.distance
        reviewsLabel.text = "\(selectedBusiness.reviewCount as! Int) Reviews"

    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func rotated()
    {
        // re-blur image view
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = backgroundImageView.bounds
        backgroundImageView.addSubview(blurView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBackClicked(sender: UIBarButtonItem) {
       dismissViewControllerAnimated(true, completion: nil)
    }
}
