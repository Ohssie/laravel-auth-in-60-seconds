## manual-laravel-auth
Laravel provides developers with the option of handling User authentication in their apps [manually](https://laravel.com/docs/5.3/authentication#authenticating-users). This bash script speeds up the process of bootstrapping the views and controller needed for manual User authentication in Laravel.

## Dependencies
* [Laravel Collectives](https://laravelcollective.com/docs/5.3/html) for handling form operations
* [Laravel](https://laravel.com/) version > 5.0

## How to use
Copy and paste the script at the root of your Laravel app and run it like so: **./auth.sh**

## What happens?
* A Laravel controller is created for you in **app/Http/Controllers** called **AuthenticationController**.
* A directory for the authentication views is created in **resources/views** called **authentication**. This directory contains a master blade file, as well as the login and register views.
* **GET** and **POST** routes for authentication are generated for you and placed in a **auth-routes.php** file and can be found in the app directory of your Laravel project. Copy and paste them in your routes file, and you're good to go.

## Implementation
The **AuthenticationController** contains method implementations for returning the login and register views, as well as implementations for logging in and registering new users.

The controller implementation is based on the default migration Laravel provides. If the requirements for your app differs, you can make changes to the migration files and also the controller. This script simply aims to speed up the process of manual auth implementation in Laravel
