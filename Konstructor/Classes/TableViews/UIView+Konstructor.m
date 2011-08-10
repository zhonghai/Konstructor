//
//  UIView+Konstructor.m
//  MeetingRoom
//
//  Created by Josh Stephenson on 7/30/11.
//  Copyright 2011 StackMob. All rights reserved.
//

#import "UIView+Konstructor.h"

@implementation UIView (Konstructor)

- (BOOL)isPicker{
    return ([self isKindOfClass:[UIDatePicker class]] || [self isKindOfClass:[UIPickerView class]]);
}

@end
