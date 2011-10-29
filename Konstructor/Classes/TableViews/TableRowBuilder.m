//
//  TableViewObject.m
//  Konstructor
//
//  Created by Joshua Stephenson on 5/8/11.
//  Copyright 2011 fr.ivolo.us All rights reserved.
//

#import "TableRowBuilder.h"
#import "UIView+Konstructor.h"

@implementation TableRowBuilder

@synthesize delegate = _delegate;
@synthesize selector;
@synthesize obj;
@synthesize title;
@synthesize caption;
@synthesize formElement;
@synthesize toggleable;
@synthesize toggleBlock;
@synthesize on;
@synthesize selected;
@synthesize iconName;
@synthesize selectedIconName;
@synthesize imagePath;
@synthesize accessoryType;
@synthesize configurationBlock;
@synthesize fontSize;
@synthesize drillDownBlock;

// Dates
@synthesize dateLabel;

// view tags
@synthesize titleTag;
@synthesize captionTag;
@synthesize iconTag;

- (void)dealloc{
    [obj release];
    obj = nil;
    [title release];
    title = nil;
    [caption release];
    caption = nil;
    [formElement release];
    formElement = nil;
    [iconName release];
    iconName = nil;
    [selectedIconName release];
    selectedIconName = nil;
    [imagePath release];
    imagePath = nil;
    [drillDownBlock release];
    drillDownBlock = nil;
    [toggleBlock release];
    toggleBlock = nil;
    [configurationBlock release];
    configurationBlock = nil;
    [dateLabel release];
    dateLabel = nil;
    [super dealloc];
}

- (id)init{
    self = [super init];
    if(self){
        self.toggleable = NO;
    }
    return self;
}

+ (id)newRowWithDelegate:(id<TableRowBuilderDelegate>)newDelegate
{
    TableRowBuilder *row = [[[[self class] alloc] init] autorelease];
    row.delegate = newDelegate;
    row.titleTag = 101;
    row.captionTag = 102;
    row.iconTag = 103;
    return row;
    
}

+ (id)newRow{
    TableRowBuilder *row = [[[[self class] alloc] init] autorelease];
    row.titleTag = 101;
    row.captionTag = 102;
    row.iconTag = 103;
    return row;
}

+ (id)itemWithCallback:(CellConfigurationCallback)callback{
    TableRowBuilder *row = [[[[self class] alloc] init] autorelease];
    row.configurationBlock = callback;
    return row;
}

+ (id)itemWithTitle:(NSString *)_title{
    TableRowBuilder *row = [[[[self class] alloc] init] autorelease];
    row.title = _title;
    return row;
}

+ (id)textFieldWithObject:(id)_obj title:(NSString *)_title value:(NSString *)val andSelector:(SEL)_selector{
    TableRowBuilder *row = [[[[self class] alloc] init] autorelease];
    row.obj = _obj;
    row.selector = _selector;
    UITextField *tv = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, 280, 25)]; // TODO: hard-coded CGRect
    [tv setPlaceholder:_title];
    [tv setDelegate:row];
    
    tv.text = val;
    row.formElement = tv;
    [tv release];
    return row;
}

+ (id)passwordFieldWithObject:(id)_obj title:(NSString *)_title value:(NSString *)val andSelector:(SEL)_selector{
    TableRowBuilder *row = [self textFieldWithObject:_obj title:_title value:val andSelector:_selector];
    ((UITextField *)row.formElement).secureTextEntry = YES;
    return row;
}

+ (id)dateFieldWithObject:(id)_obj title:(NSString *)_title andSelector:(SEL)_selector{
    TableRowBuilder *row = [[[[self class] alloc] init] autorelease];
    row.obj = _obj;
    row.title = _title;
    row.selector = _selector;
    
    row.dateLabel = [[[UILabel alloc] initWithFrame:CGRectMake(100, 12, 200.0, 20.0)] autorelease];
    row.dateLabel.backgroundColor = [UIColor clearColor];
    row.dateLabel.font = [UIFont systemFontOfSize:13.0];
    [row.dateLabel setTextAlignment:UITextAlignmentRight];

    UIDatePicker *picker = [[[UIDatePicker alloc] init] autorelease];
    [picker addTarget:row action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    picker.minuteInterval = 15;
    row.formElement = picker;
    return row;
}

+ (id)buttonWithObject:(id)_obj andSelector:(SEL)_selector{
    TableRowBuilder *row = [[[[self class] alloc] init] autorelease];
    row.selector = _selector;
    row.obj = _obj;
    return row;
}

+ (id)toggleWithObject:(id)_obj andSelector:(SEL)_selector{
    TableRowBuilder *row = [[[[self class] alloc] init] autorelease];
    row.toggleable = YES;
    row.on = NO;
    row.selector = _selector;
    row.obj = _obj;
    return row;
}

+ (id)buttonWithObject:(id)_obj title:(NSString *)_title andSelector:(SEL)_selector{
    TableRowBuilder *row = [[[[self class] alloc] init] autorelease];
    row.selector = _selector;
    row.obj = _obj;
    row.title = _title;
    return row;
}

+ (id)switchWithObject:(id)_obj andtitle:(NSString *)_title{
    TableRowBuilder *row = [[[[self class] alloc] init] autorelease];
    row.obj = _obj;
    row.title = _title;
    row.toggleable = YES;
    UISwitch *_switch = [[[UISwitch alloc] initWithFrame:CGRectMake(200, 10, 100, 25)] autorelease];
    row.formElement = _switch;
    return row;
}

- (void)setKeyboardType:(UIKeyboardType)keyboard
{
    if(formElement && [formElement isKindOfClass:[UITextField class]]){
        ((UITextField *)formElement).keyboardType = keyboard;
    }
}

- (void)setAutoCorrection:(UITextAutocorrectionType)correction autoCapitalization:(UITextAutocapitalizationType)capitalization{
    if(formElement && [formElement isKindOfClass:[UITextField class]]){
        ((UITextField *)formElement).autocorrectionType = correction;
        ((UITextField *)formElement).autocapitalizationType = capitalization;
    }        
}

# pragma mark -
# pragma Virtual attributes

- (NSDate *)selectedDate{
    UIView *view = self.formElement;
    if([view isKindOfClass:[UIDatePicker class]]){
        UIDatePicker *datePicker = (UIDatePicker *)view;
        return datePicker.date;
    }
    return nil;
}


#pragma mark -
#pragma UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self.delegate tableRowBuilder:self formElementDidBecomeActive:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    // save the value when the user is done
    [self.obj performSelector:selector withObject:textField.text];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    // save the value as the user is typing
    NSString* textAfterEdit = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self.obj performSelector:selector withObject:textAfterEdit];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.obj performSelector:selector withObject:textField.text];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark UIDatePicker Control Events
- (void)dateChanged:(id)sender
{
    NSLog(@"date changed %@", sender);
    UIDatePicker *picker = (UIDatePicker *)sender;
    [self.obj performSelector:selector withObject:picker.date];
    NSLog(@"to %@", picker.date);
}

@end
