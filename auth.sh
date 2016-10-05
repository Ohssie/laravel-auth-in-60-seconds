#!/bin/bash

authControllerFile="./app/Http/Controllers/AuthenticationController.php"
masterBlade="master.blade.php"
masterBladeFile="./resources/views/authentication/master.blade.php"
loginBlade="login.blade.php"
loginBladeFile="./resources/views/authentication/login.blade.php"
registerBlade="register.blade.php"
registerBladeFile="./resources/views/authentication/register.blade.php"

function makeController {
    php artisan make:controller AuthenticationController
}

function writeAuthenticationBoilerPlateToController {
echo "<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use App\Http\Requests;
use Auth;
use App\User;

class AuthenticationController extends Controller
{
    public function login() {
        return view('authentication.login');
    }

    public function register() {
        return view('authentication.register');
    }

    public function attemptLogin(Request \$request) {
        \$email = \$request->email;
        \$password = \$request->password;

        if (Auth::attempt(['email' => \$email, 'password' => \$password])) {
            // Change this to suit your app needs
            return redirect('/');
        } else {
            return back()
                ->withInput()
                ->with('error', 'email and password do not match!');
        }
    }

    public function attemptRegister(Request \$request) {
        \$this->validate(\$request, [
            'name' => 'required',
            'password' => 'required',
            'email' => 'required|unique:users'
        ]);

        \$user = new User();

        \$user->name = \$request->name;
        \$user->email = \$request->email;
        \$user->password = bcrypt(\$request->password);

        if(\$user->save()) {
            if (Auth::attempt(['email' => \$request->email, 'password' => \$request->password])) {
                // Change this to suit your app needs
                return redirect('/');
            }
        } else {
            return back()
                ->withInput()
                ->with('error', 'cannot register user. Try again!');
        }
    }

    public function logout() {
        Auth::logout();
        // Change this to suit your app needs
        return redirect('/');
    }
}" > $authControllerFile
}

function createAuthViewFolder {
    mkdir ./resources/views/authentication 2> /dev/null
    if [[ $? -eq 0 ]]; then
        echo "-$(tput setaf 3)resources/views/authentication directory created$(tput sgr0)"
    fi
}

function createMasterView {
echo "<!DOCTYPE html>
<html lang=\"en\">
    <head>
        <meta charset=\"utf-8\">
        <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">
        <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">

        <title>Title</title>
    </head>

    <style type=\"text/css\">
        @import url(http://weloveiconfonts.com/api/?family=fontawesome);
        @import url(http://fonts.googleapis.com/css?family=Open+Sans:400,700);
        [class*=\"fontawesome-\"]:before {
          font-family: 'FontAwesome', sans-serif;
        }

        * {
          box-sizing: border-box;
        }

        html {
          height: 100%;
        }

        body {
          background-color: #2c3338;
          color: #606468;
          font: 400 0.875rem/1.5 \"Open Sans\", sans-serif;
          margin: 0;
          min-height: 100%;
        }

        a {
          color: #eee;
          outline: 0;
          text-decoration: none;
        }
        a:focus, a:hover {
          text-decoration: underline;
        }

        input {
          border: 0;
          color: inherit;
          font: inherit;
          margin: 0;
          outline: 0;
          padding: 0;
          -webkit-transition: background-color .3s;
          transition: background-color .3s;
        }

        .site__container {
          -webkit-box-flex: 1;
          -webkit-flex: 1;
              -ms-flex: 1;
                  flex: 1;
          padding: 3rem 0;
        }

        .form input[type=\"password\"], .form input[type=\"text\"], .form input[type=\"submit\"] {
          width: 100%;
        }
        .form--login {
          color: #fff;
        }
        .form--login label,
        .form--login input[type=\"text\"],
        .form--login input[type=\"password\"],
        .form--login input[type=\"submit\"] {
          border-radius: 0.25rem;
          padding: 1rem;
        }
        .form--login label {
          background-color: #363b41;
          border-bottom-right-radius: 0;
          border-top-right-radius: 0;
          padding-left: 1.25rem;
          padding-right: 1.25rem;
        }
        .form--login input[type=\"text\"], .form--login input[type=\"password\"] {
          background-color: #3b4148;
          border-bottom-left-radius: 0;
          border-top-left-radius: 0;
        }
        .form--login input[type=\"text\"]:focus, .form--login input[type=\"text\"]:hover, .form--login input[type=\"password\"]:focus, .form--login input[type=\"password\"]:hover {
          background-color: #434A52;
        }
        .form--login input[type=\"submit\"] {
          background-color: #ea4c88;
          color: #eee;
          font-weight: bold;
          text-transform: uppercase;
        }
        .form--login input[type=\"submit\"]:focus, .form--login input[type=\"submit\"]:hover {
          background-color: #d44179;
        }
        .form__field {
          display: -webkit-box;
          display: -webkit-flex;
          display: -ms-flexbox;
          display: flex;
          margin-bottom: 1rem;
        }
        .form__input {
          -webkit-box-flex: 1;
          -webkit-flex: 1;
              -ms-flex: 1;
                  flex: 1;
        }

        .align {
          -webkit-box-align: center;
          -webkit-align-items: center;
              -ms-flex-align: center;
                  align-items: center;
          display: -webkit-box;
          display: -webkit-flex;
          display: -ms-flexbox;
          display: flex;
          -webkit-box-orient: horizontal;
          -webkit-box-direction: normal;
          -webkit-flex-direction: row;
              -ms-flex-direction: row;
                  flex-direction: row;
        }

        .hidden {
          border: 0;
          clip: rect(0 0 0 0);
          height: 1px;
          margin: -1px;
          overflow: hidden;
          padding: 0;
          position: absolute;
          width: 1px;
        }

        .text--center {
          text-align: center;
        }

        .grid__container {
          margin: 0 auto;
          max-width: 20rem;
          width: 90%;
        }
    </style>

    <body class=\"align\">
        <div class=\"site__container\">
            <div class=\"grid__container\">
                @yield('auth_view')
            </div>
        </div>
    </body>
</html>
" > $masterBladeFile
    if [[ $? -eq 0 ]]; then
        echo "-$(tput setaf 3)$masterBlade file created in authentication view directory$(tput sgr0)"
    fi
}

function createLoginView {
echo "@extends('authentication.master')

@section('auth_view')
    {{Form::open(['route' => 'attempt_login', 'method' => 'POST', 'class' => 'form form--login'])}}
        @if(session('error'))
            <div style=\"text-align: center;\">
                <h4 style=\"display: inline-block;\">
                    {{ session('error') }}
                </h4>
            </div>
        @endif

        @if (count(\$errors) > 0)
            <div class=\"col-md-4\">
                <ul>
                    @foreach (\$errors->all() as \$error)
                        <h4 style=\"display: inline-block;\">{{ \$error }}</h4>
                    @endforeach
                </ul>
            </div>
        @endif

        <div class=\"form__field\">
            <label class=\"fontawesome-user\" for=\"login__email\"><span class=\"hidden\">Email Address</span></label>
            <input id=\"login__email\" type=\"text\" class=\"form__input\" placeholder=\"Email Address\" required name=\"email\" value=\"{{old('email')}}\">
        </div>

        <div class=\"form__field\">
            <label class=\"fontawesome-lock\" for=\"login__password\"><span class=\"hidden\">Password</span></label>
            <input id=\"login__password\" type=\"password\" class=\"form__input\" placeholder=\"Password\" required name=\"password\">
        </div>

        <div class=\"form__field\">
            {{Form::submit('Sign In', ['style' => 'background-color:#31a4d9;'])}}
        </div>

        <div style=\"text-align: center;\">
            <a href=\"{{ route('register') }}\" style=\"display: inline-block;\">
                New here? Create an account
            </a>
        </div>
    {{Form::close()}}
@stop
" > $loginBladeFile
    if [[ $? -eq 0 ]]; then
        echo "-$(tput setaf 3)$loginBlade file created in authentication view directory$(tput sgr0)"
    fi
}

function createRegisterView {
echo "@extends('authentication.master')

@section('auth_view')
    {{Form::open(['route' => 'attempt_register', 'method' => 'POST', 'class' => 'form form--login'])}}
        @if(session('error'))
            <div style=\"text-align: center;\">
                <h4 style=\"display: inline-block;\">
                    {{ session('error') }}
                </h4>
            </div>
        @endif

        @if (count(\$errors) > 0)
            <div class=\"col-md-4\">
                <ul>
                    @foreach (\$errors->all() as \$error)
                        <h4 style=\"display: inline-block;\">{{ \$error }}</h4>
                    @endforeach
                </ul>
            </div>
        @endif

        <div class=\"form__field\">
            <label class=\"fontawesome-user\" for=\"login__username\"><span class=\"hidden\">Name</span></label>
            <input id=\"login__username\" type=\"text\" class=\"form__input\" placeholder=\"Name\" required name=\"name\" value=\"{{old('name')}}\">
        </div>

        <div class=\"form__field\">
            <label class=\"fontawesome-user\" for=\"login__email\"><span class=\"hidden\">Email Address</span></label>
            <input id=\"login__email\" type=\"text\" class=\"form__input\" placeholder=\"Email Address\" required name=\"email\" value=\"{{old('email')}}\">
        </div>

        <div class=\"form__field\">
            <label class=\"fontawesome-lock\" for=\"login__password\"><span class=\"hidden\">Password</span></label>
            <input id=\"login__password\" type=\"password\" class=\"form__input\" placeholder=\"Password\" required name=\"password\">
        </div>

        <div class=\"form__field\">
            {{Form::submit('Sign Up')}}
        </div>

        <div style=\"text-align: center;\">
            <a href=\"{{ route('login') }}\" style=\"display: inline-block;\">
                Have an account? Log in
            </a>
        </div>
    {{Form::close()}}
@stop
" > $registerBladeFile
    if [[ $? -eq 0 ]]; then
        echo "-$(tput setaf 3)$registerBlade file created in authentication view directory$(tput sgr0)"
    fi
}

function createRoutes {
echo "Route::get('login', 'AuthenticationController@login')->name('login');
Route::post('login', 'AuthenticationController@attemptLogin')->name('attempt_login');
Route::get('register', 'AuthenticationController@register')->name('register');
Route::post('register', 'AuthenticationController@attemptRegister')->name('attempt_register');
Route::get('logout', 'AuthenticationController@logout')->name('logout');
" > ./app/auth-routes.php
    if [[ $? -eq 0 ]]; then
        echo "-$(tput setaf 3)Check app/auth-routes.php for corresponding authentication routes$(tput sgr0)"
    fi
}

if [[ -e $authControllerFile ]]; then
    echo -e "$(tput bold)Overwrite content of AuthenticationController with default?(yes/no)$(tput sgr0): \c"
    read

    if [[ ${REPLY,,} = 'yes' || ${REPLY,,} = 'y' ]]; then
        writeAuthenticationBoilerPlateToController
        createAuthViewFolder
    elif [[ ${REPLY,,} = 'no' || ${REPLY,,} = 'n' ]]; then
        echo "*AuthenticationController untouched"
        createAuthViewFolder
    else
        echo "Invalid input..."
        exit 1
    fi
else
    makeController
    writeAuthenticationBoilerPlateToController
    createAuthViewFolder
fi

if [[ -e $masterBladeFile ]]; then
    echo -e "$(tput bold)$masterBlade exists. Overwrite content with default?(yes/no)$(tput sgr0): \c"
    read

    if [[ ${REPLY,,} = 'yes' || ${REPLY,,} = 'y' ]]; then
        createMasterView
    elif [[ ${REPLY,,} = 'no' || ${REPLY,,} = 'n' ]]; then
        echo "*$masterBlade file untouched"
    else
        echo "Invalid input..."
        exit 1
    fi
else
    createMasterView
fi

if [[ -e $loginBladeFile ]]; then
    echo -e "$(tput bold)$loginBlade exists. Overwrite content with default?(yes/no)$(tput sgr0): \c"
    read

    if [[ ${REPLY,,} = 'yes' || ${REPLY,,} = 'y' ]]; then
        createLoginView
    elif [[ ${REPLY,,} = 'no' || ${REPLY,,} = 'n' ]]; then
        echo "*$loginBlade file untouched"
    else
        echo "Invalid input..."
        exit 1
    fi
else
    createLoginView
fi

if [[ -e $registerBladeFile ]]; then
    echo -e "$(tput bold)$registerBlade exists. Overwrite content with default?(yes/no)$(tput sgr0): \c"
    read

    if [[ ${REPLY,,} = 'yes' || ${REPLY,,} = 'y' ]]; then
        createRegisterView
    elif [[ ${REPLY,,} = 'no' || ${REPLY,,} = 'n' ]]; then
        echo "*$registerBlade file untouched"
    else
        echo "Invalid input..."
        exit 1
    fi
else
    createRegisterView
fi

createRoutes
