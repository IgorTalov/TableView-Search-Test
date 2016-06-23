//
//  ITStudentViewController.m
//  TableViewSearch
//
//  Created by Игорь Талов on 19.05.16.
//  Copyright © 2016 Игорь Талов. All rights reserved.
//

#import "ITStudentViewController.h"
#import "ITStudent.h"
#import "ITSection.h"

@interface ITStudentViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property(strong, nonatomic) NSArray* students;
@property(strong, nonatomic) NSArray* sections;
@property(strong, nonatomic) NSOperation* currentOperation;
@end

@implementation ITStudentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.students = [self generateArrayWithStudents];
    [self generateSectionsFromArrayInBackground:self.students withfilterString:self.searchBar.text];
}

-(NSArray* )generateArrayWithStudents{
    
    NSMutableArray* array = [NSMutableArray array];
    
    for (int i = 0; i <= 40; i++) {
        [array addObject:[ITStudent createStudent]];
    }
    
    NSSortDescriptor* firstNameDescriptor = [[NSSortDescriptor alloc]initWithKey:@"firstName" ascending:YES];
    NSSortDescriptor* lastNameDescriptor = [[NSSortDescriptor alloc]initWithKey:@"lastName" ascending:YES];
    [array sortUsingDescriptors:@[firstNameDescriptor, lastNameDescriptor]];
    
    return array;
}

#pragma mark - Generate Sections

-(void)generateSectionsFromArrayInBackground:(NSArray* )array withfilterString:(NSString* )filterString {
    
    [self.currentOperation cancel];
    
    __weak ITStudentViewController* weakSelf = self;
    
    self.currentOperation = [NSBlockOperation blockOperationWithBlock:^{
        
        NSArray* sectionsArray = [weakSelf generateSectionsFromArray:array withFilterString:filterString];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.sections = sectionsArray;
            [weakSelf.tableView reloadData];
            
            self.currentOperation = nil;
        });
    }];
    [self.currentOperation start];
}

-(NSArray* )generateSectionsFromArray:(NSArray* )array withFilterString:(NSString* )filterString {
    
    NSString* key = [self keyForSorted];
    
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc]initWithKey:key ascending:YES];
    
    NSArray* sortArray = [array sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    NSMutableArray* sectionsArray = [NSMutableArray array];
    
    NSString* currentLetter = nil;
    
    for (ITStudent* student in sortArray) {
        
        if ([filterString length] > 0 && [student.firstName rangeOfString:filterString].location && [student.lastName rangeOfString:filterString].location == NSNotFound){
            continue;
        }
        
        NSString* firstLetter = [student.firstName substringToIndex:1];
        
        ITSection* section = nil;
        
        if (![currentLetter isEqualToString:firstLetter]) {
            section = [[ITSection alloc]init];
            section.name = firstLetter;
            section.itemsArray = [NSMutableArray array];
            currentLetter = firstLetter;
            [sectionsArray addObject:section];
        } else {
            section = [sectionsArray lastObject];
        }
        
        [section.itemsArray addObject:student];
    
    }
    
    for(ITSection* section in sectionsArray){
        NSSortDescriptor* firstNameDescriptor = [[NSSortDescriptor alloc]initWithKey:@"firstName" ascending:YES];
        NSSortDescriptor* lastNameDescriptor = [[NSSortDescriptor alloc]initWithKey:@"lastName" ascending:YES];

    [section.itemsArray sortUsingDescriptors:@[firstNameDescriptor, lastNameDescriptor]];
    }
    
    return sectionsArray;
}

#pragma mark - UITableViewDataSource

- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    NSMutableArray* array = [NSMutableArray array];
    
    for (ITSection* section in self.sections) {
        [array addObject:section.name];
    }
    
    return array;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.sections count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return [[self.sections objectAtIndex:section]name];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    ITSection* sec = [self.sections objectAtIndex:section];
    return [sec.itemsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* ide = @"cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:ide];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ide];
    }
    ITSection* section = [self.sections objectAtIndex:indexPath.section];
    ITStudent* student = [section.itemsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%1.2f", student.grade];
    
    return cell;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    NSLog(@"textDidChange %@", searchText);
    
    self.sections = [self generateSectionsFromArray:self.students withFilterString:searchText];
    [self.tableView reloadData];
    
}

-(NSString* )keyForSorted{
    
    NSString* key = nil;
    
    if (self.segmentControl.selectedSegmentIndex == 0) {
         key = @"firstName";
    } else if (self.segmentControl.selectedSegmentIndex == 1){
        key = @"lastName";
    } else if (self.segmentControl.selectedSegmentIndex == 2) {
        key = @"grade";
    }
    
    return key;
}

- (IBAction)segmentControl:(UISegmentedControl *)sender {
    
    if (self.segmentControl.selectedSegmentIndex == 0) {
        [self generateSectionsFromArrayInBackground:self.students withfilterString:self.searchBar.text];
    } else if (self.segmentControl.selectedSegmentIndex == 1) {
        [self generateSectionsFromArrayInBackground:self.students withfilterString:self.searchBar.text];
    } else if (self.segmentControl.selectedSegmentIndex == 2){
    [self generateSectionsFromArrayInBackground:self.students withfilterString:self.searchBar.text];
    }
    
    
}
@end
