//
//  KonstructorAppDelegate.h
//  Konstructor
//
//  Created by Joshua Stephenson on 6/16/11.
//  Copyright 2011 fr.ivolo.us. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyListViewController.h"

@interface KonstructorAppDelegate : NSObject <UIApplicationDelegate> {
    IBOutlet MyListViewController *listViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
