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
typedef void (^DrillDownBlock)(void);

@interface TableRowBuilder : NSObject <UITextFieldDelegate>{
    SEL selector;
    id <NSObject>obj;
    NSString *title;
    NSString *caption;
    
    // Transition to this controller when tapped
    DrillDownBlock drillDownBlock;
    
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
    
    NSString *imagePath;
    
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

/* add any form element: UITextField, UISwitch, etc... */
@property (nonatomic, retain) id formElement;
@property (nonatomic, getter=isOn) BOOL on;
@property (nonatomic, getter=isSelected) BOOL selected;

@property (nonatomic) BOOL toggleable;

/* name of default and selected icon to show */
@property (nonatomic, retain) NSString *iconName;
@property (nonatomic, retain) NSString *selectedIconName;

/* full path for image to be loaded in place of icon */
@property (nonatomic, retain) NSString *imagePath;

@property (nonatomic) UITableViewCellAccessoryType accessoryType;
@property (nonatomic) CGFloat fontSize;

@property (nonatomic, copy) CellConfigurationCallback configurationBlock;
@property (nonatomic, copy) ToggleBlock toggleBlock;
@property (nonatomic, copy) DrillDownBlock drillDownBlock;

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

// password input
+ (id)passwordFieldWithObject:(id)_obj title:(NSString *)_title value:(NSString *)val andSelector:(SEL)_selector;

// buttons
+ (id)buttonWithObject:(id)_obj andSelector:(SEL)_selector;
+ (id)buttonWithObject:(id)_obj title:(NSString *)_title andSelector:(SEL)_selector;

// switches
+ (id)switchWithObject:(id)_obj andtitle:(NSString *)_title;

// generic toggle
+ (id)toggleWithObject:(id)_obj andSelector:(SEL)_selector;

/* Configuration options */
- (void)setKeyboardType:(UIKeyboardType)keyboard;

- (void)setAutoCorrection:(UITextAutocorrectionType)correction autoCapitalization:(UITextAutocapitalizationType)capitalization;

@end
