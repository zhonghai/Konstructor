//
//  EasyTableViewController.h
//  ThreeHundred
//
//  Created by Joshua Stephenson on 5/8/11.
//  Copyright 2011 fr.ivolo.us All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableRowBuilder.h"

typedef void (^TableRowBuilderBlock)(TableRowBuilder *builder);
typedef void (^TableSectionHeaderBuilderBlock)(UIView *header);

@interface KonstructorTableViewController : UIViewController {
    /* Use this to load cells from their own nib */
    IBOutlet UITableViewCell *loadedCell;
    
    /* array of builders used to configure cells */
    NSMutableArray *rowBuilders;
    
    IBOutlet UITableView *tableView;
    
    CGFloat tableCellHeight;
}

@property (nonatomic,retain) UITableView *tableView;
@property (nonatomic,retain) NSMutableArray *rowBuilders;
@property (nonatomic,retain) NSMutableArray *headerViews;

@property (nonatomic) CGFloat tableCellHeight;

- (UITableViewCell *)configureGroupedCellAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)configurePlainCellAtIndexPath:(NSIndexPath *)indexPath;

- (void)rowTapped:(TableRowBuilder *)row;
- (void)toggleRow:(TableRowBuilder *)row;
- (void)addToggleForCell:(UITableViewCell *)cell builder:(TableRowBuilder *)builder;

- (NSString *)labelForRow:(TableRowBuilder *)row;
- (NSString *)customNibCellName;
- (TableRowBuilder *)addRow:(TableRowBuilderBlock)builderBlock;
- (UIView *)addSectionHeader:(TableSectionHeaderBuilderBlock)builderBlock;
- (void)buildRows;
- (void)reload;

@end
