
import SwiftUI

// MARK: - ScrollView
@available(iOS 13.0, *)
/// A ScrollView with a completion handler that will be executed when the user swipe down the scroll view and release it, and a View for Header on top of the Scroll View.
public struct ScrollViewWithCompletionHandler<Header:View, Content:View>: View {
    
    /// A closure which returns the Header View
    var header: () -> Header
    /// A completion handler that will be executed when the user swipe down the scroll view and release it.
    var scrollDownCompletion: () -> Void
    /// A closure which returns the content Views of ScrollView
    var content: () -> Content
    
    /**
    Creates a ScrollView with a completion handler that will be executed when the user swipe down the scroll view and release it, and a View for Header on top of the Scroll View.
    - Parameters:
        - header: A View that will be on top of ScrollView and will animate when you scroll.
        - scrollDownCompletion: A completion handler that will be executed when the user swipe down the scroll view and release it.
        - content: Content Views of ScrollView.
    */
    public init(header: @escaping () -> Header, scrollDownCompletion: @escaping () -> Void, @ViewBuilder content: @escaping () -> Content) {
        self.header = header
        self.scrollDownCompletion = scrollDownCompletion
        self.content = content
    }
    
    @State private var contentOffset: CGFloat = .zero
    
    // MARK: Body
    public var body: some View {
        // The global geometry reader
        GeometryReader { geometry in
            ScrollView {
                ZStack {
                    // The background geometry reader to read the offset
                    GeometryReader { localGeo in
                        Color.clear
                        // It sends the value of offset (after it is calculated)
                        .preference(key: ScrollOffsetPreferenceKey.self, value: [self.calculateContentOffset(fromOutsideProxy: geometry, insideProxy: localGeo)])

                    }
                    
                    VStack(spacing: 0.0) {
                        self.header()
                            // The modifier that creates the animation of the View and executes the completion handler
                            .modifier(HeaderEffect(contentOffset: self.contentOffset, scrollDownCompletion: {
                                self.scrollDownCompletion()
                            }))
                        
                        self.content()
                    }
                }
            }
            // It receives the offset and changes the state
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                self.contentOffset = value[0]
            }
        }
    }
    
    // MARK: - Content Offset Calculation
    /// It calculates the offset based on the GeometryProxies that we provide.
    private func calculateContentOffset(fromOutsideProxy outsideProxy: GeometryProxy, insideProxy: GeometryProxy) -> CGFloat {
        insideProxy.frame(in: .global).minY - outsideProxy.frame(in: .global).minY
    }
}

// MARK: -  Preference Key
struct ScrollOffsetPreferenceKey: PreferenceKey {
    typealias Value = [CGFloat]
    
    static var defaultValue: [CGFloat] = [0]
    
    static func reduce(value: inout [CGFloat], nextValue: () -> [CGFloat]) {
        value.append(contentsOf: nextValue())
    }
}



// MARK: - View Modifier
@available(iOS 13.0, *)
/// A ViewModifier that executes a completion handler when the user swipes down and release the scrollView.
struct HeaderEffect: ViewModifier {
    /// If the user swiped down the ScrollView enough to enable completion handler.
    static var isCompletionHandlerEnabled: Bool = false
    /// The ScrollView content offset
    var contentOffset: CGFloat
    /// A completion handler that will be executed when the user swipe down the scroll view and release it.
    var scrollDownCompletion: () -> Void
    
    /// Creates a ViewModifier that detects the position of a view based on GeometryProxy, and and executes a completion handler when the user swipes down and release the scrollView.
    init(contentOffset: CGFloat, scrollDownCompletion: @escaping () -> Void) {
        self.contentOffset = contentOffset
        self.scrollDownCompletion = scrollDownCompletion
    }
    
    func body(content: Content) -> some View {
        // Scale of View that will be returned
        var customScale: CGFloat = 1.0
        // Scale formula. It calculates the scale of the View.
        var scaleFormula: CGFloat {
            1 + contentOffset * 0.01
        }
        
        // Scale can't go lower from 100% scale
        if scaleFormula < 1.0 {
            customScale = 1.0
        // When it is 140% scale ENABLE COMPLETION HANDLER. It will run the next time the View will be at 100% scale
        } else if scaleFormula > 1.4 {
            // Scale of View can't go over 140%
            customScale = 1.4
            Self.isCompletionHandlerEnabled = true
        } else {
            customScale = scaleFormula
            // When it is in its initial position (100% scale), if user already swiped down to reload, RUN COMPLETION HANDLER
            if customScale == 1.0 && Self.isCompletionHandlerEnabled {
                Self.isCompletionHandlerEnabled = false
                scrollDownCompletion()
            }
        }
        return content
            .scaleEffect(customScale)
            .blur(radius: contentOffset / 40)
    }
}
