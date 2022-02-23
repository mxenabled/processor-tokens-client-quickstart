# README

## Setup

1. Install ruby v 3.1 [Ruby downloads page](https://www.ruby-lang.org/en/downloads/)
1. Install bundler
    ```
    gem install bundler -v 2.3.3
    ```

## Configuration

In order to run the app you'll need to provide the credentials given to you by MX.  To get credentials you can sign up for a free account at [dashboard.mx.com](https://dashboard.mx.com).

1. Copy `config/mx.yml.sample` to `config/mx.yml`
1. From dashboard.mx.com, copy the values for _API Key_ and _Client ID_ into `config/mx.yml`

```yaml
# config/mx.yml
MX_API_KEY: 'Copy your MX API Key from dashboard.mx.com'
MX_CLIENT_ID: 'Copy your MX Client ID from dashboard.mx.com'
```

## Running the app

This command will get the server running

1. Open a terminal, and navigate to the root of the project
1. `rails s` or `bin/rails s` will start the server
1. (when you're done) `Ctrl C` to stop the server
