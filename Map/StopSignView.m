/*
 Copyright © 2013 Esri
 
 All rights reserved under the copyright laws of the United States
 and applicable international laws, treaties, and conventions.
 
 You may freely redistribute and use this sample code, with or
 without modification, provided you include the original copyright
 notice and use restrictions.
 
 See the use restrictions at http://help.arcgis.com/en/sdk/10.0/usageRestrictions.htm
 
 */

#import "StopSignView.h"
#import "Location.h"
#import "CurrentLocation.h"
#import "MapStates.h"

@interface StopSignView () 

@property (nonatomic, strong) UILabel  *nameLabel;
@property (nonatomic, strong) UIImageView *imageView;

-(void)locationUpdatedAddress:(NSNotification *)n;

@end

@implementation StopSignView


-(id)initWithFrame:(CGRect)frame withLocation:(Location *)location
{
    self = [super initWithFrame:frame 
            withReflectionSlope:1.7      //numbers looked nice for slope
                      startingX:65 
                      useShadow:YES
                       editable:![location isKindOfClass:[CurrentLocation class]]];
    
    if(self)
    {
        _location = location;
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(locationUpdatedAddress:) 
                                                     name:kLocationUpdatedAddress 
                                                   object:self.location];
        
        //Create UI elements
        CGRect contentRect = [self calculateContentRect:self.bounds];
        
        CGFloat imageInsetY = 15.0;
        CGFloat imageInsetX = 2.0;
        CGFloat imageHeight = contentRect.size.height - 2*imageInsetY;
        CGRect imageRect = CGRectMake(contentRect.origin.x + imageInsetX, contentRect.origin.y + imageInsetY, imageHeight, imageHeight);
        
        
        CGFloat streetNameOriginX = imageRect.origin.x + imageRect.size.width;
        CGFloat topBottomMargin = 8;
        CGRect nameRect = CGRectMake(streetNameOriginX, topBottomMargin, contentRect.size.width-streetNameOriginX, contentRect.size.height - topBottomMargin);
        
        UILabel *label = [[UILabel alloc] initWithFrame:nameRect];
        label.numberOfLines = 0;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont fontWithName:@"Arial-BoldMT" size:12.0]; 
        label.textAlignment = NSTextAlignmentCenter;
        self.nameLabel = label;
        
        UIImageView *iv = [[UIImageView alloc] initWithFrame:imageRect];;
        self.imageView = iv;
    }
    
    return self;
}

-(void)setLocation:(Location *)location
{
    if (location == _location)
        return;
	
    //if we are changing to/from a current location, whole sign needs to get redrawn
    if ([location isKindOfClass:[CurrentLocation class]] || [_location isKindOfClass:[CurrentLocation class]]) {
        [self setNeedsDisplay];
    }
    
    
    //remove observer and release it
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:kLocationUpdatedAddress 
                                                  object:self.location];
    
    //retain new location and add an observer onto address update
	_location = location;
    
    //if not set to nil, add new observer and redraw
    if (location) {
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(locationUpdatedAddress:) 
                                                     name:kLocationUpdatedAddress 
                                                   object:self.location];
        
        
        self.editable = ![location isKindOfClass:[CurrentLocation class]];
        
        [self setNeedsLayout];
    }
}

-(void)locationUpdatedAddress:(NSNotification *)n
{
    [self setNeedsLayout];
}

-(void)layoutSubviews
{
    if (self.nameLabel.superview == nil) {
        [self addSubview:self.nameLabel];
    }
    
    self.nameLabel.text = [self.location searchString];
    
    if(self.imageView.superview == nil)
    {
        [self addSubview:self.imageView];
    }
    
    self.imageView.image = self.location.icon;
}

@end
