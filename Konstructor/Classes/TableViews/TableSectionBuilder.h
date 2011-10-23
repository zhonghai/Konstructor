//
//  TableSectionBuilder.h
//  Konstructor
//
//  Created by Josh Stephenson on 8/16/11.
//  Copyright 2011 fr.ivolo.us. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableRowBuilder.h"

typedef void (^TableSectionBuilderBlock)(id item, TableRowBuilder *builder, UITableViewCell *cell);

@interface TableSectionBuilder : NSObject {
    NSMutableArray *rows;
    TableRowBuilder *defaultRow;
    NSMutableArray *builderObjects;
    UIView *view;
    
    NSString *cellNibName;
    CGFloat cellHeight;
    
    TableSectionBuilderBlock builderBlock;
}

/* Stores an array of the TableRowBuilder objects which configure rows */
@property (nonatomic, retain) NSMutableArray *rows;

/* Stores one TableRowBuilder to be used for all rows */
@property (nonatomic, retain) TableRowBuilder *defaultRow;

/* Stores a reference to the objects used to populate each row */
@property (nonatomic, retain) NSMutableArray *builderObjects;

/* The header view for this section */
@property (nonatomic, retain) UIView *view;

/* Used to configure each cell in the section */
@property (nonatomic, copy) TableSectionBuilderBlock builderBlock;

/* Custom Cell Nib Name */
@property (nonatomic, copy) NSString *cellNibName;

@property (nonatomic) CGFloat cellHeight;

+ (id)newSection;
- (void)addObject:(NSObject *)obj;

@end
