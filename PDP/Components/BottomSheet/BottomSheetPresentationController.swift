//
//  BottomSheetPresentationController.swift
//  PDP
//
//  Created by Евгений Самарин on 21.04.2022.
//

import UIKit
import Combine

public protocol ScrollableBottomSheetPresentedController: AnyObject {
    var scrollView: UIScrollView? { get }
}

public final class BottomSheetPresentationController: UIPresentationController {

    // MARK: - Nested Types

    private enum State {

        // MARK: - BottomSheetPresentationController State

        case dismissed
        case presenting
        case presented
        case dismissing
    }

    private struct Style {
        static let cornerRadius: CGFloat = 30
        static let pullBarHeight: CGFloat = 30
    }

    // MARK: - Instance properties

    static var pullBarHeight: CGFloat {
        Style.pullBarHeight
    }

    var interactiveTransition: UIViewControllerInteractiveTransitioning? {
        interactionController
    }

    // MARK: -

    private var state: State = .dismissed
    private var isInteractiveTransitionCanBeHandled: Bool {
        isDragging && !isNavigationTransitionInProgress
    }
    private var isDragging = false {
        didSet {
            if isDragging {
                assert(interactionController == nil)
            }
        }
    }
    private var isNavigationTransitionInProgress = false {
        didSet {
            assert(interactionController == nil)
        }
    }
    private var overlayTranslation: CGFloat = 0
    private var scrollViewTranslation: CGFloat = 0
    private var lastContentOffsetBeforeDragging: CGPoint = .zero
    private var didStartDragging = false
    private var interactionController: UIPercentDrivenInteractiveTransition?
    private weak var trackedScrollView: UIScrollView?
    private var cachedInsets: UIEdgeInsets = .zero
    private let dismissalHandler: BottomSheetModalDismissalHandler

    // MARK: -

    public var shadingView: UIView?
    public var pullBar: PullBar?

    // MARK: - Init

    public init(
        presentedViewController: UIViewController,
        presentingViewController: UIViewController?,
        dismissalHandler: BottomSheetModalDismissalHandler
    ) {
        self.dismissalHandler = dismissalHandler
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }

    // MARK: - Instance Methods

    private func setupGesturesForPresentedView() {
        self.setupPanGesture(for: presentedView)
        self.setupPanGesture(for: pullBar)
    }

    private func setupPanGesture(for view: UIView?) {
        guard let view = view else {
            return
        }

        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(panRecognizer)
        panRecognizer.delegate = self
    }

    private func setupScrollTrackingIfNeeded() {
        if let navigationController = presentedViewController as? UINavigationController {
            navigationController.multicastingDelegate.addDelegate(self)

            if let topViewController = navigationController.topViewController {
                trackScrollView(inside: topViewController)
            }
        } else {
            trackScrollView(inside: presentedViewController)
        }
    }

    private func removeScrollTrackingIfNeeded() {
        trackedScrollView?.multicastingDelegate.removeDelegate(self)
        trackedScrollView = nil
    }

    // MARK: - UIPresentationController Methods

    public override func presentationTransitionWillBegin() {
        self.state = .presenting

        self.addSubviews()
    }

    public override func presentationTransitionDidEnd(_ completed: Bool) {
        if completed {
            self.setupGesturesForPresentedView()
            self.setupScrollTrackingIfNeeded()

            self.state = .presented
        } else {
            self.state = .dismissed
        }
    }

    public override func dismissalTransitionWillBegin() {
        self.state = .dismissing
    }

    public override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            self.removeSubviews()
            self.removeScrollTrackingIfNeeded()

            self.state = .dismissed
        } else {
            self.state = .presented
        }
    }

    public override var shouldPresentInFullscreen: Bool {
        false
    }

    public override var frameOfPresentedViewInContainerView: CGRect {
        self.targetFrameForPresentedView()
    }

    public override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        self.updatePresentedViewSize()
    }

    public override func containerViewDidLayoutSubviews() {
        self.cachedInsets = presentedView?.window?.safeAreaInsets ?? .zero

        self.updatePresentedViewSize()
    }

    // MARK: - Interactive Dismissal

    @objc
    private func handlePanGesture(_ panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
        case .began:
            self.processPanGestureBegan(panGesture)

        case .changed:
            self.processPanGestureChanged(panGesture)

        case .ended:
            self.processPanGestureEnded(panGesture)

        case .cancelled:
            self.processPanGestureCancelled(panGesture)

        default:
            break
        }
    }

    private func processPanGestureBegan(_ panGesture: UIPanGestureRecognizer) {
        self.startInteractiveTransition()
    }

    private func startInteractiveTransition() {
        self.interactionController = UIPercentDrivenInteractiveTransition()

        presentingViewController.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }

            if self.presentingViewController.presentedViewController !== self.presentedViewController {
                self.dismissalHandler.performDismissal(animated: true)
            }
        }
    }

    private func processPanGestureChanged(_ panGesture: UIPanGestureRecognizer) {
        let translation = panGesture.translation(in: nil)
        self.updateInteractionControllerProgress(verticalTranslation: translation.y)
    }

    private func updateInteractionControllerProgress(verticalTranslation: CGFloat) {
        guard let presentedView = presentedView else {
            return
        }

        let progress = verticalTranslation / presentedView.bounds.height
        self.interactionController?.update(progress)
    }

    private func processPanGestureEnded(_ panGesture: UIPanGestureRecognizer) {
        let velocity = panGesture.velocity(in: presentedView)
        let translation = panGesture.translation(in: presentedView)
        self.endInteractiveTransition(verticalVelocity: velocity.y, verticalTranslation: translation.y)
    }

    private func endInteractiveTransition(verticalVelocity: CGFloat, verticalTranslation: CGFloat) {
        guard let presentedView = presentedView else {
            return
        }

        let deceleration = 800.0 * (verticalVelocity > 0 ? -1.0 : 1.0)
        let finalProgress = (verticalTranslation - 0.5 * verticalVelocity * verticalVelocity / CGFloat(deceleration))
            / presentedView.bounds.height
        let isThresholdPassed = finalProgress < 0.5

        self.endInteractiveTransition(isCancelled: isThresholdPassed)
    }

    private func processPanGestureCancelled(_ panGesture: UIPanGestureRecognizer) {
        self.endInteractiveTransition(isCancelled: true)
    }

    private func endInteractiveTransition(isCancelled: Bool) {
        if isCancelled {
            self.interactionController?.cancel()
        } else if !dismissalHandler.canBeDismissed {
            self.interactionController?.cancel()
        } else {
            self.interactionController?.finish()
        }
        self.interactionController = nil
    }

    // MARK: - Private Methods

    private func applyStyle() {
        guard presentedViewController.isViewLoaded else {
            assertionFailure()
            return
        }

        presentedViewController.view.clipsToBounds = true

        self.pullBar?.layer.mask = nil
        presentedViewController.view.layer.cornerRadius = Style.cornerRadius
        presentedViewController.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    private func addSubviews() {
        guard let containerView = containerView else {
            assertionFailure()
            return
        }

        // MARK: - REFACTOR THIS ( CREATE APPEARANCE CLASS FOR BOTTOM SHEET)

        let shadingView = UIView()
        shadingView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        containerView.addSubview(shadingView)
        shadingView.frame = containerView.bounds

        let pullBar = PullBar()
        pullBar.frame.size = CGSize(width: containerView.frame.width, height: Style.pullBarHeight)
        containerView.addSubview(pullBar)

        let tapGesture = UITapGestureRecognizer()
        shadingView.addGestureRecognizer(tapGesture)

        tapGesture.addTarget(self, action: #selector(handleShadingViewTapGesture))

        self.shadingView = shadingView
        self.pullBar = pullBar
    }
    
    @objc
    private func handleShadingViewTapGesture() {
        self.dismissIfPossible()
    }

    private func removeSubviews() {
        self.shadingView?.removeFromSuperview()
        self.shadingView = nil
        self.pullBar?.removeFromSuperview()
        self.pullBar = nil
    }

    private func targetFrameForPresentedView() -> CGRect {
        guard let containerView = containerView else {
            return .zero
        }

        let windowInsets = presentedView?.window?.safeAreaInsets ?? cachedInsets

        let preferredHeight = presentedViewController.preferredContentSize.height + windowInsets.bottom
        let maxHeight = containerView.bounds.height - windowInsets.top - Style.pullBarHeight
        let height = min(preferredHeight, maxHeight)

        return .init(
            x: 0,
            y: (containerView.bounds.height - height).pixelCeiled,
            width: containerView.bounds.width,
            height: height.pixelCeiled
        )
    }

    private func updatePresentedViewSize() {
        guard let presentedView = presentedView else {
            return
        }

        let oldFrame = presentedView.frame
        let targetFrame = targetFrameForPresentedView()
        if !oldFrame.isAlmostEqual(to: targetFrame) {
            presentedView.frame = targetFrame
            self.pullBar?.frame.origin.y = presentedView.frame.minY - Style.pullBarHeight + pixelSize
        }
    }

    @discardableResult
    private func dismissIfPossible() -> Bool {
        let canBeDismissed = state == .presented && dismissalHandler.canBeDismissed

        if canBeDismissed {
            self.dismissalHandler.performDismissal(animated: true)
        }

        return canBeDismissed
    }
}

// MARK: - UIScrollViewDelegate

extension BottomSheetPresentationController: UIScrollViewDelegate {

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if
            !scrollView.isContentOriginInBounds,
            scrollView.contentSize.height.isAlmostEqual(to: scrollView.frame.height - scrollView.adjustedContentInset.verticalInsets)
        {
            scrollView.bounds.origin.y = -scrollView.adjustedContentInset.top
        }

        // We don't want bounces inside bottom sheet
        let previousTranslation = self.scrollViewTranslation
        self.scrollViewTranslation = scrollView.panGestureRecognizer.translation(in: scrollView).y
        
        self.didStartDragging = self.shouldDragOverlay(following: scrollView)
        if self.didStartDragging {
            self.startInteractiveTransitionIfNeeded()
            self.overlayTranslation += self.scrollViewTranslation - previousTranslation
            
            // Update scrollView contentInset without invoking scrollViewDidScroll(_:)
            scrollView.bounds.origin.y = -scrollView.adjustedContentInset.top
            
            self.updateInteractionControllerProgress(verticalTranslation: self.overlayTranslation)
        } else {
            self.lastContentOffsetBeforeDragging = scrollView.panGestureRecognizer.translation(in: scrollView)
        }
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.isDragging = true
    }

    public func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        if self.didStartDragging {
            let velocity = scrollView.panGestureRecognizer.velocity(in: scrollView)
            let translation = scrollView.panGestureRecognizer.translation(in: scrollView)
            self.endInteractiveTransition(verticalVelocity: velocity.y,
                                          verticalTranslation: translation.y - self.lastContentOffsetBeforeDragging.y)
        } else {
            self.endInteractiveTransition(isCancelled: true)
        }

        self.overlayTranslation = 0
        self.scrollViewTranslation = 0
        self.lastContentOffsetBeforeDragging = .zero
        self.didStartDragging = false
        self.isDragging = false
    }
    
    private func startInteractiveTransitionIfNeeded() {
        guard interactionController == nil else {
            return
        }

        self.startInteractiveTransition()
    }
    
    private func shouldDragOverlay(following scrollView: UIScrollView) -> Bool {
        guard scrollView.isTracking,
              self.isInteractiveTransitionCanBeHandled
        else {
            return false
        }
        
        if let percentComplete = self.interactionController?.percentComplete {
            if percentComplete.isAlmostEqual(to: 0) {
                return scrollView.isContentOriginInBounds && scrollView.scrollsDown
            }
            return true
        } else {
            return scrollView.isContentOriginInBounds && scrollView.scrollsDown
        }
    }
}

// MARK: - UIGestureRecognizerDelegate

extension BottomSheetPresentationController: UIGestureRecognizerDelegate {

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let panGesture = gestureRecognizer as? UIPanGestureRecognizer else {
            return false
        }

        let translation = panGesture.translation(in: presentedView)
        return self.state == .presented && translation.y > 0
    }

    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        if otherGestureRecognizer === self.trackedScrollView?.panGestureRecognizer {
            return true
        }

        return false
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        !self.isNavigationTransitionInProgress
    }
}

// MARK: - UINavigationControllerDelegate

extension BottomSheetPresentationController: UINavigationControllerDelegate {

    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        self.trackScrollView(inside: viewController)

        self.isNavigationTransitionInProgress = false
    }

    public func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
        self.isNavigationTransitionInProgress = true
    }

    private func trackScrollView(inside viewController: UIViewController) {
        guard
            let scrollableViewController = viewController as? ScrollableBottomSheetPresentedController,
            let scrollView = scrollableViewController.scrollView
        else {
            return
        }
        
        trackedScrollView?.multicastingDelegate.removeDelegate(self)
        scrollView.multicastingDelegate.addDelegate(self)
        self.trackedScrollView = scrollView
    }
}

// MARK: - UIViewControllerAnimatedTransitioning

extension BottomSheetPresentationController: UIViewControllerAnimatedTransitioning {

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.3
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let sourceViewController = transitionContext.viewController(forKey: .from),
            let destinationViewController = transitionContext.viewController(forKey: .to),
            let sourceView = sourceViewController.view,
            let destinationView = destinationViewController.view
        else {
            return
        }

        let isPresenting = destinationViewController.isBeingPresented
        let presentedView = isPresenting ? destinationView : sourceView
        let containerView = transitionContext.containerView
        if isPresenting {
            containerView.addSubview(destinationView)
            destinationView.frame = containerView.bounds
        }

        sourceView.layoutIfNeeded()
        destinationView.layoutIfNeeded()

        let frameInContainer = self.frameOfPresentedViewInContainerView
        let offscreenFrame = CGRect(origin: CGPoint(x: 0,y: containerView.bounds.height),
                                    size: sourceView.frame.size)

        presentedView.frame = isPresenting ? offscreenFrame : frameInContainer
        self.pullBar?.frame.origin.y = presentedView.frame.minY - Style.pullBarHeight + pixelSize
        self.shadingView?.alpha = isPresenting ? 0 : 1

        self.applyStyle()

        let animations = {
            presentedView.frame = isPresenting ? frameInContainer : offscreenFrame
            self.pullBar?.frame.origin.y = presentedView.frame.minY - Style.pullBarHeight + pixelSize
            self.shadingView?.alpha = isPresenting ? 1 : 0
        }

        let completion = { (completed: Bool) in
            transitionContext.completeTransition(completed && !transitionContext.transitionWasCancelled)
        }

        let options: UIView.AnimationOptions = transitionContext.isInteractive ? .curveLinear : .curveEaseInOut
        let transitionDurationValue = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: transitionDurationValue, delay: 0, options: options, animations: animations, completion: completion)
    }

    public func animationEnded(_ transitionCompleted: Bool) {
    }
}

private extension UIScrollView {
    var scrollsUp: Bool {
        panGestureRecognizer.velocity(in: nil).y < 0
    }
    
    var scrollsDown: Bool {
        !scrollsUp
    }
    
    var isContentOriginInBounds: Bool {
        contentOffset.y <= -adjustedContentInset.top
    }
}
