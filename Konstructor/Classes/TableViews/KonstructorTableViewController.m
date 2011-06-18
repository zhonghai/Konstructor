//
//  EasyTableViewController.m
//  Konstructor
//
//  Created by Joshua Stephenson on 5/8/11.
//  Copyright 2011 fr.ivolo.us All rights reserved.
//

#import "KonstructorTableViewController.h"
static NSString *KonstructorCellIdentifier = @"KonstructorTableViewCell";

@interface KonstructorTableViewController (PrivateMethods)

- (NSString *)labelForRow:(TableRowBuilder *)row;
- (UITableViewCell *)configureGroupedCellAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)configurePlainCellAtIndexPath:(NSIndexPath *)indexPath;
- (void)rowTapped:(TableRowBuilder *)row;
- (void)toggleRow:(TableRowBuilder *)row;
- (void)addToggleForCell:(UITableViewCell *)cell builder:(TableRowBuilder *)builder;

@end

@implementation KonstructorTableViewController
@synthesize rowBuilders;
@synthesize headerViews;
@synthesize tableView;
@synthesize tableCellHeight;
@synthesize builderObjects;
@synthesize bulkBlock;
@synthesize customCellNibName;

- (id)init{
    self = [super init];
    self.customCellNibName = KonstructorCellIdentifier;
    self.rowBuilders = [NSMutableArray array];
    self.headerViews = [NSMutableArray array];
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.customCellNibName = KonstructorCellIdentifier;
    self.rowBuilders = [NSMutableArray array];
    self.headerViews = [NSMutableArray array];
}

- (void)dealloc
{
    [tableView release];
    [rowBuilders release];
    [headerViews release];
    [bulkBlock release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [tableView release];
    tableView = nil;
    [rowBuilders release];
    rowBuilders = nil;
    [headerViews release];
    headerViews = nil;
    [bulkBlock release];
    bulkBlock = nil;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [tableView reloadData];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    rowBuilders = nil;
    tableView = nil;
    [super viewDidUnload];
}

# pragma mark EasyTableViewController

- (UIView *)addSectionHeader:(TableSectionHeaderBuilderBlock)builderBlock{
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
    TableRowBuilder *builder = [[TableRowBuilder alloc] init];
    _block(builder);
    Block_release(_block);
    [self.rowBuilders addObject:builder];
    return builder;
}

- (void)buildRows{
    // Not Implemented
}

- (UITableViewCell *)configureGroupedCellAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *KonstructorCellIdentifier = @"KonstructorCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KonstructorCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:KonstructorCellIdentifier] autorelease];
    }
    TableRowBuilder *builder = [rowBuilders objectAtIndex:indexPath.row];
    cell.textLabel.text = builder.title == nil ? [self labelForRow:builder] : builder.title;
    cell.selectionStyle = (builder.formElement || (builder.selector && builder.obj)) ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleGray;
    if(builder.formElement){
        [cell addSubview:builder.formElement];
    }
    if(builder.toggleBlock)
        [self addToggleForCell:cell builder:builder];
    if(builder.fontSize)
        cell.textLabel.font = [UIFont systemFontOfSize:builder.fontSize];
    return cell;
}

- (UITableViewCell *)configurePlainCellAtIndexPath:(NSIndexPath *)indexPath{    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:self.customCellNibName];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:self.customCellNibName owner:self options:NULL];
        cell = loadedCell;
    }
    
    TableRowBuilder *builder = [rowBuilders objectAtIndex:indexPath.row];
    if(builderObjects){
        id item = [builderObjects objectAtIndex:indexPath.row];
        NSLog(@"item %@", item);
        bulkBlock(item, builder);
    }
    if(builder.configurationBlock){
        CellConfigurationCallback callback = (CellConfigurationCallback)builder.configurationBlock;
        callback(cell);
        [cell release];
    }else{
        UILabel *mainLabel = (UILabel *)[loadedCell viewWithTag:builder.titleTag];
        mainLabel.text = builder.title;
        
        UILabel *captionLabel = (UILabel *)[loadedCell viewWithTag:builder.captionTag];
        captionLabel.text = builder.caption;
        [captionLabel setHidden:builder.caption == nil];
        
        UIImageView *imageView = (UIImageView *)[loadedCell viewWithTag:builder.iconTag];
        imageView.image = [UIImage imageNamed:builder.selected ? builder.selectedIconName : builder.iconName];
        
        [cell setSelected:[builder isSelected]];
        
        if(builder.accessoryType)
            cell.accessoryType = builder.accessoryType;
    }
    
    return cell;
}

- (void)addToggleForCell:(UITableViewCell *)cell builder:(TableRowBuilder *)builder{
    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(200.0f, 8.0f, 60.0f, 20.0f)];
    [sw setOn:builder.selected];
    builder.formElement = sw;
    builder.toggleable = YES;
    [cell addSubview:sw];
}

- (void)rowTapped:(TableRowBuilder *)row{
    [NSException raise:@"Not Implemented." format:@"Overload in your subclass."];
}

- (NSString *)labelForRow:(TableRowBuilder *)row{
    return [row description];
}

- (void)toggleRow:(TableRowBuilder *)row{
    UISwitch *_switch = (UISwitch *)row.formElement;
    [_switch setOn:!_switch.on animated:YES];
}

- (void)reload{
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(!headerViews.count) return 0.0f;
    
    UIView *view = [headerViews objectAtIndex:section];
    return view.frame.size.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(!headerViews.count) return nil;
    
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
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return rowBuilders.count;
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
    TableRowBuilder *selectedRow = [rowBuilders objectAtIndex:indexPath.row];
    if(selectedRow.drillDownController){
        UIViewController *viewController = [[(id)selectedRow.drillDownController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
        return;
    }
    if(!selectedRow.toggleable)
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
            [selectedRow.formElement becomeFirstResponder];
        }else if(selectedRow.selector){
            if(selectedRow.obj)
                [selectedRow.obj performSelector:selectedRow.selector withObject:self];
            else
                [self performSelector:selectedRow.selector withObject:[selectedRow retain]];
        }
    }
}
  

#pragma Keyboard

- (void)keyboardDidShow:(id)sender{
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 160, 0);
}

- (void)keyboardDidHide:(id)sender{
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);    
}

@end
