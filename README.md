# R3JWT

**R3JWT** (Ruby on Rails React JWT) is a Template for a Rails application that is built as a backend API only application and utilizes ESBuild to mount a React application on top of it to serve as the front it.

This will be a boilerplate for JWT authentication between the Rails and React applications.

Once this Project is completed, it will be converted to a template that can be used for any rails application that needs to build APIs with authentication between the backend and the front end.

## How was this application built?

- To read more about how this application was built, or to build a similar application, please visit the [Wiki](https://github.com/AlyBadawy/R3JWT/wiki/)

## Running the application:

### Cloning the repository:

- Start by cloning the repository into your file system by issuing the following command:
  ```
  git clone git@github.com:AlyBadawy/R3JWT.git
  ```
- Once cloned, change directory to the cloned repository:
  ```
  cd R3JWT
  ```

### Installing The application:

#### Requirements:

- Before installing the dependencies, make sure you have the following requirements on your system:
  - Ruby v3.1.2
  - Bundler Gem installed
  - NodeJS, latest LTS version (currently v16.15.1)
  - Yarn
  - PostgreSQL

#### Installing dependencies

- Run the following commands:
  ```
  bundle install
  yarn install
  ```

#### Creating the database

- Run the following command to setup the database:
  ```
  rails db:setup
  ```

#### Testing the application:

- To test the application, run the following command:
  ```
  Yarn test
  ```
  This will run the following tests on your repository:
  - ESLint
  - Rubocop
  - Jest
  - Rspec
