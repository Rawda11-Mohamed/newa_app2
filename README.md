# Route News

A Flutter news reader for UAE headlines, with English and Arabic interfaces,
light and dark themes, category feeds, search, and links to the original
publisher articles.

## News API

The app uses [NewsAPI.org](https://newsapi.org/) and reads its JSON responses.
Its free Developer plan is suitable for learning and development and requires
a free API key. Create a key on NewsAPI.org. Since a key in a mobile app can
be extracted, use this setup only for learning; a published app should make
API requests through a backend. The app displays headlines and summaries;
full articles open on the publisher's website.

## Run

Create an API key on NewsAPI.org before running the app.

In VS Code, press **F5**, choose **Route News (NewsAPI key)**, and enter your
key when prompted. The prompt does not save the key in the project.

Alternatively, run from a terminal:

```sh
flutter pub get
flutter run --dart-define=NEWS_API_KEY=your_api_key
```

Replace `your_api_key` with your key. Do not commit your real key to source
control.

News requires an internet connection and a valid API key. If the API is
unavailable, the screens show a retry action rather than sample or stale
headlines.
