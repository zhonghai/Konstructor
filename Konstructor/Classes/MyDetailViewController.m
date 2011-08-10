//
//  MyDetailViewController.m
//  Konstructor
//
//  Created by Joshua Stephenson on 6/19/11.
//  Copyright 2011 fr.ivolo.us. All rights reserved.
//

#import "MyDetailViewController.h"


@implementation MyDetailViewController

@synthesize item;

- (id)initWithItem:(NSString *)name
{
    self = [super init];
    if (self) {
        self.item = name;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    self.title = item;
    [self addSectionHeader:^(UIView *view){}];
    
    self.tableCellHeight = 100.0f;
    [self addRow:^(TableRowBuilder *builder){
        builder.title = @"item 1";
        builder.caption = @"description for item 1";
        builder.iconName = @"comment_minus_48.png";
        builder.selectedIconName = @"comment_minus_48.png";
    }];
    
    [self addRow:^(TableRowBuilder *builder){
        builder.title = @"item 2";
        builder.caption = @"description for item 2";
        builder.iconName = @"comment_minus_48.png";
        builder.selectedIconName = @"comment_minus_48.png";
    }];

    [self addRow:^(TableRowBuilder *builder){
        builder.title = @"item 3";
        builder.caption = @"description for item 3";
        builder.iconName = @"comment_minus_48.png";
        builder.selectedIconName = @"comment_minus_48.png";
    }];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
