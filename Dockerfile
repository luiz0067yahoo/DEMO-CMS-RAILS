FROM ubuntu:20.04
#https://www.vultr.com/docs/installing-ruby-on-rails-on-ubuntu-20-04/
# Install dependencies
RUN echo "update"
RUN apt-get update 

RUN echo "Install Dependencies"
RUN apt-get install build-essential
RUN echo "Install libs"
RUN apt-get install libssl-dev zlib1g-dev sqlite3 libsqlite3-dev
RUN echo "Install libs"
RUN apt-get install git curl

RUN echo "Install Nodejs"
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
RUN sudo apt-get install nodejs
RUN node -v

RUN echo "Install Yarn"
RUN curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && sudo apt-get install yarn
RUN yarn -v

RUN echo "Install rbenv"
RUN curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash

RUN echo "====> Install rbenv"
RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc

RUN echo "====> Add rbenv to the path"
RUN echo  'eval "$(rbenv init - bash)"' >> ~/.bashrc
RUN exec $SHELL
RUN curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-doctor | bash 

RUN echo "====> Test that rbenv is installed correctly."
RUN curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-doctor | bash

RUN echo "====> Confirm audit results."
#RUN  Checking for 'rbenv' in PATH: /home/user/.rbenv/bin/rbenv
#RUN $ Checking for rbenv shims in PATH: OK

RUN echo "Install Ruby"
RUN echo "====> List the latest stable versions of Ruby."
RUN rbenv install -l

RUN echo "====> Install Ruby with the desired version."
RUN rbenv install 3.0.2 -v

RUN echo "====> Set global Ruby version"
RUN rbenv global 3.0.2

RUN echo "====> Confirm installation with similar output."
RUN  ruby -v

RUN echo "Installing Rails"
RUN echo "====> Install Rails using gem"
RUN gem install rails

RUN echo "====> Confirm successful installation."
RUN rails -v
RUN rm -rf ~/demo_cms_rails/
RUN git clone https://github.com/luiz0067yahoo/demo_cms_rails.git ~/demo_cms_rails/
RUN echo "load repository"
RUN bundle install
RUN echo "install dependencies"
RUN cd ~/demo_cms_rails/
RUN echo "RUN SERVER"
RUN rails server 
RUN echo "http://localhost:3000"