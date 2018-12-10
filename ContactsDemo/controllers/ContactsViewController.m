//
//  ViewController.m
//  ContactsDemo
//
//  Created by myang on 2018/11/28.
//  Copyright © 2018年 myang. All rights reserved.
//

#import "ContactsViewController.h"
#import "YMMAvatarScrollView.h"
#import "YMMBriefScrollView.h"
#import "YMMContactModel.h"

#define HEIGHT_CONTAINER 100

@interface ContactsViewController () <YMMBriefScrollViewDelegate, YMMAvatarScrollViewDelegate, UIScrollViewDelegate>

// use NSMutableArray in case you delete or add contact.
@property (nonatomic, strong) NSMutableArray<YMMContactModel *> *allContactsArray;

@property (nonatomic) YMMAvatarScrollView *contactContainer;
@property (nonatomic) YMMBriefScrollView *contactBriefView;

@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"Contacts";
    
    [self.view addSubview:self.contactContainer];
    [self.view addSubview:self.contactBriefView];
    
    // load data
    [self loadData];
    self.contactContainer.contactAvatar = [self collectImages];
    self.contactBriefView.models = [self.allContactsArray copy];
    
    [self.contactContainer layoutSubviewsWithAnimations];
//    [self.contactBriefView layoutSubviewsWithAnimations];
    [self.contactBriefView layoutIfNeeded];
    
    // default choose the second contact
    [self.contactContainer chooseContactAt:1];
}

#pragma mark private

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
}

- (NSMutableArray <UIImage *> *) collectImages {
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    
    for (YMMContactModel *contactModel in self.allContactsArray) {
        [imageArray addObject:[UIImage imageNamed:contactModel.avatar_filename]];
    }
    
    return [imageArray copy];
}

- (NSArray *) readLocalfileWithName:(NSString *)path {
//    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
//        NSLog(@"file doesn't exist !");
//        return nil;
//    }
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    
    if (!data) {
        return nil;
    }
    
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

#pragma mark lazyLoad

- (YMMAvatarScrollView *)contactContainer {
    if (!_contactContainer) {
        CGFloat y = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        YMMAvatarScrollView *contactContainer = [[YMMAvatarScrollView alloc] initWithFrame:CGRectMake(0, y, WIDTH_SCREEN, HEIGHT_CONTAINER)];
        
        contactContainer.avatarDelegate = self;
        contactContainer.delegate = self;
        contactContainer.showsHorizontalScrollIndicator = NO;
        contactContainer.showsVerticalScrollIndicator = NO;
        
        _contactContainer  = contactContainer;
    }
    
    return _contactContainer;
}

- (YMMBriefScrollView *)contactBriefView {
    if (!_contactBriefView) {
        CGFloat y = CGRectGetMaxY(self.contactContainer.frame);
        YMMBriefScrollView *contactBriefView = [[YMMBriefScrollView alloc] initWithFrame:CGRectMake(0, y, WIDTH_SCREEN, HEIGHT_SCREEN - y)];
        contactBriefView.delegate = self;
        contactBriefView.briefViewDelegate = self;
        contactBriefView.pagingEnabled = YES;
        
        _contactBriefView  = contactBriefView;
    }
    
    return _contactBriefView;
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
    if (scrollView == self.contactContainer) {
        CGFloat pageSize = AVATAR_DIAMETER + AVATAR_PADDING;
        NSInteger page = roundf((*targetContentOffset).x / pageSize);
        CGFloat targetX = pageSize * page;

        targetContentOffset->x = targetX;
    }
}

// link two scrollview
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.contactContainer) {
        CGFloat contentY = self.contactContainer.contentOffset.x / (AVATAR_DIAMETER + AVATAR_PADDING)  * self.contactBriefView.frame.size.height;
        if (fabs(self.contactBriefView.contentOffset.y - contentY) < 1.0) {
            return;
        }
        
        self.contactBriefView.contentOffset = CGPointMake(0.0, contentY);
    }
    else if (scrollView == self.contactBriefView) {
        CGFloat contentX = self.contactBriefView.contentOffset.y / self.contactBriefView.frame.size.height * (AVATAR_DIAMETER + AVATAR_PADDING);
        if (fabs(self.contactContainer.contentOffset.x - contentX) < 1.0) {
            return;
        }
        
        self.contactContainer.contentOffset = CGPointMake(contentX, 0.0);
    }
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.contactContainer) {
        CGFloat pageSize = AVATAR_DIAMETER + AVATAR_PADDING;
        NSInteger page = roundf(self.contactContainer.contentOffset.x / pageSize);
        
        [self.contactContainer chooseContactAt:page];
    }
    else if (scrollView == self.contactBriefView)
    {
        CGFloat pageSize = self.contactBriefView.frame.size.height;
        NSInteger page = roundf(self.contactBriefView.contentOffset.y / pageSize);
        
        [self.contactContainer chooseContactAt:page];
    }
}

#pragma mark YMMContactContainerDelegate

// when one avatar is tapped.
- (void) avatarContainer:(YMMBaseScrollView *)avatarContainer didTapItem:(UIView *)view atIndex:(NSInteger)index {
    NSLog(@"avatarContainer index =====> %ld",(long)index);
}

#pragma mark YMMContactBriefViewDelegate 

// when one briefView is clicked. maybe navigate to anthor ViewController
- (void) briefView:(YMMBaseScrollView *)briefView didTapItem:(UIView *)view atIndex:(NSInteger)index {
    NSLog(@"briefView index =====> %ld",index);
}

#pragma mark functions will offer

- (void) deleteContact:(NSInteger) index{
//    [self.allContactsArray removeObjectAtIndex:index];
//    [self.contactContainer deleteContactAt:index];
//    [self.contactBriefView deleteContactAt:index];
}

- (void) addContact:(YMMContactModel *) model {
//    [self.allContactsArray addObject:model];
//    [self.contactContainer addContact:[UIImage imageNamed:model.avatar_filename]];
//    [self.contactBriefView addContact:model];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
