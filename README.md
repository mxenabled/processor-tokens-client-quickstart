# Processor Tokens Demo App

This demo application is built in [ruby on rails][RoR] and uses the integration environment. It will demonstrate how 
to generate an _authorization code_ which enables sharing 
account data with one of our Processing Partners.

Here's an overview of the flow and concepts will be shown
1. Create a user via the MX API.
2. Connect the user to an institution, like a bank, using MXconnect.
3. Verify the new member's accounts using MXconnect.
4. Generate an authorization code for a single verified account.
5. (What's next?) Share the authorization code with one of our partners to allow them access to that account's information.

Extra information about the above flow
- Users are an essential resource. We use their unique `guid` for nearly all of
the API calls in this application.
- This app uses MXconnect to connect a user to an institution, and to
verify their accounts. While using the widget is not required, it handles a lot
of complexity with connecting users to various Institutions. To learn more about
using MXconnect see [how to get an MXconnect URL][request-a-url] and
[how to load MXconnect][guides-intro].

## Installation

You can skip to _Configuration_ if you're going to run the app in Docker

1. Install ruby v 3.1 [Ruby downloads page][Ruby]
2. Install bundler
```bash
$ gem install bundler -v 2.3.6
```
3. run `bundle install`

## Configuration

In order to run the app you'll need to provide the credentials given to you by
MX. To get credentials you can sign up for a free account at
[dashboard.mx.com][dashboard].

To configure the app with your MX credentials
1. Create a `.env` file at the root of the demo
2. Copy the contents of `.env.sample` to your new `.env`
3. From [dashboard.mx.com][dashboard], copy the values for _API Key_ and _Client ID_ into
`.env`
```yaml
# .env example values
MX_API_KEY=abcd1234
MX_CLIENT_ID=abcd1234
```

In order to use processor tokens, your MX client must have these features enabled
* Account Verification
* Processor API

## Running the app

### Without Docker

1. Open a terminal, and navigate to the root of the project
2. `rails s` or `bin/rails s` will start the server
3. (when you're done) `Ctrl C` to stop the server
4. Open the app in [your browser][localhost] to begin

### Run in Docker

Copy and Paste
1. `docker build -t mx-token-demo .`
2. `docker run -p 3000:3000 --env-file .env mx-token-demo`

Or customize your image name
1. `docker build -t <YOUR_IMAGE_NAME> .`
2. `docker run -p 3000:3000 --env-file .env <YOUR_IMAGE_NAME>`

Open the app in [your browser][localhost] to begin

[RoR]: https://rubyonrails.org
[Ruby]: https://www.ruby-lang.org/en/downloads
[dashboard]: https://dashboard.mx.com
[request-a-url]: https://docs.mx.com/api#connect_request_a_url
[guides-intro]: https://docs.mx.com/connect/guides/introduction
[localhost]: http://localhost:3000