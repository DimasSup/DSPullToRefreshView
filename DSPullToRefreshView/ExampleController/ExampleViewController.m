//
//  ExampleViewController.m
//  DSPullToRefreshView
//
//  Created by DimasSup on 16.01.15.
//  Copyright (c) 2015 DimasSup. All rights reserved.
//

#import "ExampleViewController.h"

@interface ExampleViewController ()
{
	NSMutableArray* _items;
}
@end

@implementation ExampleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	//Load example loading images. DO NOT USE IT IN YOUR PROJECT! COPYRIGHT
	NSArray* images= @[
					   [UIImage imageNamed:@"hpPullToRefresh0001"],
					   [UIImage imageNamed:@"hpPullToRefresh0002"],
					   [UIImage imageNamed:@"hpPullToRefresh0003"],
					   [UIImage imageNamed:@"hpPullToRefresh0004"],
					   [UIImage imageNamed:@"hpPullToRefresh0005"],
					   [UIImage imageNamed:@"hpPullToRefresh0006"],
					   [UIImage imageNamed:@"hpPullToRefresh0007"],
					   [UIImage imageNamed:@"hpPullToRefresh0008"],
					   [UIImage imageNamed:@"hpPullToRefresh0009"],
					   [UIImage imageNamed:@"hpPullToRefresh0010"],
					   [UIImage imageNamed:@"hpPullToRefresh0011"],
					   [UIImage imageNamed:@"hpPullToRefresh0012"],
					   ];
	//Settings pulling view;
	_pullToRefreshView.imagesForProcess = images;
	_pullToRefreshView.pullViewSize  = 60;
	_pullToRefreshView.offsetForPulling = 30;
	_pullToRefreshView.processImageFrame = CGRectMake(0.5, 0.5, 27, 27);
	
	
	
	//Prepare items for table view. You can drag table view in the xib for look how its work;
	_items = [[NSMutableArray alloc] init];
	for (int i = 0 ; i<100; i++)
	{
		[_items addObject:[NSString stringWithFormat:@"Format string %i",i]];
	}
    // Do any additional setup after loading the view from its nib.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return _items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	if(!cell)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
	}
	[[cell textLabel] setText:_items[indexPath.row]];
	return cell;
}
-(void)pullingProcess:(DSPullToRefreshView *)view point:(CGPoint)point
{
	if(point.y == 0)
	{
		_label.text = @"Normal";
	}
	else
	{
		_label.text = @"Pulling...";
	}
}
-(void)pullingComplete:(DSPullToRefreshView *)view
{
	[_items  removeAllObjects];
	[_tableView reloadData];
	_label.text = @"Loading";
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		for (int i = 0 ; i<100; i++)
		{
			[_items addObject:[NSString stringWithFormat:@"Format string %i",i]];
		}
		[_tableView reloadData];
		[_pullToRefreshView finishPulling];
		_label.text = @"Normal";
	});
}

-(void)dealloc
{
	[_items release];
	[super dealloc];
}
@end
