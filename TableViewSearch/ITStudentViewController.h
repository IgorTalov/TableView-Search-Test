//
//  ITStudentViewController.h
//  TableViewSearch
//
//  Created by Игорь Талов on 19.05.16.
//  Copyright © 2016 Игорь Талов. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ITStudentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(weak, nonatomic) IBOutlet UISegmentedControl* segmentControl;
@property(weak, nonatomic) IBOutlet UISearchBar* searchBar;

- (IBAction)segmentControl:(UISegmentedControl *)sender;

@end
