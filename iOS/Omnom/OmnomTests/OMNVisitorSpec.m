//
//  OMNVisitorSpec.m
//  omnom
//
//  Created by tea on 03.04.15.
//  Copyright 2015 tea. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "OMNVisitor.h"
#import "NSString+omn_json.h"
#import "OMNRestaurant+omn_network.h"
#import "OMNVisitorFactory.h"

#import "OMNBarVisitor.h"
#import "OMNBarRestaurantMediator.h"
#import "OMNBarWishMediator.h"

#import "OMNPreorderVisitor.h"
#import "OMNPreorderRestaurantMediator.h"
#import "OMNPreorderWishMediator.h"

#import "OMNLunchVisitor.h"
#import "OMNLunchRestaurantMediator.h"
#import "OMNLunchWishMediator.h"

#import "OMNDemoVisitor.h"
#import "OMNDemoRestaurantMediator.h"

#import "OMNRestaurantInVisitor.h"
#import "OMNRestaurantInMediator.h"
#import "OMNRestaurantInWishMediator.h"

SPEC_BEGIN(OMNVisitorSpec)

describe(@"OMNVisitor", ^{

  __block OMNRestaurant *_restaurant = nil;
  __block OMNVisitor *_visitor = nil;
  __block OMNRestaurantMediator *_restaurantMediator = nil;
  
  beforeAll(^{
  
    id response = [@"decodeBeacons.json" omn_jsonObjectNamedForClass:self.class];
    NSArray *restaurants = [response[@"restaurants"] omn_restaurants];
    _restaurant = [restaurants firstObject];
    _visitor = [OMNVisitor visitorWithRestaurant:_restaurant delivery:[OMNDelivery delivery]];
    _restaurantMediator = [_visitor mediatorWithRootVC:nil];
    
  });
  
  it(@"should check initial condition", ^{
    
    [[_restaurant should] beNonNil];
    [[_visitor should] beNonNil];
    [[_restaurantMediator should] beNonNil];
    [[_restaurantMediator should] beKindOfClass:[OMNRestaurantMediator class]];
    
  });
  
  it(@"should check bar visitor", ^{
    
    OMNVisitor *barVisitor = [OMNBarVisitor visitorWithRestaurant:_restaurant delivery:[OMNDelivery delivery]];
    OMNRestaurantMediator *barRestaurantMediator = [barVisitor mediatorWithRootVC:nil];
    [[barRestaurantMediator should] beKindOfClass:[OMNBarRestaurantMediator class]];
    
    [[@(barRestaurantMediator.showTableButton) should] equal:@(NO)];
    [[@(barRestaurantMediator.showPreorderButton) should] equal:@(YES)];
    [[barRestaurantMediator.titleView should] beNonNil];
    
    OMNWishMediator *barWishMediator = [barRestaurantMediator wishMediatorWithRootVC:nil];
    [[barWishMediator should] beKindOfClass:[OMNBarWishMediator class]];
    [[barWishMediator.restaurantMediator should] equal:barRestaurantMediator];

    [[barWishMediator.refreshOrdersTitle should] equal:kOMN_WISH_RECOMMENDATIONS_LABEL_TEXT];
    
    if (_restaurant.orders_paid_url) {
      [[barWishMediator.bottomButton should] beNonNil];
    }
    else {
      [[barWishMediator.bottomButton should] beNil];
    }

  });
  
  it(@"should check preorder visitor", ^{
    
    OMNVisitor *preorderVisitor = [OMNPreorderVisitor visitorWithRestaurant:_restaurant delivery:[OMNDelivery deliveryWithMinutes:0]];
    OMNRestaurantMediator *preorderRestaurantMediator = [preorderVisitor mediatorWithRootVC:nil];
    [[preorderRestaurantMediator should] beKindOfClass:[OMNPreorderRestaurantMediator class]];
    
    [[@(preorderRestaurantMediator.showTableButton) should] equal:@(NO)];
    [[@(preorderRestaurantMediator.showPreorderButton) should] equal:@(YES)];
    [[preorderRestaurantMediator.titleView should] beNonNil];
    
    OMNWishMediator *preorderWishMediator = [preorderRestaurantMediator wishMediatorWithRootVC:nil];
    [[preorderWishMediator should] beKindOfClass:[OMNPreorderWishMediator class]];
    [[preorderWishMediator.restaurantMediator should] equal:preorderRestaurantMediator];
    
    [[preorderWishMediator.refreshOrdersTitle should] equal:kOMN_WISH_RECOMMENDATIONS_LABEL_TEXT];
    [[preorderWishMediator.bottomButton should] beNil];
    
  });
  
  it(@"should check lunch visitor", ^{
    
    OMNVisitor *lunchVisitor = [OMNLunchVisitor visitorWithRestaurant:_restaurant delivery:[OMNDelivery deliveryWithAddress:nil date:nil]];
    OMNRestaurantMediator *lunchRestaurantMediator = [lunchVisitor mediatorWithRootVC:nil];
    [[lunchRestaurantMediator should] beKindOfClass:[OMNLunchRestaurantMediator class]];
    
    [[@(lunchRestaurantMediator.showTableButton) should] equal:@(NO)];
    [[@(lunchRestaurantMediator.showPreorderButton) should] equal:@(YES)];
    [[lunchRestaurantMediator.titleView should] beNil];
    
    OMNWishMediator *lunchWishMediator = [lunchRestaurantMediator wishMediatorWithRootVC:nil];
    [[lunchWishMediator should] beKindOfClass:[OMNPaidWishMediator class]];
    [[lunchWishMediator.restaurantMediator should] equal:lunchRestaurantMediator];
    
    [[lunchWishMediator.refreshOrdersTitle should] equal:kOMN_WISH_RECOMMENDATIONS_LABEL_TEXT];
    [[lunchWishMediator.bottomButton should] beNil];
    
  });
  
  it(@"should check demo visitor", ^{
    
    OMNVisitor *demoVisitor = [OMNDemoVisitor visitorWithRestaurant:_restaurant delivery:[OMNDelivery deliveryWithAddress:nil date:nil]];
    OMNRestaurantMediator *demoRestaurantMediator = [demoVisitor mediatorWithRootVC:nil];
    [[demoRestaurantMediator should] beKindOfClass:[OMNDemoRestaurantMediator class]];
    
    [[@(demoRestaurantMediator.showTableButton) should] equal:@(NO)];
    [[@(demoRestaurantMediator.showPreorderButton) should] equal:@(NO)];
    [[demoRestaurantMediator.titleView should] beNil];
    
  });
  
  
  it(@"should check restaurant in visitor", ^{
    
    OMNVisitor *restaurantInVisitor = [OMNRestaurantInVisitor visitorWithRestaurant:_restaurant delivery:[OMNDelivery delivery]];
    OMNRestaurantMediator *restaurantInVisitorMediator = [restaurantInVisitor mediatorWithRootVC:nil];
    [[restaurantInVisitorMediator should] beKindOfClass:[OMNRestaurantInMediator class]];
    
    [[@(restaurantInVisitorMediator.showTableButton) should] equal:@(NO)];
    [[@(restaurantInVisitorMediator.showPreorderButton) should] equal:@(YES)];
    [[restaurantInVisitorMediator.titleView should] beNil];
    
    OMNWishMediator *restaurantInWishMediator = [restaurantInVisitorMediator wishMediatorWithRootVC:nil];
    [[restaurantInWishMediator should] beKindOfClass:[OMNRestaurantInWishMediator class]];
    [[restaurantInWishMediator.restaurantMediator should] equal:restaurantInVisitorMediator];
    
    [[restaurantInWishMediator.refreshOrdersTitle should] equal:kOMN_WISH_RECOMMENDATIONS_LABEL_TEXT];
    [[restaurantInWishMediator.bottomButton should] beNil];
    
  });
  
});

SPEC_END
