//
//  ProductModel.m
//  CustomCellNibJsonLoading
//
//  Created by Ufuk ARSLAN on 9/21/12.
//  Copyright (c) 2012 Mobilistbilisim. All rights reserved.
//

#import "ProductModel.h"

@implementation ProductModel

@synthesize ProductId,ProductName,IsFeatured,IsNewProduct,ProductPictureURL;

-(id)init
{
    if(self=[super init])
    {
        
    }
    return self;
}

+(ProductModel*)CreateObject:(int) ofid AndName:(NSString* ) name AndUrl:(NSString*)url AndIsNEw:(BOOL)new AndIsIndirim:(BOOL) indirim
{
    ProductModel* result=[[ProductModel alloc]init];
    result.ProductName=name;
    result.ProductId=ofid;
    result.ProductPictureURL=url;
    result.IsFeatured=indirim;
    result.IsNewProduct=new;
    return result;
}


@end
