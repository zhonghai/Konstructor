//
//  EasyTableViewController.m
//  Konstructor
//
//  Created by Joshua Stephenson on 5/8/11.
//  Copyright 2011 fr.ivolo.us All rights reserved.
//

#import "KonstructorTableViewController.h"
#import "NINonRetainingCollections.h" 
#import "UIView+Konstructor.h"

@interface KonstructorTableViewController (PrivateMethods)

- (NSString *)labelForRow:(TableRowBuilder *)row;
- (UITableViewCell *)configureGroupedCellAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)configurePlainCellAtIndexPath:(NSIndexPath *)indexPath;
- (void)setup;
- (void)rowTapped:(TableRowBuilder *)row;
- (void)toggleRow:(TableRowBuilder *)row;
- (void)showFormElementForRow:(TableRowBuilder *)row;
- (void)hideFormElements;
- (void)addToggleForCell:(UITableViewCell *)cell builder:(TableRowBuilder *)builder;

@end

static CGFloat const GlobalPickerHeight = 160.0;

@implementation KonstructorTableViewController
@synthesize sections;
@synthesize rowBuilders;
@synthesize headerViews;
@synthesize tableView;
@synthesize resultsController;
@synthesize tableCellHeight;
@synthesize builderObjects;
@synthesize bulkBlock;
@synthesize cellBlock;
@synthesize tableDrillDownBlock;
@synthesize cellBuilderBlock;
@synthesize customCellNibName;
@synthesize elementsToHide;

- (id)init{
    self = [super init];
    [self setup];
    return self;
}

- (void)awakeFromNib{
    [self setup];
    [super awakeFromNib];
}

- (void)dealloc
{
    [tableView release];
    [rowBuilders release];
    [headerViews release];
    [bulkBlock release];
    [cellBlock release];
    [cellBuilderBlock release];
    [tableDrillDownBlock release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [tableView release];
    tableView = nil;
    [sections release];
    sections = nil;
    [rowBuilders release];
    rowBuilders = nil;
    [headerViews release];
    headerViews = nil;
    [bulkBlock release];
    bulkBlock = nil;
    [cellBlock release];
    cellBlock = nil;
    [cellBuilderBlock release];
    cellBuilderBlock = nil;
    [tableDrillDownBlock release];
    tableDrillDownBlock = nil;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [tableView reloadData];
}

- (void)viewDidUnload
{
    
    [tableView release];
    tableView = nil;
    [sections release];
    sections = nil;
    [rowBuilders release];
    rowBuilders = nil;
    [headerViews release];
    headerViews = nil;
    [bulkBlock release];
    bulkBlock = nil;
    [cellBlock release];
    cellBlock = nil;
    [cellBuilderBlock release];
    cellBuilderBlock = nil;
    [tableDrillDownBlock release];
    tableDrillDownBlock = nil;
    [super viewDidUnload];
}

# pragma mark EasyTableViewController

- (UIView *)addSectionHeader:(TableSectionHeaderBuilderBlock)builderBlock{
    self.rowBuilders = nil;
    self.rowBuilders = [NSMutableArray array];
    [self.sections addObject:self.rowBuilders];
    UIView *view = [[UIView alloc] init];    
    view.backgroundColor = [UIColor clearColor];
    [headerViews addObject:view];
    [view release];
    builderBlock(view);
    return view;
}

- (void)addRowsFromArray:(NSArray *)objects withBuilder:(BulkTableRowBuilderBlock)builderBlock{
    self.builderObjects = objects;
    self.bulkBlock = builderBlock;
    for(int i = 0; i < builderObjects.count ; i++){
        [self.rowBuilders addObject:[TableRowBuilder genericBuilder]];
    }
}

- (TableRowBuilder *)addRow:(TableRowBuilderBlock)builderBlock{
    TableRowBuilderBlock _block = Block_copy(builderBlock);
    TableRowBuilder *builder = [TableRowBuilder genericBuilder];
    _block(builder);
    Block_release(_block);
    NSMutableArray *currentSection = (NSMutableArray *)[self.sections lastObject];
    [currentSection addObject:builder];
    return builder;
}

- (void)addRowWithBuilder:(TableRowBuilder *)builder
{
    if(![self.sections count]) return;
    [[self.sections lastObject] addObject:builder];
}

- (TableRowBuilder *)addRowWithCellBlock:(CellConfigurationBlock)_cellBlock
{
    TableRowBuilder *builder = [TableRowBuilder genericBuilder];
    [self.rowBuilders addObject:builder];
    self.cellBlock = _cellBlock;
    return builder;
}

- (void)bindToFetchedResultsController:(NSFetchedResultsController *)resultsController withCellBlock:(CellConfigurationBlock)_cellBlock{
    self.cellBlock = _cellBlock;
}

- (void)bindToFetchedResultsController:(NSFetchedResultsController *)resultsController withCellBuilderBlock:(CellBuilderBlock)builderBlock
{
    TableRowBuilder *builder = [TableRowBuilder genericBuilder];
    [self.rowBuilders addObject:builder];
    self.cellBuilderBlock = builderBlock;
}

- (void)buildRows{
    // Not Implemented
}

- (UITableViewCell *)configureGroupedCellAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.customCellNibName];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:KonstructorCellIdentifier] autorelease];
    }
    TableRowBuilder *builder = [[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = builder.title == nil ? [self labelForRow:builder] : builder.title;
    if(builder.formElement){
        if([builder.formElement isPicker]){
            // wait until the cell is tapped to show the pickers
            // add a date label
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            [cell addSubview:builder.dateLabel];
            builder.dateLabel.text = [self captionForRow:builder];
        }
        else{
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell addSubview:builder.formElement];
        }
    }
    else{
        cell.selectionStyle = (builder.selector && builder.obj) ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleGray;
    }
    if(builder.toggleBlock)
        [self addToggleForCell:cell builder:builder];
    if(builder.fontSize)
        cell.textLabel.font = [UIFont systemFontOfSize:builder.fontSize];
    return cell;
}

- (UITableViewCell *)configurePlainCellAtIndexPath:(NSIndexPath *)indexPath{    
    UITableViewCell *cell = [self dequeueCellForTableView:self.tableView];
    NSLog(@"Using custom nib: %@", self.customCellNibName);
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:self.customCellNibName owner:self options:NULL];
        cell = loadedCell;
    }
    NSAssert(cell != nil, @"Make sure you connect the table view cell to the loadedCell in you nib", nil);
    if(cellBlock){ // TODO: cellBlock should go away in favor of cellBuilderBlock
        if(_resultsController){
            NSManagedObject *obj = [_resultsController objectAtIndexPath:indexPath];
            cellBlock(obj, cell);
        }else{
            cellBlock(nil, cell);
        }
    }
    else if(cellBuilderBlock){
        NSManagedObject *obj = [_resultsController objectAtIndexPath:indexPath];
        cellBuilderBlock(obj, cell, [TableRowBuilder genericBuilder]);
    }
    else{
        TableRowBuilder *builder = [[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        if(bulkBlock){
            bulkBlock([builderObjects objectAtIndex:indexPath.row], builder);
        }
        
        else{
            UILabel *mainLabel = (UILabel *)[loadedCell viewWithTag:builder.titleTag];
            mainLabel.text = builder.title;
            
            UILabel *captionLabel = (UILabel *)[loadedCell viewWithTag:builder.captionTag];
            captionLabel.text = builder.caption;
            [captionLabel setHidden:builder.caption == nil];
            
            UIImageView *imageView = (UIImageView *)[loadedCell viewWithTag:builder.iconTag];
            if(builder.iconName){
                imageView.image = [UIImage imageNamed:builder.selected ? builder.selectedIconName : builder.iconName];
            }else if(builder.imagePath){
                imageView.image = [UIImage imageWithContentsOfFile:builder.imagePath];
            }
            
            [cell setSelected:[builder isSelected]];
            
            if(builder.accessoryType)
                cell.accessoryType = builder.accessoryType;
        }
        if(builder.configurationBlock){
            CellConfigurationCallback callback = (CellConfigurationCallback)builder.configurationBlock;
            callback(cell);
            Block_release(callback);
        }
    }
    
    return cell;
}

- (UITableViewCell *)dequeueCellForTableView:(UITableView *)_tableView
{
    return (UITableViewCell *)[_tableView dequeueReusableCellWithIdentifier:self.customCellNibName];
}

- (void)addToggleForCell:(UITableViewCell *)cell builder:(TableRowBuilder *)builder{
    UISwitch *sw = [[[UISwitch alloc] initWithFrame:CGRectMake(200.0f, 8.0f, 60.0f, 20.0f)] autorelease];
    [sw setOn:builder.selected];
    builder.formElement = sw;
    builder.toggleable = YES;
    [cell addSubview:sw];
}

- (void)rowTapped:(TableRowBuilder *)row{
    [NSException raise:@"Not Implemented." format:@"Overload in your subclass."];
}

- (NSString *)labelForRow:(TableRowBuilder *)row{
    return row.title;
}

- (NSString *)captionForRow:(TableRowBuilder *)row
{
    return [row description];
}

- (void)toggleRow:(TableRowBuilder *)row{
    UISwitch *_switch = (UISwitch *)row.formElement;
    [_switch setOn:!_switch.on animated:YES];
}

- (void)hideFormElements{
    for(UIView *view in self.elementsToHide){
        CGRect newFrame = self.view.frame;
        newFrame.origin.y = self.view.frame.size.height;
        newFrame.size.height = GlobalPickerHeight;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:KonstructorPickerWillHideNotification object:nil];
        [UIView animateWithDuration:0.4 
                         animations:^{
                             view.frame = newFrame;
                         }
                         completion:^(BOOL finished){
                             [view removeFromSuperview];
                             [self.elementsToHide removeObject:view];
                         }];
    }
}

- (void)showFormElementForRow:(TableRowBuilder *)row{
    for(NSMutableArray *section in self.sections){
        for(TableRowBuilder *builder in section){
            // hide all text fields
            [builder.formElement resignFirstResponder];
        }
    }
    UIView *view = row.formElement;
    if(![view isPicker]) return;
    
    CGRect initialFrame = self.view.frame;
    initialFrame.origin.y = self.view.frame.size.height;
    initialFrame.size.height = GlobalPickerHeight;
    
    CGRect endFrame = initialFrame;
    endFrame.origin.y -= GlobalPickerHeight;
        
    view.frame = initialFrame;
    [self.view addSubview:row.formElement];
    [self.elementsToHide addObject:row.formElement];
    [[NSNotificationCenter defaultCenter] postNotificationName:KonstructorPickerWillShowNotification object:nil];
    [UIView animateWithDuration:0.4 
                     animations:^{
                         view.frame = endFrame;
                     }];
}

- (NSFetchedResultsController *)resultsController{
    // overload this if you want to use an NSFetchedResultsController
    return nil;
}

- (void)reload{
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(!headerViews.count < section) return 0.0f;
    
    UIView *view = [headerViews objectAtIndex:section];
    return view.frame.size.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(headerViews.count < section) return nil;
    
    return [headerViews objectAtIndex:section];
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableCellHeight != 0.0f) return tableCellHeight;
    if(tableView.style == UITableViewStylePlain){
        return 60.0f;
    }else{
        return 45.0f;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = 0;
    if([self resultsController])
        count = [[[self resultsController] sections] count];
    else
        count = [self.sections count];
    
    NSLog(@"sections %d", count);
    return count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    if([self resultsController])
        count = [[[[self resultsController] sections] objectAtIndex:section] numberOfObjects];
    else
        count = [[self.sections objectAtIndex:section] count];
    
    
    NSLog(@"rows %d", count);
    return count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    if(_tableView.style == UITableViewStylePlain){
        return [self configurePlainCellAtIndexPath:indexPath];
    }else{
        return [self configureGroupedCellAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self hideFormElements];
    if(![sections count] && !tableDrillDownBlock){
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
        return;
    }
    else if(tableDrillDownBlock){
        id item = [[self resultsController] objectAtIndexPath:indexPath];
        tableDrillDownBlock(item);
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else if([[sections objectAtIndex:indexPath.section] count] > indexPath.row){
        TableRowBuilder *selectedRow = [[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        // any drillDownBlock takes priority
        if(selectedRow.drillDownBlock){
            [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
            selectedRow.drillDownBlock();
            return;
        }
        if(!selectedRow.toggleable)
            [_tableView deselectRowAtIndexPath:indexPath animated:YES];
        // fall back to other actions
        if(selectedRow.toggleable){
            selectedRow.on = ![selectedRow isOn];
            if(selectedRow.toggleBlock){
                selectedRow.toggleBlock();
            }else if(selectedRow.obj){
                [selectedRow.obj performSelector:selectedRow.selector withObject:[NSNumber numberWithBool:selectedRow.on]];
            }else{
                [self performSelector:selectedRow.selector];
            }
        }else{
            if(selectedRow.formElement){
                [self showFormElementForRow:selectedRow];
                [selectedRow.formElement becomeFirstResponder];
            }else if(selectedRow.selector){
                if(selectedRow.obj)
                    [selectedRow.obj performSelector:selectedRow.selector withObject:self];
                else
                    [self performSelector:selectedRow.selector withObject:[selectedRow retain]];
            }
        }
    }
    else{
        // Nothing to do
    }
}
  
#pragma Keyboard

- (void)keyboardDidShow:(id)sender{
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 180, 0);
}

- (void)keyboardDidHide:(id)sender{
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);    
}

# pragma mark - Private
- (void)setup{
    self.customCellNibName = KonstructorCellIdentifier;
    self.sections = [NSMutableArray array];
    self.rowBuilders = [NSMutableArray array];
    self.headerViews = [NSMutableArray array];
    self.elementsToHide = NICreateNonRetainingMutableArray();
}

@end
