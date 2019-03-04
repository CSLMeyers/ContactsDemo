ContactsDemo
====================

This project is mainly about two scrollviews interaction. When you drag one scrollview, the other will move with it.

## Usage

The simplest usage is to create a list of avatars and a list of introductions. Initialize a avatarScroll and a briefScroll, then set data to scrolls.

When you tap or click one contact, the contact will be located in the middle of the screen.


## Animations

I've exposed an option for you to layout subviews one by one.

```objc
- (void) layoutSubviewsWithAnimations;
```

When one scrollview's contentSize is changing, the other will change in proportion. Furthermore, no matter how you drag the avatar scrollView, it will stop at the place that a proper avatar is in the middle of the scrollView.

```objc
if (scrollView == self.contactContainer) {
    CGFloat pageSize = AVATAR_DIAMETER + AVATAR_PADDING;
    NSInteger page = roundf((*targetContentOffset).x / pageSize);
    CGFloat targetX = pageSize * page;

    targetContentOffset->x = targetX;
}
```


## Future work

In consideration of  the changing of contacts, I've exposed options such as "deleteContactAt" and "addContact" to update the contact list and scrollviews.

```objc
- (BOOL) deleteContactAt:(NSUInteger)index;
- (BOOL) addContact:(id)model at:(NSUInteger)index;
- (BOOL) addContact:(id)model;
```
What's more, there is also works with lazy loading the contacts which are beyond the screen.


再次更新： 2019/3/4

