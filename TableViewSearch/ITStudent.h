//
//  ITStudent.h
//  TableViewSearch
//
//  Created by Игорь Талов on 19.05.16.
//  Copyright © 2016 Игорь Талов. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITStudent : NSObject
@property(strong, nonatomic) NSString* firstName;
@property(strong, nonatomic) NSString* lastName;
@property(strong, nonatomic) NSString* birthDate;
@property(assign, nonatomic) double grade;
+(ITStudent* )createStudent;
@end
