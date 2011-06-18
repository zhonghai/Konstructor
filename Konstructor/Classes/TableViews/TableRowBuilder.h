//
//  TableViewObject.h
//  Konstructor
//
//  Created by Joshua Stephenson on 5/8/11.
//  Copyright 2011 fr.ivolo.us All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^CellConfigurationCallback)(UITableViewCell *cell);
typedef void (^ToggleBlock)(void);

@interface TableRowBuilder : NSObject <UITextFieldDelegate>{
    SEL selector;
    id <NSObject>obj;
    NSString *title;
    NSString *caption;
    
    // Transition to this controller when tapped
    Class *drillDownController;
    
    // UITextField, UISwitch, etc.
    id formElement;
    
    // for UISwitch
    BOOL on;
    BOOL toggleable;
    ToggleBlock toggleBlock;
    
    // swap background color
    BOOL selected;
    CellConfigurationCallback configurationBlock;
    
    // main icon
    NSString *iconName;
    
    // main icon when selected
    NSString *selectedIconName;
    
    // Display configuration
    UITableViewCellAccessoryType accessoryType;
    CGFloat fontSize;
    
    // Wiring up to xibs
    NSInteger titleTag;
    NSInteger captionTag;
    NSInteger iconTag;
}

@property (nonatomic) SEL selector;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *caption;
@property (nonatomic, retain) id <NSObject>obj;

/* handoff controller */
@property (nonatomic) Class *drillDownController;

/* add any form element: UITextField, UISwitch, etc... */
@property (nonatomic, retain) id formElement;
@property (nonatomic, getter=isOn) BOOL on;
@property (nonatomic, getter=isSelected) BOOL selected;

@property (nonatomic) BOOL toggleable;
@property (nonatomic, copy) ToggleBlock toggleBlock;

/* name of default and selected icon to show */
@property (nonatomic, retain) NSString *iconName;
@property (nonatomic, retain) NSString *selectedIconName;

@property (nonatomic) UITableViewCellAccessoryType accessoryType;
@property (nonatomic) CGFloat fontSize;

@property (copy) CellConfigurationCallback configurationBlock;

// Wiring up to xibs
@property (nonatomic) NSInteger titleTag;
@property (nonatomic) NSInteger captionTag;
@property (nonatomic) NSInteger iconTag;

// Use this instead of [[... alloc] init];
+ (id)genericBuilder;

// generic row configured in callback
+ (id)itemWithCallback:(CellConfigurationCallback)callback;

// generic row with label
+ (id)itemWithTitle:(NSString *)_label;

// text input
+ (id)textFieldWithObject:(id)_obj title:(NSString *)_title value:(NSString *)val andSelector:(SEL)_selector;

// buttons
+ (id)buttonWithObject:(id)_obj andSelector:(SEL)_selector;
+ (id)buttonWithObject:(id)_obj title:(NSString *)_title andSelector:(SEL)_selector;

// switches
+ (id)switchWithObject:(id)_obj andtitle:(NSString *)_title;

// generic toggle
+ (id)toggleWithObject:(id)_obj andSelector:(SEL)_selector;

@end
