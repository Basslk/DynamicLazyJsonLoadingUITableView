//
//  ProductModel.h
//  CustomCellNibJsonLoading
//
//  Created by Ufuk ARSLAN on 9/21/12.
//  Copyright (c) 2012 Mobilistbilisim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductModel : NSObject

@property (nonatomic,assign) int ProductId;
@property (nonatomic,strong) NSString * ProductName;
@property (nonatomic,strong) NSString * ProductPictureURL;
@property (nonatomic,strong) UIImage * ProductImage;
@property (nonatomic,assign) BOOL IsFeatured;
@property (nonatomic,assign) BOOL IsNewProduct;
+(ProductModel*)CreateObject:(int) ofid AndName:(NSString* ) name AndUrl:(NSString*)url AndIsNEw:(BOOL)new AndIsIndirim:(BOOL) indirim;
@end
