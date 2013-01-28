/*
 Copyright © 2013 Esri
 
 All rights reserved under the copyright laws of the United States
 and applicable international laws, treaties, and conventions.
 
 You may freely redistribute and use this sample code, with or
 without modification, provided you include the original copyright
 notice and use restrictions.
 
 See the use restrictions at http://help.arcgis.com/en/sdk/10.0/usageRestrictions.htm
 
 */

#import "MapLayerInfo+AppAdditions.h"
#import <ArcGIS/ArcGIS.h>


@implementation AGSWebMapLayerInfo (AppAdditions)

-(BOOL)isGroupLayer:(NSInteger)layerID inMapView:(AGSMapView *)mapView
{
    BOOL bIsGroupLayer = NO;
    AGSMapServiceInfo *msi = [self getMSI:mapView];
    if (msi)
    {
        NSArray *layerInfos = msi.layerInfos;
        if (layerInfos && [layerInfos count] > 0)
        {
            for (AGSMapServiceLayerInfo *msli in layerInfos) {
                //there is a layer who's parent layer is our layer,
                //so our layer is a parent layer
                if (msli.parentLayerID == layerID)
                {
                    bIsGroupLayer = YES;
                    break;
                }
            }
        }
    }
    else if (self.featureCollection)
    {
        NSArray *layerInfos = self.featureCollection.layers;
        bIsGroupLayer = (layerInfos && [layerInfos count] > 0);
    }
    
    return bIsGroupLayer;
}

-(BOOL)isGroupLayer:(AGSMapView *)mapView
{
    BOOL bIsGroupLayer = NO;
    AGSMapServiceInfo *msi = [self getMSI:mapView];
    if (msi)
    {
        NSArray *layerInfos = msi.layerInfos;
        bIsGroupLayer = (layerInfos && [layerInfos count] > 0);
    }
    else if (self.featureCollection)
    {
        NSArray *layerInfos = self.featureCollection.layers;
        bIsGroupLayer = (layerInfos && [layerInfos count] > 0);
    }
    
    return bIsGroupLayer;
}

-(BOOL)getSubLayerCount:(AGSMapView *)mapView
{
    NSInteger subLayerCount = 0;
    AGSMapServiceInfo *msi = [self getMSI:mapView];
    if (msi)
    {
        NSArray *layerInfos = msi.layerInfos;
        if (layerInfos)
        {
            subLayerCount = [layerInfos count];
        }        
    }
    else if (self.featureCollection)
    {
        subLayerCount = [self.featureCollection.layers count];
    }
    
    return subLayerCount;
}

-(AGSMapServiceInfo *)getMSI:(AGSMapView *)mapView
{    
    AGSLayer *layer = [mapView mapLayerForName:self.title];
    
    //if we can't find the layer, return nil
    if (!layer)
        return nil;
    
    AGSMapServiceInfo *msi = nil;
    
    //only AGSTiledMapServiceLayers or AGSDynamicMapServiceLayer have AGSMapServiceInfos
    if ([layer isKindOfClass:[AGSTiledMapServiceLayer class]])
    {
        //get the AGSMapServiceInfo for our layer
        msi = ((AGSTiledMapServiceLayer *)layer).mapServiceInfo;
    }
    else if ([layer isKindOfClass:[AGSDynamicMapServiceLayer class]])
    {
        //get the AGSMapServiceInfo for our layer
        msi = ((AGSDynamicMapServiceLayer *)layer).mapServiceInfo;
    }
    
    return msi;
}

-(BOOL)isDynamicMapService:(AGSMapView *)mapView
{
    //get the AGSLayerView for our layer    
    AGSLayer *layer = [mapView mapLayerForName:self.title];
    
    if (!layer)
        return NO;
        
    BOOL bIsDynamicMapService = [layer isKindOfClass:[AGSDynamicMapServiceLayer class]];
    
    return bIsDynamicMapService;
}

-(AGSDynamicMapServiceLayer *)getDynamicMapServiceLayer:(AGSMapView *)mapView
{    
    AGSLayer *layer = [mapView mapLayerForName:self.title];
    
    if (!layer)
        return nil;
    
    AGSDynamicMapServiceLayer *retValue = nil;
    if ([layer isKindOfClass:[AGSDynamicMapServiceLayer class]])
    {
        retValue = (AGSDynamicMapServiceLayer *)layer;
    }
    
    return retValue;
}

-(AGSTiledMapServiceLayer *)getTiledMapServiceLayer:(AGSMapView *)mapView
{    
    AGSLayer *layer = [mapView mapLayerForName:self.title];
    
    if (!layer)
        return nil;
        
    AGSTiledMapServiceLayer *retValue = nil;
    if ([layer isKindOfClass:[AGSTiledMapServiceLayer class]])
    {
        retValue = (AGSTiledMapServiceLayer *)layer;
    }
    
    return retValue;
}

@end
