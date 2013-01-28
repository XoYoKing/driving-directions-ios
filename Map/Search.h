/*
 Copyright © 2013 Esri
 
 All rights reserved under the copyright laws of the United States
 and applicable international laws, treaties, and conventions.
 
 You may freely redistribute and use this sample code, with or
 without modification, provided you include the original copyright
 notice and use restrictions.
 
 See the use restrictions at http://help.arcgis.com/en/sdk/10.0/usageRestrictions.htm
 
 */

#import <Foundation/Foundation.h>
#import "TableViewDrawable.h"

/*
 Represents a search the user made. Conforms to TableViewDrawable
 protocol so it can be presented nicely in a tableview with
 other searches and search results
 */

@interface Search : NSObject <TableViewDrawable, AGSCoding>
{
    NSString    *_name;
    UIImage     *_icon;
}

@property (nonatomic, copy) NSString    *name;
@property (nonatomic, strong) UIImage   *icon;

-(id)initWithName:(NSString *)name;

@end
