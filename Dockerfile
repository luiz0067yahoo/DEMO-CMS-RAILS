FROM ubuntu:20.04
#https://www.vultr.com/docs/installing-ruby-on-rails-on-ubuntu-20-04/
RUN DEBIAN_FRONTEND=noninteractive TZ=America/Sao_Paulo apt-get -y install tzdata
RUN apt-get update && apt-get upgrade && apt-get dist-upgrade -y
RUN apt-get install --yes build-essential 
RUN apt-get install --yes apt-utils
RUN apt-get install --yes libssl-dev zlib1g-dev sqlite3 libsqlite3-dev
RUN apt-get install --yes git curl

#RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
RUN apt-get --yes  install nodejs
RUN ln -sf /usr/bin/nodejs /usr/local/bin/node
RUN node -v

#RUN curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg |  apt-key add -
#RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
#RUN apt-get update && apt-get install --yes yarn

RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN curl -sSL https://get.rvm.io | bash -s stable
RUN usermod -a -G rvm 'whoami'

RUN if grep -q secure_path /etc/sudoers; then sh -c "echo export rvmsudo_secure_path=1 >> /etc/profile.d/rvm_secure_path.sh" && echo Environment variable installed; fi
RUN rvm install ruby
RUN rvm --default use ruby

#RUN curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash
#RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
#RUN echo 'eval "$(rbenv init - bash)"' >> ~/.bashrc
#RUN exec $SHELL

#RUN curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-doctor | bash
#RUN rbenv install -l
#RUN rbenv install 3.0.2 -v
#RUN rbenv global 3.0.2

RUN ruby -v
RUN gem install bundler
RUN gem install rails
RUN rails -v



#RUN apt-get install --yes postgresql-client
RUN apt-get install --yes mysql-server mysql-client libmysqlclient-dev
RUN mysql_secure_installation
RUN gem install mysql2

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]
RUN echo "====> Confirm successful installation."
RUN rails -v
RUN rm -rf ~/demo_cms_rails/
#RUN git config --global user.email "${GH_USERNAME}@users.noreply.github.com"
#RUN git config --global user.name "${GH_USERNAME}"
RUN git clone https://github.com/luiz0067yahoo/demo_cms_rails.git ~/demo_cms_rails/
RUN echo "load repository"
RUN bundle install
RUN echo "install dependencies"
RUN cd ~/demo_cms_rails/
RUN echo "RUN SERVER"
RUN rails server -p 3000
RUN echo "http://localhost:3000"
#cd ~
#rm -rf ~/demo_cms_rails/
#git clone https://github.com/luiz0067yahoo/demo_cms_rails.git ~/demo_cms_rails/
#sudo chmod 777 ~/demo_cms_rails/
#cd ~/demo_cms_rails/
#sudo docker build -t demo_cms_rails .
#sudo  docker run -d -p 3000:3000 demo_cms_rails
