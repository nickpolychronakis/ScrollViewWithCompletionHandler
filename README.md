# ScrollViewWithCompletionHandler

A ScrollView with a header View, which executes a completion handler when the user swipes down and release.

![Example gif](Example.gif)

**Example:**

```
ScrollViewWithCompletionHandler(header: {
    Text("Header View")
}, scrollDownCompletion: {
    print("Completion Handler, runs when the user swipes down and release.")
}) {
    Text("Here is the content of the ScrollView")
    Text("Row 1")
    Text("Row 2")
}
```

>- Parameters:
    - header: A View that will be on top of ScrollView and will animate when you scroll.
    - scrollDownCompletion: A completion handler that will be executed when the user swipe down the scroll view and release it.
    - content: Content Views of ScrollView.
    

**ToDo:**
- [ ] Give the option to the developer to remove scroll indicators.


***Photos by Charles Deluvio on Unsplash***
