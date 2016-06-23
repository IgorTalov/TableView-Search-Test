//
//  ITStudent.m
//  TableViewSearch
//
//  Created by Игорь Талов on 19.05.16.
//  Copyright © 2016 Игорь Талов. All rights reserved.
//

#import "ITStudent.h"

@implementation ITStudent

static NSString* firstNames[] = {@"Mike",@"John",@"Shein",@"Nick",@"Hanna",@"Jack",@"Jenny",@"Lou",@"David",@"Anna",@"Stive",@"Glenn",@"Kim",};

static NSString* lastNames[] = {@"Jobs",@"Hatheway",@"Simmons",@"Black",@"White",@"Swan",@"Hanygan",@"Cloudy",@"May",@"Willis",@"Depp",@"Crown",@"Klein",};

+(ITStudent* )createStudent{
    
    ITStudent* student = [[ITStudent alloc]init];
    
    student.firstName = firstNames[arc4random_uniform(13)];
    student.lastName = lastNames[arc4random_uniform(13)];
    student.birthDate = [NSString stringWithFormat:@"%@", [NSDate dateWithTimeIntervalSince1970:60 * 60 * 24 * 365 * arc4random_uniform(21)]];
    student.grade = (float)arc4random_uniform(201) / 100.1f + 2.1f;
    return student;
}

@end
