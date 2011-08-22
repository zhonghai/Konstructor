//
//  EasyTableViewController.h
//  Konstructor
//
//  Created by Joshua Stephenson on 5/8/11.
//  Copyright 2011 fr.ivolo.us All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableRowBuilder.h"
#import "TableSectionBuilder.h"
#import "NINonRetainingCollections.h"

static NSString *KonstructorCellIdentifier = @"KonstructorTableViewCell";
static NSString *KonstructorPickerWillShowNotification = @"KonstructorPickerWillShowNotification";
static NSString *KonstructorPickerWillHideNotification = @"KonstructorPickerWillHideNotification";

typedef void (^TableRowBuilderBlock)(TableRowBuilder *builder);
typedef void (^TableSectionHeaderBlock)(UIView *header);
typedef void (^CellConfigurationBlock)(id item, UITableViewCell *cell);
typedef void (^CellBuilderBlock)(id item, UITableViewCell *cell, TableRowBuilder *builder);
typedef void (^TableDrillDownBlock)(id item);



@interface KonstructorTableViewController : UIViewController <TableRowBuilderDelegate> {
    IBOutlet UITableViewCell *loadedCell;
    IBOutlet UITableView *tableView;
    
    UIResponder *currentFormElement;
    
    NSFetchedResultsController *_resultsController;
    
    NSMutableArray *sections;
    
    
    TableSectionBuilderBlock bulkBlock;
    CellConfigurationBlock cellBlock;
    CellBuilderBlock cellBuilderBlock;
    
    TableDrillDownBlock tableDrillDownBlock;
    
    NSMutableArray *elementsToHide;
}

/* Our Table View */
@property (nonatomic,retain) UITableView *tableView;

/* A Fetched Results Controller if you're using CoreData */
@property (nonatomic, retain, readonly) NSFetchedResultsController *resultsController;

@property (nonatomic, retain) NSMutableArray *sections;


/* Used to configure the table view with an array of objects */
@property (nonatomic, copy) TableSectionBuilderBlock bulkBlock;

/* Used to configure each cell when using NSFetchedResultsController */
@property (nonatomic, copy) CellConfigurationBlock cellBlock;

/* Used to configure each cell when using NSFetchedResultsController */
@property (nonatomic, copy) CellBuilderBlock cellBuilderBlock;

/* Use this to configure what each row should drill down into */
@property (nonatomic, copy) TableDrillDownBlock tableDrillDownBlock;

/* Form elements added upon row selection
 need to be hidden when other rows are selected */
@property (nonatomic, retain) NSMutableArray *elementsToHide;

/* Use this to create a table view backed by an array */
- (void)addRowsFromArray:(NSArray *)objects withBuilder:(TableSectionBuilderBlock)builderBlock;

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
- (UIView *)addSectionHeaderWithNibName:(NSString *)nibName andBlock:(TableSectionHeaderBlock)sectionBlock;

/* Use this to generate your table view from a results controller
 * and get back a TableRowBuilder to provide a drillDownBlock
 */
- (void)bindToFetchedResultsController:(NSFetchedResultsController *)resultsController withNibName:(NSString *)nibName andCellBuilderBlock:(CellBuilderBlock)builderBlock;

/* Set the height of the current section */
- (void)setCellHeight:(CGFloat)height;

/* Use this to load your rows if you wish */
- (void)buildRows;

/* Get the first section */
- (TableSectionBuilder *)firstSection;

/* Get the current section (last) */
- (TableSectionBuilder *)currentSection;

/* shorthand for [self.tableView reloadData] */
- (void)reload;

/* called when the main title for a row is displayed */
- (NSString *)labelForRow:(TableRowBuilder *)row;

/* called when the caption for a row is displayed (dateLabel for date rows) */
- (NSString *)captionForRow:(TableRowBuilder *)row;

/* force the keyboard to disappear */
- (void)dismissKeyboard;

@end
