//
//  EasyTableViewController.m
//  Konstructor
//
//  Created by Joshua Stephenson on 5/8/11.
//  Copyright 2011 fr.ivolo.us All rights reserved.
//

#import "KonstructorTableViewController.h"
#import "UIView+Konstructor.h"

@interface KonstructorTableViewController (PrivateMethods)

- (NSString *)labelForRow:(TableRowBuilder *)row;
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
@synthesize tableView;
@synthesize resultsController;
@synthesize bulkBlock;
@synthesize cellBlock;
@synthesize tableDrillDownBlock;
@synthesize cellBuilderBlock;
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
    if(self.tableView == nil){
        NSLog(@"no tableview found.  Creating a Plain tableview now");
        CGRect frame = self.view.frame;
        frame.origin = CGPointMake(0.0, 0.0);
        self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.view addSubview:self.tableView];
        [self.tableView release];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [tableView reloadData];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    
    [tableView release];
    tableView = nil;
    [sections release];
    sections = nil;
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

# pragma mark KonstructorTableViewController

- (UIView *)addSectionHeaderWithNibName:(NSString *)nibName andBlock:(TableSectionHeaderBlock)sectionBlock{
    TableSectionBuilder *section = [TableSectionBuilder newSection];
    section.cellNibName = nibName;
    [self.sections addObject:section];
    section.view = [[UIView alloc] init];
    section.view.backgroundColor = [UIColor clearColor];
    sectionBlock(section.view);
    return section.view;
}

- (void)addRowsFromArray:(NSArray *)objects withBuilder:(TableSectionBuilderBlock)builderBlock{
    TableSectionBuilder *section = [self.sections lastObject];
    section.builderBlock = builderBlock;
    for(int i = 0; i < objects.count; i++){
        [section.builderObjects addObject:[objects objectAtIndex:i]];
        [section.rows addObject:[TableRowBuilder newRowWithDelegate:self]];
    }
}

- (TableRowBuilder *)addRow:(TableRowBuilderBlock)builderBlock{
    TableRowBuilderBlock _block = Block_copy(builderBlock);
    TableRowBuilder *row = [TableRowBuilder newRowWithDelegate:self];
    _block(row);
    Block_release(_block);
    TableSectionBuilder *section = [self.sections lastObject];
    [section.rows addObject:row];
    return row;
}

- (void)addRowWithBuilder:(TableRowBuilder *)builder
{
    if(![self.sections count]) return;
    [[self currentSection].rows addObject:builder];
}

- (TableRowBuilder *)addRowWithCellBlock:(CellConfigurationBlock)_cellBlock
{
//    TableSectionBuilder *section = [self.sections lastObject];
//    TableRowBuilder *builder = [TableRowBuilder genericBuilder];
//    [section.rows addObject:builder];
//    section.cellBlock = _cellBlock;
//    return builder;
    return nil;
}

- (void)bindToFetchedResultsController:(NSFetchedResultsController *)controller withNibName:(NSString *)nibName andCellBlock:(CellConfigurationBlock)_cellBlock
{
    self.cellBlock = _cellBlock;
    for(int i = 0; i < [controller sections].count ; i++){
        TableSectionBuilder *section = [TableSectionBuilder newSection];
        section.cellNibName = nibName;
        section.defaultRow = [TableRowBuilder newRowWithDelegate:self];
        [self.sections addObject:section];
    }
}

- (void)bindToFetchedResultsController:(NSFetchedResultsController *)controller withNibName:(NSString *)nibName andCellBuilderBlock:(CellBuilderBlock)builderBlock
{
    MRLog(@"sections %d", [controller sections].count);
    for(int i = 0; i < [controller sections].count ; i++){
        TableSectionBuilder *section = [TableSectionBuilder newSection];
        section.cellNibName = nibName;
        [self.sections addObject:section];
    }
    MRLog(@"sections %@", self.sections);
    self.cellBuilderBlock = builderBlock;
}

# pragma mark - Utility methods
- (void)setCellHeight:(CGFloat)height
{
    TableSectionBuilder *section = [self.sections lastObject];
    section.cellHeight = height;
}

- (void)buildRows{
    // Not Implemented.  Convenience method for subclasses
}

- (TableSectionBuilder *)firstSection
{
    return self.sections.count > 0 ? [self.sections objectAtIndex:0] : nil;
}

- (TableSectionBuilder *)currentSection
{
    return self.sections.count > 0 ? [self.sections lastObject] : nil;
}

# pragma mark - Cell Configuration
- (UITableViewCell *)configureGroupedCellAtIndexPath:(NSIndexPath *)indexPath{
    TableSectionBuilder *section = [self.sections objectAtIndex:indexPath.section];
    TableRowBuilder *row = [section.rows objectAtIndex:indexPath.row];
    UITableViewCell *cell = (UITableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:section.cellNibName];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:KonstructorCellIdentifier] autorelease];
    }
    cell.textLabel.text = row.title == nil ? [self labelForRow:row] : row.title;
    if(row.formElement){
        if([row.formElement isPicker]){
            // wait until the cell is tapped to show the pickers
            // add a date label
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            [cell addSubview:row.dateLabel];
            row.dateLabel.text = [self captionForRow:row];
        }
        else{
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell addSubview:row.formElement];
        }
    }
    else{
        cell.selectionStyle = (row.selector && row.obj) ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleGray;
    }
    if(row.toggleBlock)
        [self addToggleForCell:cell builder:row];
    if(row.fontSize)
        cell.textLabel.font = [UIFont systemFontOfSize:row.fontSize];
    return cell;
}

- (UITableViewCell *)configurePlainCellAtIndexPath:(NSIndexPath *)indexPath{
    TableSectionBuilder *section = [self.sections objectAtIndex:indexPath.section];
    TableRowBuilder *row;
    if(section.rows.count < 1){
        row = section.defaultRow;
    }
    else{
        row = [section.rows objectAtIndex:indexPath.row];    
    }
    UITableViewCell *cell = (UITableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:section.cellNibName];
    NSLog(@"Using custom nib: %@", section.cellNibName);
    NSAssert(section.cellNibName != nil, @"You must set a cellNibName on every section");
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:section.cellNibName owner:self options:NULL];
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
        cellBuilderBlock(obj, cell, [TableRowBuilder newRowWithDelegate:self]);
    }
    else{
        if(section.builderBlock){
            section.builderBlock([section.builderObjects objectAtIndex:indexPath.row], row);
        }
        
        else{
            UILabel *mainLabel = (UILabel *)[loadedCell viewWithTag:row.titleTag];
            mainLabel.text = row.title;
            
            UILabel *captionLabel = (UILabel *)[loadedCell viewWithTag:row.captionTag];
            captionLabel.text = row.caption;
            [captionLabel setHidden:row.caption == nil];
            
            UIImageView *imageView = (UIImageView *)[loadedCell viewWithTag:row.iconTag];
            if(row.iconName){
                imageView.image = [UIImage imageNamed:row.selected ? row.selectedIconName : row.iconName];
            }else if(row.imagePath){
                imageView.image = [UIImage imageWithContentsOfFile:row.imagePath];
            }
            
            [cell setSelected:[row isSelected]];
            
            if(row.accessoryType)
                cell.accessoryType = row.accessoryType;
        }
        if(row.configurationBlock){
            CellConfigurationCallback callback = (CellConfigurationCallback)row.configurationBlock;
            callback(cell);
        }
    }
    
    return cell;
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
    for(TableSectionBuilder *section in self.sections){
        for(TableRowBuilder *row in section.rows){
            // hide all text fields
            [row.formElement resignFirstResponder];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex{
    if(sections.count <= sectionIndex) return 0.0f;
    
    TableSectionBuilder *section = [self.sections objectAtIndex:sectionIndex];
    
    return section.view.frame.size.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex{
    if(sections.count <= sectionIndex) return nil;
    TableSectionBuilder *section = [self.sections objectAtIndex:sectionIndex];
    
    return section.view;
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableSectionBuilder *section = [self.sections objectAtIndex:indexPath.section];
    if(section.cellHeight > 0.0f) return section.cellHeight;
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
    return count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    NSInteger count = 0;
    if([self resultsController])
        count = [[[[self resultsController] sections] objectAtIndex:sectionIndex] numberOfObjects];
    else{
        if(self.sections.count < 1) return 0;
        TableSectionBuilder *section = [self.sections objectAtIndex:sectionIndex];
        count = [section.rows count];
    }
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
    TableSectionBuilder *section = [self.sections objectAtIndex:indexPath.section];
    TableRowBuilder *row;
    if(section.rows.count < 1){
        row = section.defaultRow;
    }
    else{
        row = [section.rows objectAtIndex:indexPath.row];    
    }
    
    if(![sections count] && !tableDrillDownBlock){
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
        return;
    }
    else if(tableDrillDownBlock){
        id item = [[self resultsController] objectAtIndexPath:indexPath];
        tableDrillDownBlock(item);
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else if(section && row){
        // any drillDownBlock takes priority
        if(row.drillDownBlock){
            [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
            row.drillDownBlock();
            return;
        }
        if(!row.toggleable)
            [_tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        // fall back to other actions
        if(row.toggleable){
            row.on = ![row isOn];
            if(row.toggleBlock){
                row.toggleBlock();
            }else if(row.obj){
                [row.obj performSelector:row.selector withObject:[NSNumber numberWithBool:row.on]];
            }else{
                [self performSelector:row.selector];
            }
        }else{
            if(row.formElement){
                [self showFormElementForRow:row];
                [row.formElement becomeFirstResponder];
            }else if(row.selector){
                if(row.obj)
                    [row.obj performSelector:row.selector withObject:self];
                else
                    [self performSelector:row.selector withObject:[row retain]];
            }
        }
    }
    else{
        // Nothing to do
    }
}

# pragma mark - TableRowBuilderDelegate
- (void)tableRowBuilder:(TableRowBuilder *)builder formElementDidBecomeActive:(UIResponder *)element
{
    LOGMETHOD();
    currentFormElement = element;
}

# pragma mark - Keyboard

- (void)dismissKeyboard
{
    [currentFormElement resignFirstResponder];
}

- (void)keyboardDidShow:(id)sender{
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 240, 0);
}

- (void)keyboardDidHide:(id)sender{
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);    
}

# pragma mark - Private
- (void)setup{
    self.sections = [NSMutableArray array];
    self.elementsToHide = NICreateNonRetainingMutableArray();
}

@end
