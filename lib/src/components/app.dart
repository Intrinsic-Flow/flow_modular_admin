import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'footer.dart';
import 'side_nav.dart';
import 'top_nav.dart';

/// The top-level component for a Modular Admin application.
@Component(
    selector: 'ma-app',
    templateUrl: 'app.html',
    styleUrls: const ['app.css']
)
class App implements AfterViewInit {
    /// A reference to the top navigation (if there is one).
    @ContentChildren(TopNav)
    QueryList<TopNav> topNav;

    /// True if this application has a top nav.
    @HostBinding('class.has-top-nav')
    @Input()
    bool hasTopNav = true;

    /// A reference to the side navigation (if there is one).
    @ContentChildren(SideNav)
    QueryList<SideNav> sideNav;

    /// True if this application has a side nav.
    @HostBinding('class.has-side-nav')
    @Input()
    bool hasSideNav = false;

    /// A reference to the footer (if there is one).
    @ContentChildren(Footer)
    QueryList<Footer> footer;

    /// True if this application has a footer.
    @HostBinding('class.has-footer')
    @Input()
    bool hasFooter = false;

    /// Constructor
    App(Router router) {
        var rootRouter = router.root;

        rootRouter.subscribe((nextUrl) {
            // Angular doesn't automatically scroll to the top when the route
            // changes, so we do that explictly:
            window.scrollTo(0, 0);

            // ke sure the current route's nav item is visible in the side
            // nav.
            rootRouter.recognize(nextUrl).then((instruction) {
                // window.console.log(instruction.urlPath);
                // window.console.log(instruction.urlParams);
            });
        });
    }

    /// Implementation of AfterViewInit.
    void ngAfterViewInit() {
        scheduleMicrotask(updateLayout);
        this.topNav.changes.listen((_) => updateLayout());
        this.sideNav.changes.listen((_) => updateLayout());
        this.footer.changes.listen((_) => updateLayout());
    }

    /// Check which layout components exist in the DOM.
    void updateLayout() {
        this.hasTopNav = this.topNav.length > 0;
        this.hasSideNav = this.sideNav.length > 0;
        this.hasFooter = this.footer.length > 0;
    }
}