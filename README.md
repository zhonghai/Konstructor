Requirements
============

 * Requires iOS 4.0 or higher (for block syntax)

Installation
============

Drag these files into your project:

 * KonstructorTableViewController
 * TableRowBuilder
 * KonstructorTableViewCell.xib // Optional.  You can pass in your own nib if you wish

Usage
=====

1. Subclass KonstructorTableViewController

1. Configure subclass.  Either programatically or using a nib, make sure it has a table view with the delegate and data source wired up properly.

1. Customize your table height and cell nib.

`self.tableCellHeight = 100.0; // set the height for each cell`

`self.customCellNibName = @"YourNibName"; // will default to KonstructorTableViewCell`

1. Add Cells:

There are two ways to do this:

You can use an array to build your table against.  Here is a mock array to demonstrate this:
    
    /* Creating a mock array.  You will likely do this completely differently */
    NSDictionary *hat = [NSDictionary dictionaryWithObjectsAndKeys:@"Gloves", @"name", @"for your hands", @"caption", nil];
    NSDictionary *muffs = [NSDictionary dictionaryWithObjectsAndKeys:@"Muffs", @"name", @"for your ears", @"caption", nil];
    NSDictionary *shoes = [NSDictionary dictionaryWithObjectsAndKeys:@"Socks", @"name", @"for your feets", @"caption", nil];
    NSDictionary *scarves = [NSDictionary dictionaryWithObjectsAndKeys:@"Scarves", @"name", @"for your neck", @"caption", nil];
    NSArray *items = [[NSArray alloc] initWithObjects:hat, muffs, shoes, scarves, nil];

Any object works fine because you get the object back in the block.  Here is where Konstructor comes in.

Use addRowsFromArray:withBuilder: to build the whole table in one go:

    /* Build a Table from your array */
    [self addRowsFromArray:items withBuilder:^(id item, TableRowBuilder *builder){
        /* Cast your objects appropriately. */
        NSDictionary *current = (NSDictionary *)item;

        builder.title = [current objectForKey:@"title"];
        builder.caption = [current objectForKey:@"caption"];
        builder.iconName = @"comment_minus_48.png";
        builder.selectedIconName = @"comment_plus_48.png";
        builder.selector = @selector(toggle:);
    }];

This will give you a view that looks like this:

<img src="http://fr.ivolo.us/konstructor1.png" />

You can also add cells one by one.  This is ideal for settings or configuration views:

    - (void)viewDidLoad{
        self.tableCellHeight = 100.0;
        self.customCellNibName = @"YourNibName"; // will default to KonstructorTableViewCell

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
        // note that [super viewDidLoad] must be called after you add your rows
        // Otherwise use [tableView reloadData] to generate your rows
        [super viewDidLoad]; 
    }

If you need full control over the customization of the cell, use the configurationBlock property of TableRowBuilder:

    /* Build a Table from an Array and fully customize the cell */
    [self addRowsFromArray:items withBuilder:^(id item, TableRowBuilder *builder){
        NSDictionary *current = (NSDictionary *)item;
        
        /* Fully customize the cell */
        builder.configurationBlock = ^(UITableViewCell *cell){
            UILabel *titleLabel = (UILabel *)[loadedCell viewWithTag:1];
            titleLabel.text = [current objectForKey:@"name"];
            
            UILabel *captionLabel = (UILabel *)[loadedCell viewWithTag:builder.captionTag];
            captionLabel.text = [current objectForKey:@"caption"];
            
            UIImageView *imageView = (UIImageView *)[loadedCell viewWithTag:builder.iconTag];
            imageView.image = [UIImage imageNamed:builder.selected ? @"comment_plus_48.png" : @"comment_minus_48.png"];
        };
    }];

