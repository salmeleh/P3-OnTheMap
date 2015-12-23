//: ## Building URLs
//: In this playground, we will build URLs from **String** objects. Consider the following **String**: it represents a URL like the ones required in the *Flick Finder* app. Note: The API key used here is invalid; you will need to use your API key.
let desiredURLString: String = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=981c84261b3ba500d2aa1e5dc3bec9a3&text=baby+asian+elephant&format=json&nojsoncallback=1"

//: How can we build this URL in a clean, reusable way that is not hard-coded? Let's start by breaking it into its component parts. For example, here is the baseURL. This baseURL is always the same no matter the Flickr method.
let baseURL: String = "https://api.flickr.com/services/rest/"

//: Next are those pesky key-value pairs. Remember, by using key-value pairs, we are able to pass information along to an API in a structured way. A good way of organizing key-value pairs is by using a **Dictionary**. Note: I have substituted the spaces in "baby asian elephant" with "+" signs, but substituting with "%20" would also work (see this [w3schools article](http://www.w3schools.com/tags/ref_urlencode.asp) for an explanation). Of course, you cannot expect your users to know these nuance when they enter their searches, so will need to handle this in your code. Also, you may need to add extra key-value pairs!
let keyValuePairs = [
    "method": "flickr.photos.search",
    "api_key": "981c84261b3ba500d2aa1e5dc3bec9a3",
    "text": "baby+asian+elephant",
    "format": "json",
    "nojsoncallback": "1"
]

//: Now, let's build that **String**! Here I do it in a very ugly, manual way. But, for your code, I recommend that you write a function which iterates through the key-value pairs and creates the URL.
var ourURLString = "\(baseURL)"
ourURLString += "?method=" + keyValuePairs["method"]!
ourURLString += "&api_key=" + keyValuePairs["api_key"]!
ourURLString += "&text=" + keyValuePairs["text"]!
ourURLString += "&format=" + keyValuePairs["format"]!
ourURLString += "&nojsoncallback=" + keyValuePairs["nojsoncallback"]!

//: Now, you will need to use the **String** to build a URL and issue your request. Hint: Refer to the *Sleeping in the Library* code as a guide, and adapt it for your needs!
if ourURLString == desiredURLString {
    print("Success!")
} else {
    print("😓 Not quite...")
}
