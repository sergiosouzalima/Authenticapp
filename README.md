Authenticapp
================

Website do demonstrate a simple login page.

Ruby on Rails
-------------

This application was building using:

- Ruby 2.2.1
- Rails 4.2.3

To know more about Rails [Installing Rails](http://railsapps.github.io/installing-rails.html).

What is it?
---------------

Autheticapp is a website built to demonstrate a simple way to deal with a user
login situation.

This application doesn't use any library (gem), such as Devise gem, to facilitate
the login process.

Here we offer 5 attempts to the user to login at this website. The user is
blocked if this 5 attempts is reached.

When the user is blocked a message warning to the user that he/she is blocked is
shown.

At each invalid login, the invalid login counter is increased by 1. Therefore,
the website records each attempt to enter using invalid email or password.

When the user enters using appropriate email and password, the invalid login
counter turns to zero.

Hence, the counter is prepared to be increased again by the next time, in case
the user make login mistakes.


**This website is just a drill.**
This website is an exercise.
Don't use it in production environment, but if you do it
and if it fits in your needs, please let me know :-)

**Commands**
There's a command that you can use to feed data to the database:

- $ rake db:seed

You can run tests using Rspec:

- $ rspec -fd

**The idea is not to use authentication gems**
Therefore, if you are interested, fork it, improved it and let me know how we can turn it for a
better use, still not using athentication gems or other kinds of authentication libraries.


Thanks.

