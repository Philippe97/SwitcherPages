#import <Foundation/Foundation.h>
#import <SpringBoard/SpringBoard.h>
#import <SpringBoard/SBAppSwitcherBarView.h>
#import <SpringBoard/SBAppSwitcherController.h>
#import <UIKit/UIKit.h>
#include <substrate.h>

void updatePageControlWithBarViewAndScrollView(SBAppSwitcherBarView *self, UIScrollView *scrollView) {
	for (id sub in self.subviews) {
		if ([sub isKindOfClass:[UIPageControl class]]) {
			float pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width;
			float pageCount = scrollView.contentSize.width / scrollView.frame.size.width;
			[(UIPageControl*)sub setNumberOfPages:pageCount];
			[(UIPageControl*)sub setCurrentPage:pageNumber];
			break;
		}
	}
}

MSHook(id, SBAppSwitcherBarView$initWithFrame$, SBAppSwitcherBarView *self, SEL sel, CGRect frame) {
	self = _SBAppSwitcherBarView$initWithFrame$(self, sel, frame);
	UIScrollView* &scrollView(MSHookIvar<UIScrollView*>(self, "_scrollView"));
	UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 17)];
	float pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width;
	float pageCount = scrollView.contentSize.width / scrollView.frame.size.width;
	[pageControl setNumberOfPages:pageCount];
	pageControl.currentPage = pageNumber;
	[pageControl setUserInteractionEnabled:NO];
	[self addSubview:pageControl];
	[pageControl release];
	return self;
}

MSHook(void, SBAppSwitcherBarView$prepareForDisplay$, SBAppSwitcherBarView *self, SEL sel, id inconnu) {
	_SBAppSwitcherBarView$prepareForDisplay$(self, sel, inconnu);
	UIScrollView* &scrollView(MSHookIvar<UIScrollView*>(self, "_scrollView"));
	updatePageControlWithBarViewAndScrollView(self, scrollView);
	/*
	for (id sub in self.subviews) {
		if ([sub isKindOfClass:[UIPageControl class]]) {
			float pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width;
			float pageCount = scrollView.contentSize.width / scrollView.frame.size.width;
			[(UIPageControl*)sub setNumberOfPages:pageCount];
			[(UIPageControl*)sub setCurrentPage:pageNumber];
			break;
		}
	}*/
}

MSHook(void, SBAppSwitcherBarView$scrollViewDidEndDecelerating$, SBAppSwitcherBarView *self, SEL sel, UIScrollView *scrollView) {
	_SBAppSwitcherBarView$scrollViewDidEndDecelerating$(self, sel, scrollView);
	updatePageControlWithBarViewAndScrollView(self, scrollView);
}

MSHook(void, SBAppSwitcherBarView$scrollViewDidEndScrollingAnimation$, SBAppSwitcherBarView *self, SEL sel, UIScrollView *scrollView) {
	_SBAppSwitcherBarView$scrollViewDidEndScrollingAnimation$(self, sel, scrollView);
	updatePageControlWithBarViewAndScrollView(self, scrollView);
	/*for (id sub in self.subviews) {
		if ([sub isKindOfClass:[UIPageControl class]]) {
			float pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width;
			float pageCount = scrollView.contentSize.width / scrollView.frame.size.width;
			[(UIPageControl*)sub setNumberOfPages:pageCount];
			[(UIPageControl*)sub setCurrentPage:pageNumber];
			break;
		}
	}*/
}

MSHook(void, SBAppSwitcherBarView$setEditing$, SBAppSwitcherBarView *self, SEL sel, BOOL editing) {
	_SBAppSwitcherBarView$setEditing$(self, sel, editing);
	UIScrollView* &scrollView(MSHookIvar<UIScrollView*>(self, "_scrollView"));
	updatePageControlWithBarViewAndScrollView(self, scrollView);
	/*for (id sub in self.subviews) {
		if ([sub isKindOfClass:[UIPageControl class]]) {
			float pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width;
			float pageCount = scrollView.contentSize.width / scrollView.frame.size.width;
			[(UIPageControl*)sub setNumberOfPages:pageCount];
			[(UIPageControl*)sub setCurrentPage:pageNumber];
			break;
		}
	}*/
}

extern "C" void TweakInitialize() {
	_SBAppSwitcherBarView$initWithFrame$ = MSHookMessage(objc_getClass("SBAppSwitcherBarView"), @selector(initWithFrame:), &$SBAppSwitcherBarView$initWithFrame$);
	_SBAppSwitcherBarView$prepareForDisplay$ = MSHookMessage(objc_getClass("SBAppSwitcherBarView"), @selector(prepareForDisplay:), &$SBAppSwitcherBarView$prepareForDisplay$);
	_SBAppSwitcherBarView$scrollViewDidEndDecelerating$ = MSHookMessage(objc_getClass("SBAppSwitcherBarView"), @selector(scrollViewDidEndDecelerating:), &$SBAppSwitcherBarView$scrollViewDidEndDecelerating$);
	_SBAppSwitcherBarView$scrollViewDidEndScrollingAnimation$ = MSHookMessage(objc_getClass("SBAppSwitcherBarView"), @selector(scrollViewDidEndScrollingAnimation:), &$SBAppSwitcherBarView$scrollViewDidEndScrollingAnimation$);
	_SBAppSwitcherBarView$setEditing$ = MSHookMessage(objc_getClass("SBAppSwitcherBarView"), @selector(setEditing:), &$SBAppSwitcherBarView$setEditing$);
}