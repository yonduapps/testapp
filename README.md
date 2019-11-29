# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


Instructions:

1.) bundle install
2.) rspec


Unfortunately, I'm not able to finish the full requirements. This rail project purely contains rendered results only.

Finished requirements are the following:

* CRUD functionality for the book
* Book model (id, ISBN, title, date published) and Associate relation for Genre/s and Author/s
* Books may contain multiple authors.
* Books may be categorized to multiple genre (e.g., fiction, science, philosophy, self-help, etc)
* Add migrations for the tables, fields and FK relations
* Validators for all create, update and delete functionalities (e.g., ISBN format should be valid)
* Separate module with CRUD functionality for genre (not necessarily paginated)
* Implement Rest API
* The application should be unit-testable (i.e., RSpec)

Unfinished requirements are the following:

* Use VueJS framework for the frontend (Using Vuex is a plus)
* No login functionality
* Functionality to delete multiple books.
* Add seeders for the dummy data (used scripted dummydata for `test` environment)