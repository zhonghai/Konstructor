//
//  EasyTableViewController.h
//  Konstructor
//
//  Created by Joshua Stephenson on 5/8/11.
//  Copyright 2011 fr.ivolo.us All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableRowBuilder.h"

typedef void (^TableRowBuilderBlock)(TableRowBuilder *builder);
typedef void (^BulkTableRowBuilderBlock)(id item, TableRowBuilder *builder);
typedef void (^TableSectionHeaderBuilderBlock)(UIView *header);
typedef void (^CellConfigurationBlock)(id item, UITableViewCell *cell);

@interface KonstructorTableViewController : UIViewController {
    IBOutlet UITableViewCell *loadedCell;
    IBOutlet UITableView *tableView;
    
    NSFetchedResultsController *_resultsController;
    
    NSMutableArray *rowBuilders;
    NSArray *builderObjects;
    NSMutableArray *headerViews;
    
    BulkTableRowBuilderBlock bulkBlock;
    CellConfigurationBlock cellBlock;
    
    NSString *customCellNibName;
    CGFloat tableCellHeight;
}

/* Our Table View */
@property (nonatomic,retain) UITableView *tableView;

/* A Fetched Results Controller if you're using CoreData */
@property (nonatomic, retain, readonly) NSFetchedResultsController *resultsController;

/* Stores an array of the builder objects which configure rows */
@property (nonatomic,retain) NSMutableArray *rowBuilders;

/* Stores a reference to the objects used to populate each row */
@property (nonatomic, copy) NSArray *builderObjects;

/* Stores an array of the headers for each section */
@property (nonatomic, retain) NSMutableArray *headerViews;

/* Used to configure the table view with an array of objects */
@property (nonatomic, copy) BulkTableRowBuilderBlock bulkBlock;

/* Used to configure each cell when using NSFetchedResultsController */
@property (nonatomic, copy) CellConfigurationBlock cellBlock;

/* Used to load a custom nib for each cell */
@property (nonatomic, retain) NSString *customCellNibName;

/* Set a custom size for each cell */
@property (nonatomic) CGFloat tableCellHeight;


/* Use this to create a table view backed by an array */
- (void)addRowsFromArray:(NSArray *)objects withBuilder:(BulkTableRowBuilderBlock)builderBlock;

/* Use this to create each row by hand
 * This is ideal for settings views
 */
- (TableRowBuilder *)addRow:(TableRowBuilderBlock)builderBlock;

/* Use this to add a custom section header */
- (UIView *)addSectionHeader:(TableSectionHeaderBuilderBlock)builderBlock;

/* Use this to generate your table view from a results controller */
- (void)bindToFetchedResultsController:(NSFetchedResultsController *)resultsController withCellBlock:(CellConfigurationBlock)cellBlock;

/* Use this to load your rows if you wish */
- (void)buildRows;

/* shorthand for [self.tableView reloadData] */
- (void)reload;

@end
