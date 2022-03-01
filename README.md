# Processor Tokens Demo App

This demo application is built in [ruby on rails](https://rubyonrails.org/). It will demonstrate the required steps that enable Payment Processing via one of our partners.

Here's an overview of the flow and concepts will be shown
1. Create an User via the MX API.
2. Connect the User to an Institution (like a bank) to create a Member (Connect Widget in _aggregation_ mode)
3. Verify the new Member's Accounts (Connect Widget in _verification_ mode)
4. Generate an _Authorization Code_ for a single verified Account
5. (What's next?) Share this code with one of our Partners to allow them access to that account's information.

Extra information about the above flow
- Users are an essential resource. We use their unique `guid` for nearly all of the API calls in this application.
- This app uses the Connect Widget to connect an User to an Institution, and to verify their accounts. While using the widget is not required, it handles a lot of complexity with connecting users to various Institutions. To learn more about using Connect see [how to get a connect url](https://docs.mx.com/api#connect_request_a_url) and [how to load the connect widget](https://docs.mx.com/connect/guides/introduction)

## Setup

1. Install ruby v 3.1 [Ruby downloads page](https://www.ruby-lang.org/en/downloads/)
2. Install bundler
```bash
$ gem install bundler -v 2.3.3
```
3. run `bundle install`

## Configuration

In order to run the app you'll need to provide the credentials given to you by MX.  To get credentials you can sign up for a free account at [dashboard.mx.com](https://dashboard.mx.com).

1. Copy `config/mx.yml.sample` to `config/mx.yml`
2. From dashboard.mx.com, copy the values for _API Key_ and _Client ID_ into `config/mx.yml`
```yaml
# config/mx.yml
MX_API_KEY: 'Copy your MX API Key from dashboard.mx.com'
MX_CLIENT_ID: 'Copy your MX Client ID from dashboard.mx.com'
```

## Running the app

This command will get the server running

1. Open a terminal, and navigate to the root of the project
2. `rails s` or `bin/rails s` will start the server
3. (when you're done) `Ctrl C` to stop the server
