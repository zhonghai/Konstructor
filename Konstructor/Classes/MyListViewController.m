//
//  MyListViewController.m
//  Konstructor
//
//  Created by Joshua Stephenson on 6/16/11.
//  Copyright 2011 fr.ivolo.us. All rights reserved.
//

#import "MyListViewController.h"
#import "MyDetailViewController.h"

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
    NSDictionary *gloves = [NSDictionary dictionaryWithObjectsAndKeys:@"Gloves", @"name", @"for your hands", @"caption", nil];
    NSDictionary *muffs = [NSDictionary dictionaryWithObjectsAndKeys:@"Muffs", @"name", @"for your ears", @"caption", nil];
    NSDictionary *shoes = [NSDictionary dictionaryWithObjectsAndKeys:@"Socks", @"name", @"for your feets", @"caption", nil];
    NSDictionary *scarves = [NSDictionary dictionaryWithObjectsAndKeys:@"Scarves", @"name", @"for your neck", @"caption", nil];
    NSArray *items = [[NSArray alloc] initWithObjects:gloves, muffs, shoes, scarves, nil];

    /* Build a Table from an Array and fully customize the cell */
    
    [self addRowsFromArray:items withBuilder:^(id item, TableRowBuilder *builder){
        NSDictionary *current = (NSDictionary *)item;
        
        /* Fully customize the cell */
        builder.configurationBlock = ^(UITableViewCell *cell){
            UILabel *titleLabel = (UILabel *)[loadedCell viewWithTag:101];
            titleLabel.text = [current objectForKey:@"name"];
            
            UILabel *captionLabel = (UILabel *)[loadedCell viewWithTag:102];
            captionLabel.text = [current objectForKey:@"caption"];
            
            UIImageView *imageView = (UIImageView *)[loadedCell viewWithTag:103];
            imageView.image = [UIImage imageNamed:builder.selected ? @"comment_plus_48.png" : @"comment_minus_48.png"];
            
            builder.drillDownBlock = ^{
                MyDetailViewController *controller = [[MyDetailViewController alloc] initWithItem:[current objectForKey:@"name"]];
                [self.navigationController pushViewController:controller animated:YES];
            };
        };
        builder.selector = @selector(toggle:);
    }];
    
    /*
     * Use this to auto-customize
     *
     [self addRowsFromArray:items withBuilder:^(id item, TableRowBuilder *builder){
     NSDictionary *current = (NSDictionary *)item;
     
        builder.title = [current objectForKey:@"title"];
        builder.caption = [current objectForKey:@"caption"];
        builder.iconName = @"comment_minus_48.png";
        builder.selectedIconName = @"comment_plus_48.png";
        builder.selector = @selector(toggle:);
     }];
     
     */
    
    /*
     * Use this to add rows one at a time *
     * You can't mix this with addRowsFromArray (yet)
    
    [self addRow:^(TableRowBuilder *builder){
         builder.title = @"Hats";
         builder.caption = @"for your head";
         builder.iconName = @"comment_minus_48.png";
         builder.selectedIconName = @"comment_plus_48.png";
         builder.selector = @selector(toggle:);
     }];
     
    [self addRow:^(TableRowBuilder *builder){
        builder.title = @"Gloves";
        builder.caption = @"for your hands";
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
