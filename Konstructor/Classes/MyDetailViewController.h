//
//  MyDetailViewController.h
//  Konstructor
//
//  Created by Joshua Stephenson on 6/19/11.
//  Copyright 2011 fr.ivolo.us. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KonstructorTableViewController.h"

@interface MyDetailViewController : KonstructorTableViewController {
    NSString *item;
}

@property(nonatomic, copy) NSString *item;

- (id)initWithItem:(NSString *)name;

@end
