Installation
============

Drag these files into your project:

 * KonstructorTableViewController
 * TableRowBuilder
 * KonstructorTableViewCell.xib // Optional.  You can pass in your own nib if you wish

Configuration
============

1. Subclass KonstructorTableViewController

1. Configure subclass.  Either programatically or using a nib, make sure it has a table view with the delegate and data source wired up properly.

1. Customize your table height and cell nib.

    self.tableCellHeight = 100.0; // set the height for each cell
    self.customCellNibName = @"YourNibName"; // will default to KonstructorTableViewCell

1. Add Cells:

#### There are two ways to do this

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

