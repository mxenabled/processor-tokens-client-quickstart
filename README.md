# Processor Tokens Demo App

This demo application is built in [ruby on rails][RoR]. It will demonstrate the
required steps that enable Payment Processing via one of our partners.

Here's an overview of the flow and concepts will be shown
1. Create a user via the MX API
2. Connect the user to an institution, like a bank, using the connect widget
3. Verify the new member's accounts using the connect widget
4. Generate an authorization code for a single verified account
5. (What's next?) Share the authorization code with one of our partners to 
allow them access to that account's information.

Extra information about the above flow
- Users are an essential resource. We use their unique `guid` for nearly all of
the API calls in this application.
- This app uses the Connect Widget to connect a user to an institution, and to
verify their accounts. While using the widget is not required, it handles a lot
of complexity with connecting users to various Institutions. To learn more about
using the connect widget see [how to get a connect widget url][request-a-url] and
[how to load the connect widget][guides-intro].

## Setup

You can skip to _Configuration_ if you're going to run the app in Docker

1. Install ruby v 3.1 [Ruby downloads page][Ruby]
2. Install bundler
```bash
$ gem install bundler -v 2.3.3
```
3. run `bundle install`

## Configuration

In order to run the app you'll need to provide the credentials given to you by
MX. To get credentials you can sign up for a free account at
[dashboard.mx.com][dashboard].

1. Copy `.env.sample` to `.env`
2. From dashboard.mx.com, copy the values for _API Key_ and _Client ID_ into
`.env`
```yaml
# .env example values
MX_API_KEY=abcd1234
MX_CLIENT_ID=abcd1234
```

## Running the app

### Without Docker

1. Open a terminal, and navigate to the root of the project
2. `rails s` or `bin/rails s` will start the server
3. (when you're done) `Ctrl C` to stop the server

### Run in Docker

1. `docker build .`
2. `docker run -p 3000:3000 --env-file .env «your-image-tag-or-hash»`

[RoR]: https://rubyonrails.org
[Ruby]: https://www.ruby-lang.org/en/downloads
[dashboard]: https://dashboard.mx.com
[request-a-url]: https://docs.mx.com/api#connect_request_a_url
[guides-intro]: https://docs.mx.com/connect/guides/introduction