//
//  TableViewObject.m
//  Konstructor
//
//  Created by Joshua Stephenson on 5/8/11.
//  Copyright 2011 fr.ivolo.us All rights reserved.
//

#import "TableRowBuilder.h"


@implementation TableRowBuilder

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
@synthesize accessoryType;
@synthesize configurationBlock;
@synthesize fontSize;
@synthesize drillDownController;

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
    [super dealloc];
}

- (id)init{
    self = [super init];
    if(self){
        self.toggleable = NO;
    }
    return self;
}

+ (id)genericBuilder{
    TableRowBuilder *row = [[[self class] alloc] init];
    row.titleTag = 1;
    row.captionTag = 2;
    row.iconTag = 3;
    return row;
}

+ (id)itemWithCallback:(CellConfigurationCallback)callback{
    TableRowBuilder *row = [[[self class] alloc] init];
    row.configurationBlock = callback;
    return row;
}

+ (id)itemWithTitle:(NSString *)_title{
    TableRowBuilder *row = [[[self class] alloc] init];
    row.title = _title;
    return row;
}

+ (id)textFieldWithObject:(id)_obj title:(NSString *)_title value:(NSString *)val andSelector:(SEL)_selector{
    TableRowBuilder *row = [[[self class] alloc] init];
    row.obj = _obj;
    row.title = _title;
    row.selector = _selector;
    UITextField *tv = [[UITextField alloc] initWithFrame:CGRectMake(120, 10, 200, 25)];
    [tv setDelegate:row];
    
    tv.text = val;
    row.formElement = tv;
    return row;
}

+ (id)buttonWithObject:(id)_obj andSelector:(SEL)_selector{
    TableRowBuilder *row = [[[self class] alloc] init];
    row.selector = _selector;
    row.obj = _obj;
    return row;
}

+ (id)toggleWithObject:(id)_obj andSelector:(SEL)_selector{
    TableRowBuilder *row = [[[self class] alloc] init];
    row.toggleable = YES;
    row.on = NO;
    row.selector = _selector;
    row.obj = _obj;
    return row;
}

+ (id)buttonWithObject:(id)_obj title:(NSString *)_title andSelector:(SEL)_selector{
    TableRowBuilder *row = [[[self class] alloc] init];
    row.selector = _selector;
    row.obj = _obj;
    row.title = _title;
    return row;
}

+ (id)switchWithObject:(id)_obj andtitle:(NSString *)_title{
    TableRowBuilder *row = [[[self class] alloc] init];
    row.obj = _obj;
    row.title = _title;
    row.toggleable = YES;
    UISwitch *_switch = [[UISwitch alloc] initWithFrame:CGRectMake(200, 10, 100, 25)];
    row.formElement = _switch;
    return row;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self.obj performSelector:selector withObject:textField.text];
}

@end
