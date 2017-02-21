Simple Swift package to launch simple asynchronous network request

= Context =
On Linux, as of Swift 3.02, URLSession.shared is not yet available in Foundation. Hence, it is somewhat difficult to quickly send an http request.

This package simply rely on DispatchQueue to asynchronously use synchronous calls, that are available.
