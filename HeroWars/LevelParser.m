//
//  LevelParser.m
//  HeroWars
//
//  Created by Connor Levesque on 5/25/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "LevelParser.h"

@implementation LevelParser

-(id)init {
    self = [super init];
    if (self) {
        self.players = 2;
        self.tileGrid = [[NSMutableArray alloc]init];
        self.unitGrid = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)makeGridsFromLevelFile:(NSString *)levelFile {
    //parses levelFile into grids and relevant information for the gameBoard
    //reset properties
    self.width = 0;
    self.height = 0;
    [self.tileGrid removeAllObjects];
    [self.unitGrid removeAllObjects];
    //get and parse level components
    [self getLevelComponents:levelFile];
    self.levelName = self.levelComponents[0];   //levelComponents[0]
    [self getPlayerColors];     //levelComponents[2]
    [self buildGridsFromSquareStringGrid:[self getSquareStringGrid]];   //levelComponents[1]
    // handle win condition information here    //levelComponents[3]
}

-(void)getLevelComponents:(NSString *)levelFile {
    //uses levelFile to find the levelComponents of the corresponding level
    NSString *pathString = [NSString stringWithFormat:@"/%@", levelFile];
    NSString *path = [[NSBundle mainBundle] pathForResource:pathString ofType:@"txt"];
    NSString *levelString = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    levelString = [levelString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    levelString = [levelString stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.levelComponents = [levelString componentsSeparatedByString:@":"];
}

-(void)getPlayerColors {
    //sets player and playerColors properties
    NSString *colorString = self.levelComponents[2];
    self.playerColors = [colorString componentsSeparatedByString:@","];
    self.players = [self.playerColors count];
}

-(NSMutableArray *)getSquareStringGrid {
    //returns a grid a strings containing the information for each square, also sets the height and width
    NSString *mapString = self.levelComponents[1];
    NSMutableArray *mapRows = (NSMutableArray *)[mapString componentsSeparatedByString:@"/"];
    [self reverseArray:mapRows];
    self.height = [mapRows count];
    NSMutableArray *squareStringGrid = [[NSMutableArray alloc]init];
    for (NSString *rowString in mapRows) {
        NSArray *rowComponents = [rowString componentsSeparatedByString:@","];
        if (self.width == 0) {
            self.width = [rowComponents count];
        }
        [squareStringGrid addObject:rowComponents];
    }
    return squareStringGrid;
}

-(void)reverseArray:(NSMutableArray *)array {
    if ([array count] > 1) {
        int i = 0;
        int j = [array count] - 1;
        while (i < j) {
            [array exchangeObjectAtIndex:i withObjectAtIndex:j];
            i++;
            j--;
        }
    }
}

-(void)buildGridsFromSquareStringGrid:(NSArray *)squareStringGrid {
    //build tileGrid and unitGrid from the squareStringGrid
    //for each squareString in SquareStringGrid:
    for (int r = 0; r < self.height; r++) {
        NSMutableArray *tileRow = [[NSMutableArray alloc]init];
        NSMutableArray *unitRow = [[NSMutableArray alloc]init];
        for (int c = 0; c < self.width; c++) {
            NSString *squareString = squareStringGrid[r][c];
            NSArray *squareComponents = [squareString componentsSeparatedByString:@"-"];
            //build tile
            Tile *tile = [self buildTileWithComponents:squareComponents];
            tile.x = c + 1;
            tile.y = r + 1;
            [tileRow addObject:tile];
            //build unit
            Unit *unit = [self buildUnitWithComponents:squareComponents onTile:tile];
            [unitRow addObject:unit];
        }
        [self.tileGrid addObject:tileRow];
        [self.unitGrid addObject:unitRow];
    }

}

-(Tile *)buildTileWithComponents:(NSArray *)squareComponents {
    //separates
    switch ([squareComponents count]) {
        case 1:
            return [self processTileComponents:squareComponents[0] and:0];
        case 2:
            return [self processTileComponents:squareComponents[0] and:squareComponents[1]];
        case 3:
            return [self processTileComponents:squareComponents[0] and:0];
        case 4:
            return [self processTileComponents:squareComponents[0] and:squareComponents[1]];
        default:
            NSLog(@"Error: invalid number of square components");
            return nil;
            break;
    }
}

-(Tile *)processTileComponents:(NSString *)abbreviation and:(NSString *)ownerString {
    //returns tile indicated by components
    NSInteger owner = [ownerString integerValue];
    NSString *tileName = [self findTileNameFromAbbreviation:abbreviation];
    if ([tileName isEqualToString:@"town"] || [tileName isEqualToString:@"barracks"] || [tileName isEqualToString:@"castle"]) {
        return [[Tile alloc]initBuildingNamed:tileName withColors:self.playerColors withOwner:owner];
    } else {
        return [[Tile alloc]initTileNamed:tileName];
    }
}

-(NSString *)findTileNameFromAbbreviation:(NSString *)abbreviation {
    NSDictionary *tileAbbreviationGuide = [[NSDictionary alloc]initWithObjectsAndKeys:@"plains",@"p",@"forest",@"f",@"mountain",@"m",@"road",@"r",@"river",@"v",@"sea",@"s",@"town",@"t",@"barracks",@"b",@"castle",@"c", nil];
    NSString *tileType = [tileAbbreviationGuide objectForKey:abbreviation];
    return tileType;
}

-(Unit *)buildUnitWithComponents:(NSArray *)squareComponents onTile:(Tile *)tile {
    switch ([squareComponents count]) {
        case 3:
            return [self processUnitComponents:squareComponents[1] and:squareComponents[2] onTile:(Tile *)tile];
        case 4:
            return [self processUnitComponents:squareComponents[2] and:squareComponents[3] onTile:(Tile *)tile];
        default:
            return (Unit *)[NSNull null];
    }
}

-(Unit *)processUnitComponents:(NSString *)abbreviation and:(NSNumber *)ownerNumber onTile:(Tile *)tile {
    //returns unit indicated by components
    NSInteger owner = [ownerNumber integerValue];
    NSString *unitName = [self findUnitNameFromAbbreviation:abbreviation];
    return [[Unit alloc]initUnitNamed:unitName onTile:tile withColors:self.playerColors withOwner:owner];
}

-(NSString *)findUnitNameFromAbbreviation:(NSString *)abbreviation {
    NSDictionary *unitAbbreviationGuide = [[NSDictionary alloc]initWithObjectsAndKeys:@"footman",@"F",@"archer",@"A",@"axeman",@"X",@"phalanx",@"P",@"scout",@"S",@"knight",@"K",@"greatknight",@"G",@"catapult",@"C",@"megapult",@"M",@"Ballista",@"B", nil];
    NSString *unitName = [unitAbbreviationGuide objectForKey:abbreviation];
    return unitName;
}


@end
