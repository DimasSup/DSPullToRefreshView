//
//  DSPullToRefreshView.h
//  DSPullToRefreshView
//
//  Created by DimasSup on 16.01.15.
//  Copyright (c) 2015 DimasSup. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DSPullToRefreshView;

#define UIViewAutoResizingMaskFill  UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin

@protocol DSPullToRefreshViewDelegate <NSObject>
/**
 Calling when pulling in progress but not finished
 */
-(void)pullingProcess:(DSPullToRefreshView*)view point:(CGPoint)point;
/**
Call when fully pull.
Execute your logic here. When done -  call [view finishPulling];
 */
-(void)pullingComplete:(DSPullToRefreshView*)view;


/**
 Background view for image
*/
-(UIView*)pullingBackgroundForProgressImage;

@end

@interface DSPullToRefreshView : UIView
@property(nonatomic,assign)IBOutlet id<DSPullToRefreshViewDelegate> delegate;
/**
 Hide pulling;
 */
-(void)finishPulling;
/**
 Hide pulling;
 */
-(void)finishPulling:(BOOL)animated;
/**
 Size of back pull view. Active pulling size for pull;
 */
@property(nonatomic)float pullViewSize;
@property(nonatomic)float offsetForPulling;
/**
 Images for show on pulling indicator
 */
@property(nonatomic,retain)NSArray* imagesForProcess;

@property(nonatomic,retain)UIImage* animatedImage;

/**
 original.x ,original.y -  center position of image indicator on pulling view in prcentage (0 - 1)
 */
@property(nonatomic)CGRect processImageFrame;


@property(nonatomic,copy)UIColor* pullingViewColor;
@end
