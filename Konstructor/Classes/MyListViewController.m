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
    NSDictionary *hat = [NSDictionary dictionaryWithObjectsAndKeys:@"Gloves", @"name", @"for your hands", @"caption", nil];
    NSDictionary *muffs = [NSDictionary dictionaryWithObjectsAndKeys:@"Muffs", @"name", @"for your ears", @"caption", nil];
    NSDictionary *shoes = [NSDictionary dictionaryWithObjectsAndKeys:@"Socks", @"name", @"for your feets", @"caption", nil];
    NSDictionary *scarves = [NSDictionary dictionaryWithObjectsAndKeys:@"Scarves", @"name", @"for your neck", @"caption", nil];
    NSArray *items = [[NSArray alloc] initWithObjects:hat, muffs, shoes, scarves, nil];
    
    /* Build a Table from an Array */
    [self addRowsFromArray:items withBuilder:^(id item, TableRowBuilder *builder){
        NSDictionary *current = (NSDictionary *)item;
        builder.title = [current objectForKey:@"title"];
        builder.caption = [current objectForKey:@"caption"];
        builder.iconName = @"comment_minus_48.png";
        builder.selectedIconName = @"comment_plus_48.png";
        builder.selector = @selector(toggle:);
    }];
    
    /* Add a one off row to a table */
  /*  [self addRow:^(TableRowBuilder *builder){
        builder.title = @"Hats";
        builder.caption = @"for your head";
        builder.iconName = @"comment_minus_48.png";
        builder.selectedIconName = @"comment_plus_48.png";
        builder.selector = @selector(toggle:);
    }];
    */
    
    [super viewDidLoad];
}

- (void)toggle:(TableRowBuilder *)builder{
    builder.selected = !builder.selected;
    NSLog(@"%@ %@ %@", tableView, builder, rowBuilders);
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
