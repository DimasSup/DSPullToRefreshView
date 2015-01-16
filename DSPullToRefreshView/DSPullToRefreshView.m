//
//  DSPullToRefreshView.m
//  DSPullToRefreshView
//
//  Created by DimasSup on 16.01.15.
//  Copyright (c) 2015 DimasSup. All rights reserved.
//

#import "DSPullToRefreshView.h"

@interface DSPullToRefreshView()
{
	UIView* _pullContentView;
	UIScrollView* _scrollView;
	UIImageView* _imagesForProcessView;
	UIImage* _animateImage;
	BOOL _waitingFinish;
	UIView* _backgroundImg;
}
@end

@implementation DSPullToRefreshView
@synthesize animatedImage = _animateImage;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
				[self createViews];
        // Initialization code
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
	{
		[self createViews];
        
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
		
		[self createViews];
    }
    return self;
}

-(void)createViews
{
	_pullViewSize = 60;
	_offsetForPulling = 0;
	_processImageFrame = CGRectMake(0.5f, 0.5f, 27, 27);
	
	NSArray* subViews = [self.subviews copy];
	[self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
	_pullContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 0)];
	_pullContentView.backgroundColor = [UIColor colorWithRed:0.294 green:0.569 blue:0.804 alpha:1.000];
	_pullContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
	[self addSubview:_pullContentView];
	
	_imagesForProcessView = [[UIImageView alloc] init];
	[_pullContentView addSubview:_imagesForProcessView];
	
	
	_scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
	_scrollView.contentSize = _scrollView.bounds.size;
	_scrollView.alwaysBounceVertical = YES;
	_scrollView.backgroundColor = [UIColor clearColor];
	for (UIView* view in subViews)
	{
		[_scrollView addSubview:view];
	}
	[self addSubview:_scrollView];
	[subViews release];
	[_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
	
	[self updateProcessImageView];
}
-(void)setBackgroundColor:(UIColor *)backgroundColor
{
	[super setBackgroundColor:backgroundColor];
	
}
-(void)updateProcessImageView
{
	CGRect rect = CGRectMake(_pullContentView.bounds.origin.x+_pullContentView.frame.size.width*self.processImageFrame.origin.x - _processImageFrame.size.width/2, _pullContentView.bounds.origin.y+_pullViewSize*self.processImageFrame.origin.y - _processImageFrame.size.height/2, _processImageFrame.size.width, _processImageFrame.size.height);
	_imagesForProcessView.frame = rect;
	if(self.delegate && [self.delegate respondsToSelector:@selector(pullingBackgroundForProgressImage)])
	{
		UIView* background = [self.delegate pullingBackgroundForProgressImage];
		if(background!=_backgroundImg)
		{
			[_backgroundImg removeFromSuperview];
			[_backgroundImg release];
			_backgroundImg = [background retain];
			[_pullContentView addSubview:_backgroundImg];
			[_pullContentView sendSubviewToBack:_backgroundImg];
		}
		
		
	}
	if(_backgroundImg)
	{
		CGRect bRect = _backgroundImg.frame;
		bRect.origin.x = rect.origin.x+rect.size.width/2 - bRect.size.width/2;
		bRect.origin.y = rect.origin.y+rect.size.height/2 - bRect.size.height/2;
		_backgroundImg.frame = bRect;
	}
}

-(void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	[self updateProcessImageView];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if([keyPath isEqualToString:@"contentOffset"])
	{
		CGPoint point = [change[@"new"] CGPointValue];
		CGRect r = _pullContentView.frame;
		r.size.height = MAX(0, -point.y);
		_pullContentView.frame = r;
		[self updateImageForOffset:point];
		NSLog(@"%@",change);
	}
}

-(void)setProcessImageFrame:(CGRect)processImageFrame
{
	_processImageFrame = processImageFrame;
	[self updateProcessImageView];
}

-(void)setImagesForProcess:(NSArray *)imagesForProcess
{
	if(_imagesForProcess!=imagesForProcess)
	{
		[_imagesForProcess release];
		_imagesForProcess = [imagesForProcess copy];
	}
	
	[_animateImage release];
	_animateImage = nil;
	if(_imagesForProcess.count>1)
	{
		_animateImage = [[UIImage animatedImageWithImages:_imagesForProcess duration:1] retain];
	}
	else
	{
		_animateImage = [[_imagesForProcess firstObject] retain];
	}
	
}
-(void)updateImageForOffset:(CGPoint)point
{
	if(self.imagesForProcess.count)
	{
		if(_waitingFinish)
			return;
		float procentage =MIN(MAX(0, (-point.y - _offsetForPulling)/(self.pullViewSize - _offsetForPulling)),1);
		int index = (self.imagesForProcess.count-1)*procentage;
		
		_imagesForProcessView.image = self.imagesForProcess[index];
		if(index == self.imagesForProcess.count - 1)
		{
			if(self.delegate && [self.delegate respondsToSelector:@selector(pullingComplete:)])
			{
				_waitingFinish = YES;
				[UIView animateWithDuration:0.3 animations:^{
					_scrollView.contentInset = UIEdgeInsetsMake(_pullViewSize, 0, 0, 0);
				}];
				_imagesForProcessView.image = _animateImage;
				_scrollView.scrollEnabled = NO;
				[self.delegate pullingComplete:self];
				
			}
		}
		else
		{
			if(self.delegate && [self.delegate respondsToSelector:@selector(pullingProcess:point:)])
			{
				[self.delegate pullingProcess:self point:point];
			}
		}
	}
	
}

-(void)setAnimatedImage:(UIImage *)animatedImage
{
	if(_animateImage!=animatedImage)
	{
		[_animateImage release];
		_animateImage = [animatedImage retain];
	}
	if(_waitingFinish)
	{
		_imagesForProcessView.image = _animateImage;
	}
	
}
-(void)finishPulling
{
	[self finishPulling:YES];
}
-(void)finishPulling:(BOOL)animated
{
	_waitingFinish = NO;
	_scrollView.scrollEnabled = YES;
	if(animated)
	{
		[UIView animateWithDuration:0.3 animations:^{
			_scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
		}];
	}
	else
	{
		_scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
	}
}

-(void)setPullingViewColor:(UIColor *)pullingViewColor
{
	if(_pullingViewColor!=pullingViewColor)
	{
		[_pullingViewColor release];
		_pullingViewColor = [pullingViewColor copy];
	}
	_pullContentView.backgroundColor = _pullingViewColor;
}

-(void)dealloc
{
	[_scrollView release];
	[_imagesForProcess release];
	[_imagesForProcessView release];
	[_animateImage release];
	[_pullContentView release];
	[_backgroundImg release];
	[_pullingViewColor release];
	[super dealloc];
}
@end
