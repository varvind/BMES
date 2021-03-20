# Project Summary

This project was created for CSCE 431 at Texas A&M University. TAMU BMES is the Biomedical Engineering Society at Texas A&M University. They engaged our class in order to create a web application that they will use to track member attendance at organization events.

# Project Language

This project was done entirely in Ruby on Rails, with some elements of HTML, CSS, and Javascript encorporated.

# Execution Instructions

- Ruby on Rails, Postgres, Yarn, Rake, and Node are all depedancies of this project and should be installed ahead of time.
- The necessary ruby version is 2.7.1 (Since, the latest version is 2.7.2, update that in the gem file). 
- From the command line run `git clone https://github.com/FA20-CSCE431/group-project-bmes-participation-tracker.git` in order to create a copy of the repository on your local machine.
- Ensure that you are using node version 10. If you are on a different version of node, install nvm and run `nvm use 10` (The necessary node version is >=10.13.0.)
- From the project directory execute `bundle install` to install all of the gem dependancies of the project.
- From the project directory execute `yarn install --check-files` in order to ensure that all dependancies are adequetly met.
- update the database.yml file with your username, password (these have been commented out). Run rails db:create 
- From the project directory execute `rails db:migrate` in order to migrate the database to your local machine.
- From the project directory execute `rails db:seed` in order to seed the database on your local machine. The default admin username is **admin@example.com** and the default admin password is **password**.
- From the project directory execute `rails server` in order to launch the web application.
- Open up a web browser and visit `localhost:3000` in order to view the website
# Heroku Deployment Instructions
- Create a Heroku account and create a new project in that account, give the project a name.
- Install the heroku client on your local machine
- From the project directory execute `heroku git:remote -a <app_name>`
- From the project directory execute `git push heroku master`
- Run heroku run rake db:migrate and heroku run rake db:seed

# Continuous Integreation
- On heroku, under the Deploy Tab, create a new pipeline
- Add a Heroku staging area to your new pipeline
- For deployment method, select GitHub and link to this repository
- Enable automatic deploys from master
- Create the new pipeline and every time code is merged to master, it will be deployed to a staging area in Heroku

# Security Testing
- Capybara Testing
  - Capybara Tests were run against all security risk areas including the administrator login areas
  - To run Capybara tests, execute `capybara` from the project directory
- Nikto Scanning
  - Nikto Scans were run against the web server to generate a comprehensive report of web application vulnerabilities
  - To run a Nikto scan, first install nikto on your computer. It can be found here: https://github.com/sullo/nikto
  - Once installed, to execute a scan run `nikto -h <target>`
  - **Warning:** Be very careful what you specify as the target of your scan. Running a Nikto Scan against a target you do not have permission to scan may be a federal crime
  - Learn more about Nikto Scans here: https://tools.kali.org/information-gathering/nikto
- SQL Mapping
  - SQL Map scans were run against all injectable DB parameters
  - To run SQLMap, first install it on your computer. It can be found here: https://github.com/sqlmapproject/sqlmap
  - Once installed, to test against an injectable input parameter, run: `sqlmap -u <target> --data='<input_fields>' -p <parameter_to_test> --banner`
  - To test against an injectable url parameter, run: `sqlmap -u <target> -p <Parameter_to_test>
  - **Warning:** Be very careful what you specify as the target of your scan. Attempting an SQL inject attack against a target you do not have permission to target most definitely is a federal crime, and you will be prosecuted
  - Learn more about SQLMap here: http://sqlmap.org/


