//
//  EasyTableViewController.h
//  Konstructor
//
//  Created by Joshua Stephenson on 5/8/11.
//  Copyright 2011 fr.ivolo.us All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableRowBuilder.h"


static NSString *KonstructorCellIdentifier = @"KonstructorTableViewCell";
static NSString *KonstructorPickerWillShowNotification = @"KonstructorPickerWillShowNotification";
static NSString *KonstructorPickerWillHideNotification = @"KonstructorPickerWillHideNotification";

typedef void (^TableRowBuilderBlock)(TableRowBuilder *builder);
typedef void (^BulkTableRowBuilderBlock)(id item, TableRowBuilder *builder);
typedef void (^TableSectionHeaderBuilderBlock)(UIView *header);
typedef void (^CellConfigurationBlock)(id item, UITableViewCell *cell);
typedef void (^CellBuilderBlock)(id item, UITableViewCell *cell, TableRowBuilder *builder);
typedef void (^TableDrillDownBlock)(id item);

@interface KonstructorTableViewController : UIViewController {
    IBOutlet UITableViewCell *loadedCell;
    IBOutlet UITableView *tableView;
    
    NSFetchedResultsController *_resultsController;
    
    NSMutableArray *sections;
    
    NSMutableArray *rowBuilders;
    NSArray *builderObjects;
    NSMutableArray *headerViews;
    
    BulkTableRowBuilderBlock bulkBlock;
    CellConfigurationBlock cellBlock;
    CellBuilderBlock cellBuilderBlock;
    
    TableDrillDownBlock tableDrillDownBlock;
    
    NSString *customCellNibName;
    CGFloat tableCellHeight;
    
    NSMutableArray *elementsToHide;
}

/* Our Table View */
@property (nonatomic,retain) UITableView *tableView;

/* A Fetched Results Controller if you're using CoreData */
@property (nonatomic, retain, readonly) NSFetchedResultsController *resultsController;

@property (nonatomic, retain) NSMutableArray *sections;

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

/* Used to configure each cell when using NSFetchedResultsController */
@property (nonatomic, copy) CellBuilderBlock cellBuilderBlock;

/* Use this to configure what each row should drill down into */
@property (nonatomic, copy) TableDrillDownBlock tableDrillDownBlock;

/* Used to load a custom nib for each cell */
@property (nonatomic, retain) NSString *customCellNibName;

/* Set a custom size for each cell */
@property (nonatomic) CGFloat tableCellHeight;

/* Form elements added upon row selection
 need to be hidden when other rows are selected */
@property (nonatomic, retain) NSMutableArray *elementsToHide;

/* Use this to create a table view backed by an array */
- (void)addRowsFromArray:(NSArray *)objects withBuilder:(BulkTableRowBuilderBlock)builderBlock;

/* 
 * Use this to create each row by hand
 * This is ideal for settings views
 */
- (TableRowBuilder *)addRow:(TableRowBuilderBlock)builderBlock;

/* 
 * Use this to add a pre-configured row to the current section
 */
- (void)addRowWithBuilder:(TableRowBuilder *)builder;

/*
 * Use this to create each row by hand with the cell passed in
 */
- (TableRowBuilder *)addRowWithCellBlock:(CellConfigurationBlock)_cellBlock;

/* Use this to add a custom section header */
- (UIView *)addSectionHeader:(TableSectionHeaderBuilderBlock)builderBlock;

/* Use this to generate your table view from a results controller */
- (void)bindToFetchedResultsController:(NSFetchedResultsController *)resultsController withCellBlock:(CellConfigurationBlock)cellBlock;

/* Use this to generate your table view from a results controller
 * and get back a TableRowBuilder to provide a drillDownBlock
 */
- (void)bindToFetchedResultsController:(NSFetchedResultsController *)resultsController withCellBuilderBlock:(CellBuilderBlock)cellBlock;

/* Use this to load your rows if you wish */
- (void)buildRows;

/* shorthand for [self.tableView reloadData] */
- (void)reload;

/* Use this to return a custom UITableViewCell subclass */
- (UITableViewCell *)dequeueCellForTableView:(UITableView *)tableView;

/* called when the main title for a row is displayed */
- (NSString *)labelForRow:(TableRowBuilder *)row;

/* called when the caption for a row is displayed (dateLabel for date rows) */
- (NSString *)captionForRow:(TableRowBuilder *)row;

@end
