# TODO

Make this better

# Installation

Drag these files into your project:
KonstructorTableViewController

# Configure
1. Subclass KonstructorTableViewController

2. Configure Your Xib.  It needs a TableView.  Hook it up to the tableView IBOutlet of your controller and wire up the UITableViewDelegate and UITableViewDataSource.

3. Add Cells:

Adding cells is easy using the block-taking instance method of KonstructorTableViewController:

- (void)viewDidLoad{
    self.tableCellHeight = 100.0;
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

