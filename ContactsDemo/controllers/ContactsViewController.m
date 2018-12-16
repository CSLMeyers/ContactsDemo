//
//  ContactsViewController.m
//  ContactsDemo
//
//  Created by myang on 2018/11/28.
//  Copyright © 2018年 myang. All rights reserved.
//

#import "ContactsViewController.h"
//#import "YMMAvatarScrollView.h"
//#import "YMMBriefScrollView.h"
#import "YMMContactModel.h"
#import "YMMBriefItemView.h"

#define SELECTEDCOLOR [UIColor colorWithRed:202.0/255 green:223.0/255 blue:244.0/255 alpha:1.0].CGColor
#define NORMALCOLOR [UIColor clearColor].CGColor

#define HEIGHT_CONTAINER 100
#define AVATAR_DIAMETER     64.0
#define AVATAR_PADDING      10.0

@interface ContactsViewController () < UIScrollViewDelegate>

// use NSMutableArray in case you delete or add contact.
@property (nonatomic, strong) NSMutableArray<YMMContactModel *> *allContactsArray;

@property (nonatomic) UIScrollView *avatarScrollview;
@property (nonatomic) UIScrollView *briefScrollview;

@property (nonatomic) NSMutableArray *avatarItemViews;
@property (nonatomic) NSMutableArray *briefItemViews;

@end

@implementation ContactsViewController

- (instancetype)init {
    if (self = [super init]) {
        _avatarItemViews = [NSMutableArray array];
        _briefItemViews = [NSMutableArray array];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"Contacts";
    
    [self.view addSubview:self.avatarScrollview];
    [self.view addSubview:self.briefScrollview];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.avatarScrollview addGestureRecognizer:tapGesture];
    
    // load data
    [self loadData];
    
    [self layoutSubviewsWithAnimations];
}

#pragma mark private

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    __block CGFloat x = (self.avatarScrollview.frame.size.width - AVATAR_DIAMETER) / 2.0;
    CGFloat y = (self.avatarScrollview.frame.size.height - AVATAR_DIAMETER) / 2.0;
    
    [self.avatarItemViews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        CGRect frame = CGRectMake(x, y, AVATAR_DIAMETER, AVATAR_DIAMETER);
        view.frame = frame;
        
        x += AVATAR_DIAMETER + AVATAR_PADDING;
    }];
    
    __block CGFloat contentY = 0.0;
    
    [self.briefItemViews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        view.frame = CGRectMake(0, contentY, self.briefScrollview.frame.size.width, self.briefScrollview.frame.size.height);
        [view layoutIfNeeded];
        
        contentY += view.frame.size.height;
    }];
    
    self.avatarScrollview.contentSize = CGSizeMake((AVATAR_DIAMETER + AVATAR_PADDING) * (self.allContactsArray.count - 1) + self.avatarScrollview.frame.size.width, 0);
    
    self.briefScrollview.contentSize = CGSizeMake(0, self.briefScrollview.frame.size.height * self.allContactsArray.count);
}

- (void) loadData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"contacts" ofType:@"json"];
    NSArray *contactsInfo = [self readLocalfileWithName:path];
    
    if (![contactsInfo isKindOfClass:[NSArray class]]) {
        NSLog(@"please check contacts.json !");
        return;
    }
    
    for (id contact in contactsInfo) {
        YMMContactModel *tempModel = [YMMContactModel createModelWithDict:contact];
        [self.allContactsArray addObject:tempModel];
    }
    
    [self.allContactsArray enumerateObjectsUsingBlock:^(YMMContactModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:model.avatar_filename]];
        
        imageView.layer.cornerRadius = AVATAR_DIAMETER / 2.0;
        imageView.layer.borderColor = NORMALCOLOR;
        imageView.layer.borderWidth = 2.0;
        
        [self.avatarScrollview addSubview:imageView];
        [self.avatarItemViews addObject:imageView];
        
        YMMBriefItemView *briefView = [[YMMBriefItemView alloc] init];
        [briefView setModel:model];
        
        [self.briefScrollview addSubview:briefView];
        [self.briefItemViews addObject:briefView];
    }];
}

- (NSMutableArray <UIImage *> *) collectImages {
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    
    for (YMMContactModel *contactModel in self.allContactsArray) {
        [imageArray addObject:[UIImage imageNamed:contactModel.avatar_filename]];
    }
    
    return [imageArray copy];
}

- (NSArray *) readLocalfileWithName:(NSString *)path {
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    
    if (!data) {
        return nil;
    }
    
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

- (NSInteger)indexOfView:(UIView *)view {
    __block NSUInteger index = NSNotFound;
    
    [self.avatarItemViews enumerateObjectsUsingBlock:^(UIView *itemView, NSUInteger idx, BOOL *stop) {
        if (view == itemView) {
            index = idx;
            *stop = YES;
        }
    }];
    
    return index;
}

- (NSInteger)indexOfTap:(CGPoint)location {
    __block NSUInteger index = NSNotFound;
    
    [self.avatarItemViews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        if (CGRectContainsPoint(view.frame, location)) {
            index = idx;
            *stop = YES;
        }
    }];
    
    return index;
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:self.avatarScrollview];

    NSInteger tapIndex = [self indexOfTap:location];
    if (tapIndex != NSNotFound) {
        [self chooseContactAt:tapIndex];
    }
    
    return;
}

- (void) chooseContactAt:(NSUInteger)index {
    if (index >= self.avatarItemViews.count) {
        NSLog(@"index out of count !");
        return;
    }
    
    UIView *view = self.avatarItemViews[index];
    
    CGFloat newOffsetX = view.center.x - self.avatarScrollview.frame.size.width * 0.5;
    if (newOffsetX < 0.0) {
        newOffsetX = 0.0;
    }
    if (newOffsetX > self.avatarScrollview.contentSize.width - self.avatarScrollview.frame.size.width) {
        newOffsetX = self.avatarScrollview.contentSize.width - self.avatarScrollview.frame.size.width;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.avatarScrollview setContentOffset:CGPointMake(newOffsetX, 0.0)];
    }];
}

- (void)animateSpringWithView:(UIView *)view idx:(NSUInteger)idx initDelay:(CGFloat)initDelay {
#if __IPHONE_OS_VERSION_SOFT_MAX_REQUIRED
    [UIView animateWithDuration:0.5
                          delay:(initDelay + idx*0.1f)
         usingSpringWithDamping:10
          initialSpringVelocity:50
                        options:0
                     animations:^{
                         view.layer.transform = CATransform3DIdentity;
                         view.alpha = 1;
                     }
                     completion:nil];
#endif
}

- (void) layoutSubviewsWithAnimations {
    CGFloat initDelay = 0.1f;
    [self.avatarItemViews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        view.layer.transform = CATransform3DMakeScale(0.3, 0.3, 1);
        
        [self animateSpringWithView:view idx:idx initDelay:initDelay];
    }];
}

#pragma mark lazyLoad

- (UIScrollView *)avatarScrollview {
    if (!_avatarScrollview) {
        CGFloat y = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        UIScrollView *avatarScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, y, WIDTH_SCREEN, HEIGHT_CONTAINER)];
        
        avatarScrollview.delegate = self;
        avatarScrollview.showsHorizontalScrollIndicator = NO;
        avatarScrollview.showsVerticalScrollIndicator = NO;
        
        _avatarScrollview  = avatarScrollview;
    }
    
    return _avatarScrollview;
}

- (UIScrollView *)briefScrollview {
    if (!_briefScrollview) {
        CGFloat y = CGRectGetMaxY(self.avatarScrollview.frame);
        UIScrollView *briefScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, y, WIDTH_SCREEN, HEIGHT_SCREEN - y)];
        briefScrollview.delegate = self;
        briefScrollview.pagingEnabled = YES;
        
        _briefScrollview  = briefScrollview;
    }
    
    return _briefScrollview;
}

- (NSMutableArray<YMMContactModel *> *)allContactsArray {
    if (!_allContactsArray) {
        _allContactsArray = [[NSMutableArray alloc] init];
    }
    
    return _allContactsArray;
}

#pragma mark UIScrollViewDelegate

// locate in some avatar
- (void) scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (scrollView == self.avatarScrollview) {
        CGFloat pageSize = AVATAR_DIAMETER + AVATAR_PADDING;
        NSInteger page = roundf((*targetContentOffset).x / pageSize);
        CGFloat targetX = pageSize * page;

        targetContentOffset->x = targetX;
    }
}

// link two scrollview
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.avatarScrollview) {
        CGFloat contentY = self.avatarScrollview.contentOffset.x / (AVATAR_DIAMETER + AVATAR_PADDING)  * self.briefScrollview.frame.size.height;
        if (fabs(self.briefScrollview.contentOffset.y - contentY) < 1.0) {
            return;
        }
        
        self.briefScrollview.contentOffset = CGPointMake(0.0, contentY);
    }
    else if (scrollView == self.briefScrollview) {
        CGFloat contentX = self.briefScrollview.contentOffset.y / self.briefScrollview.frame.size.height * (AVATAR_DIAMETER + AVATAR_PADDING);
        if (fabs(self.avatarScrollview.contentOffset.x - contentX) < 1.0) {
            return;
        }
        
        self.avatarScrollview.contentOffset = CGPointMake(contentX, 0.0);
    }
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.avatarScrollview) {
        CGFloat pageSize = AVATAR_DIAMETER + AVATAR_PADDING;
        NSInteger page = roundf(self.avatarScrollview.contentOffset.x / pageSize);
        
        [self.avatarScrollview setContentOffset:CGPointMake(page * pageSize, 0.0)];
    }
}

#pragma mark functions will offer

- (void) deleteContact:(NSInteger) index{
//    [self.allContactsArray removeObjectAtIndex:index];
//    [self.avatarScrollview deleteContactAt:index];
//    [self.briefScrollview deleteContactAt:index];
}

- (void) addContact:(YMMContactModel *) model {
//    [self.allContactsArray addObject:model];
//    [self.avatarScrollview addContact:[UIImage imageNamed:model.avatar_filename]];
//    [self.briefScrollview addContact:model];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
