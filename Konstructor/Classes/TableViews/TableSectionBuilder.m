//
//  TableSectionBuilder.m
//  Konstructor
//
//  Created by Josh Stephenson on 8/16/11.
//  Copyright 2011 fr.ivolo.us. All rights reserved.
//

#import "TableSectionBuilder.h"

@interface TableSectionBuilder (Private)
- (void)cleanup;
@end

@implementation TableSectionBuilder

@synthesize rows;
@synthesize defaultRow;
@synthesize builderObjects;
@synthesize view;
@synthesize builderBlock;
@synthesize cellNibName;
@synthesize cellHeight;

- (void)dealloc{
    [super dealloc];
    [self cleanup];
}

- (void)cleanup
{
    [rows release];
    rows = nil;
    [defaultRow release];
    defaultRow = nil;
    [builderObjects release];
    builderObjects = nil;
    [view release];
    view = nil;
    [builderBlock release];
    builderBlock = nil;
    [cellNibName release];
    cellNibName = nil;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+ (id)newSection
{
    TableSectionBuilder *section = [[[TableSectionBuilder alloc] init] autorelease];
    section.cellHeight = 0.0f;
    section.rows = [[NSMutableArray alloc] init];
    section.builderObjects = [[NSMutableArray alloc] init];
    return section;
}

@end
