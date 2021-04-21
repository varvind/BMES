# Project Summary

This project was created for CSCE 431 at Texas A&M University. TAMU BMES is the Biomedical Engineering Society at Texas A&M University. They engaged our class in order to create a web application that they will use to track member attendance and points at organization events.

# Project Language

This project was done entirely in Ruby on Rails, with some elements of HTML, CSS, and Javascript encorporated.

# Execution Instructions

- Ruby on Rails, Postgres, Yarn, Rake, and Node are all depedancies of this project and should be installed ahead of time.
- The necessary ruby version is 2.7.1 (Since, the latest version is 2.7.2, update that in the gem file). 
- From the command line run `git clone https://github.com/varvind/BMES.git` in order to create a copy of the repository on your local machine.
- Ensure that node.js is installed using `sudo apt install nodejs`
- From the project directory execute `bundle install` to install all of the gem dependancies of the project.
- From the project directory execute `yarn install --check-files` in order to ensure that all dependancies are adequetly met.
- update the database.yml file with your username, password (these have been commented out). Run rails db:create 
- From the project directory execute `rails db:migrate` in order to migrate the database to your local machine.
- From the project directory execute `rails db:seed` in order to seed the database on your local machine. The default admin username is **admin@example.com** and the default admin password is **password**.
- From the project directory execute `rails server` in order to launch the web application.
- Open up a web browser and visit `localhost:3000` in order to view the website
# Heroku Deployment Instructions
- Create a Heroku account and create a new project in that account, give the project a name.
- Click on 'new' and 'new pipeline'
- Here you will see 3 different parts of the pipeline: Review Apps, Staging and Production
- Review apps are isolated builds that are automatically created when a pull request is created on github, and the main intention of this is to test your feature on a production build of the website
- Staging app is where a build of the develop branch is available. This is useful for making sure the integration of features is smooth and working as expected
- Production app is where our final and customer build of the application is available

# Testing using RSpec
- Once you have gotten your application set up, run `gem install rspec` in your project directory
- To test everything, run `rspec spec` from the project root directory
- To test an individual file, run `rspec spec/*test file*.rb` from the root, and you can select a specific file to run

# Continuous Integration
- This is implemented using github actions
- In the code base, you can look at the ".github/workflows" folder to see more information about the jobs
- On github, if you click on the actions job, if you have either pushed or created a pull request for a branch, then a job would have kicked off
- There are a couple of different jobs that we have: Build/Test, Checkstyle, Auto Merge from Develop to Master, and Deploy

# Continuous Development
- On heroku, under the Deploy Tab, create a new pipeline
- Add a Heroku staging area to your new pipeline
- For deployment method, select GitHub and link to this repository
- Enable automatic deploys from master
- Create the new pipeline and every time code is merged to master, it will be deployed to a staging area in Heroku

# Security Testing
- Brakeman
  - Brakeman scans are run to test security vulnerabilities in the code base
  - To run Brakeman tests, execute `brakeman` from the project directory

# Active Admin
- Useful information about Active Admin Gem : https://activeadmin.info/

# Video Demonstration
- A link to the video that goes over all of these things is available here: https://drive.google.com/file/d/1njXSXP6Pd2qdS88XFGH2-Mp-oN98VcBo/view?usp=sharing


