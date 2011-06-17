//
//  MyListViewController.m
//  Konstructor
//
//  Created by Joshua Stephenson on 6/16/11.
//  Copyright 2011 fr.ivolo.us. All rights reserved.
//

#import "MyListViewController.h"


@implementation MyListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
- (void)viewDidLoad{
    self.tableCellHeight = 100.0;
    [self addRow:^(TableRowBuilder *builder){
        builder.title = @"Socks";
        builder.caption = @"The things that go on your feet";
        builder.iconName = @"comment_minus_48.png";
        builder.selectedIconName = @"comment_plus_48.png";
        builder.selector = @selector(toggle:);
    }];
    
    [self addRow:^(TableRowBuilder *builder){
        builder.title = @"Muffs";
        builder.caption = @"Ear warmers or a punk band...";
        builder.iconName = @"comment_minus_48.png";
        builder.selectedIconName = @"comment_plus_48.png";
        builder.selector = @selector(toggle:);
    }];
    
    [self addRow:^(TableRowBuilder *builder){
        builder.title = @"Shoes";
        builder.caption = @"How many pairs do you own?";
        builder.iconName = @"comment_minus_48.png";
        builder.selectedIconName = @"comment_plus_48.png";
        builder.selector = @selector(toggle:);
    }];
    [super viewDidLoad];
}

- (void)toggle:(TableRowBuilder *)builder{
    builder.selected = !builder.selected;
    NSArray *indexPaths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:[self.rowBuilders indexOfObject:builder] inSection:0]];
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


@end
