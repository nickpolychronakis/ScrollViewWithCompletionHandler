# ScrollViewWithCompletionHandler

A ScrollView with a header View, which executes a completion handler when the user swipes down and release.

![Example gif](Example.gif)


To download the Swift Package, on Xcode go to File -> Swift Packages -> Add Package Dependency and write "https://github.com/nickpolychronakis/ScrollViewWithCompletionHandler"

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

Parameter name | Details
---------------|---------
header: | A View that will be on top of ScrollView and will animate when you scroll.
scrollDownCompletion: | A completion handler that will be executed when the user swipe down the scroll view and release it.
content: | Content Views of ScrollView.
    

**ToDo:**
- [ ] Give the option to the developer to remove scroll indicators.


<a href="https://www.buymeacoffee.com/NickPolychronakis" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" style="height: 51px !important;width: 217px !important;" ></a>

If you like it, consider to buy me a coffee! Because if I continue this way, I will pay more for coffees than for food!
