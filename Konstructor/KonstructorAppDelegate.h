//
//  KonstructorAppDelegate.h
//  Konstructor
//
//  Created by Joshua Stephenson on 6/16/11.
//  Copyright 2011 fr.ivolo.us. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KonstructorAppDelegate : NSObject <UIApplicationDelegate> {
    IBOutlet UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
