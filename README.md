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

1. Add Cells:

#### There are two ways to do this

Build from an array:

    self.tableCellHeight = 100.0;
    self.customCellNibName = @"YourNibName"; // will default to KonstructorTableViewCell

    /* Creating a mock array.  You will likely do this completely differently */
    NSDictionary *hat = [NSDictionary dictionaryWithObjectsAndKeys:@"Gloves", @"name", @"for your hands", @"caption", nil];
    NSDictionary *muffs = [NSDictionary dictionaryWithObjectsAndKeys:@"Muffs", @"name", @"for your ears", @"caption", nil];
    NSDictionary *shoes = [NSDictionary dictionaryWithObjectsAndKeys:@"Socks", @"name", @"for your feets", @"caption", nil];
    NSDictionary *scarves = [NSDictionary dictionaryWithObjectsAndKeys:@"Scarves", @"name", @"for your neck", @"caption", nil];
    NSArray *items = [[NSArray alloc] initWithObjects:hat, muffs, shoes, scarves, nil];
    
    /* Build a Table from an Array */
    [self addRowsFromArray:items withBuilder:^(id item, TableRowBuilder *builder){
        NSDictionary *current = (NSDictionary *)item;
        builder.title = [current objectForKey:@"title"];
        builder.caption = [current objectForKey:@"caption"];
        builder.iconName = @"comment_minus_48.png";
        builder.selectedIconName = @"comment_plus_48.png";
        builder.selector = @selector(toggle:);
    }];


You can add cells one by one.  This is ideal for settings or configuration views.

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

------------------
