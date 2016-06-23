//
//  ViewController.m
//  TableViewSearch
//
//  Created by Игорь Талов on 19.05.16.
//  Copyright © 2016 Игорь Талов. All rights reserved.
//

#import "ViewController.h"
#import "ITSection.h"

@interface ViewController ()
@property(strong, nonatomic) NSArray* peopleArray;
@property(strong, nonatomic) NSArray* sectionArray;
@property(strong, nonatomic) NSOperation* currentOperation;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    NSMutableArray* array = [NSMutableArray arrayWithObjects:@"Sergey Shnurov", @"Roman Parygin",@"Puzo",@"Alex Vasyliev",@"Leva-bi2",@"Shura-bi2",@"Max Ivanov",@"Alisa Vox",@"Evgenia Ostroumova",@"Elena Long-Playng",@"Igor Talov",@"Evgenia Talova",@"Marina Sherzo",@"Alex Ivanov",@"Alex Petrov",@"Max Mingela",@"Robert Smith",@"Yan Brown",@"Franz Ferdinand",@"Lou Reed",@"Iggy Pop",@"David Bowie",@"Roger O'Niel",@"Sam Smith",@"Sam Rivers",@"Fred Durst",@"Wes Borland",@"Dj Lethal",@"Fillip Cave",@"Alexander Stuff",@"Gene Simmons", @"George Michael", @"Clint Eastwood",@"Yellow Wulf", nil];
    


    NSSortDescriptor* descriptor = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    
    [array sortUsingDescriptors:@[descriptor]];
    
    self.peopleArray = array;
    self.sectionArray = [self generateSectionsFromArray:self.peopleArray withfilterString:self.searchBar.text];
    
    [self.tableView reloadData];
    
}

-(void) generateSectionsInBackgroundFromArray:(NSArray* )array withfilterString:(NSString* )filterString{
    
    [self.currentOperation cancel];
    
    __weak ViewController* weakSelf = self;
    
    self.currentOperation = [NSBlockOperation blockOperationWithBlock:^{
        
        NSArray* sectionsArray = [weakSelf generateSectionsFromArray:array withfilterString:filterString];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.sectionArray = sectionsArray;
            [weakSelf.tableView reloadData];
            
            self.currentOperation = nil;
        });
    }];
    
    [self.currentOperation start];
    
}

-(NSArray* )generateSectionsFromArray:(NSArray* )array withfilterString:(NSString* )filterString {
    
    NSMutableArray* sectionsArray = [NSMutableArray array];
    
    NSString* currentLetter = nil;
    
    for (NSString* string in array) {
        
        if ([filterString length] > 0 && [string rangeOfString:filterString].location == NSNotFound) {
            continue;
        }
        
        NSString* firstLetter = [string substringToIndex:1];
        
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
        
        [section.itemsArray addObject:string];
    }

    return sectionsArray;
}

#pragma mark - UITableViewDataSource

- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    NSMutableArray* array = [NSMutableArray array];
    
    for (ITSection* section in self.sectionArray) {
        [array addObject:section.name];
    }
    
    return array;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.sectionArray count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return [[self.sectionArray objectAtIndex:section] name];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    ITSection* sec = [self.sectionArray objectAtIndex:section];
    
    return [sec.itemsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* identifier = @"cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    ITSection* section = [self.sectionArray objectAtIndex:indexPath.section];
    NSString* name = [section.itemsArray objectAtIndex:indexPath.row];

    cell.textLabel.text = name;
    
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
    
    self.sectionArray = [self generateSectionsFromArray:self.peopleArray withfilterString:searchText];
    [self.tableView reloadData];
    
}

@end
