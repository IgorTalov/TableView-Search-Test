//
//  ViewController.h
//  TableViewSearch
//
//  Created by Игорь Талов on 19.05.16.
//  Copyright © 2016 Игорь Талов. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UITableViewController <UISearchBarDelegate>

@property(weak, nonatomic) IBOutlet UISearchBar* searchBar;

@end

