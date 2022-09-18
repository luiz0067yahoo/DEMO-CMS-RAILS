#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FROM ubuntu:20.04

#RUN apt-get install --yes postgresql-client   
#RUN apt-get install --yes mysql-server mysql-client libmysqlclient-dev
#RUN mysql_secure_installation       

RUN ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime   
RUN echo "America/Sao_Paulo" > /etc/timezone     
RUN export TZ=America/Sao_Paulo   

RUN apt-get update && apt-get upgrade && apt-get dist-upgrade -y   
RUN apt-get install --yes build-essential   
RUN apt-get install --yes apt-utils   
RUN apt-get install --yes libssl-dev zlib1g-dev sqlite3 libsqlite3-dev     
RUN apt-get install --yes git curl
RUN apt-get install --yes software-properties-common   

RUN echo "Install Node"
RUN apt-get --yes  install nodejs
RUN ln -sf /usr/bin/nodejs /usr/local/bin/node   
RUN node -v

#RUN curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg |  apt-key add -
#RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
#RUN apt-get update && apt-get install --yes yarn  

#########################################################################################################
RUN apt-get update \
 && apt-get install -y \   
      autoconf \
      automake \   
      bison \
      g++ \   
      gawk \
      imagemagick \
      libbz2-dev \
      libcurl4-openssl-dev \
      libevent-dev \
      libffi-dev \
      libgdbm-dev \
      libglib2.0-dev \
      libgmp-dev \
      libjpeg-dev \
      libmagickcore-dev \
      libmagickwand-dev \
      libmysqlclient-dev \
      libncurses-dev \
      libncurses5-dev \
      libpq-dev \
      libreadline-dev \
      libsqlite3-dev \
      libssl-dev \
      libxml2-dev \
      libxslt-dev \
      libyaml-dev \
      make \
      patch \
      sqlite3 \   
      zlib1g-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*
RUN groupadd -r ubuntu -g 433 && \
    useradd -u 431 -r -g ubuntu -s /sbin/nologin -c "Docker image user" ubuntu
RUN mkdir -p /home/ubuntu/
RUN chmod 777 /home/ubuntu/
USER ubuntu

RUN curl -sSL https://rvm.io/mpapis.asc | gpg --import -
RUN curl -sSL https://rvm.io/pkuczynski.asc | gpg --import -
RUN mkdir -p /usr/src/app && chmod 777 /usr/src/app

# Install RVM
RUN set -ex && \
  for key in \
     409B6B1796C275462A1703113804BB82D39DC0E3 \
     7D2BAF1CF37B13E2069D6956105BD0E739499BDB \
  ; do \
      gpg --batch --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys "$key" || \
      gpg --batch --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys "$key" || \
      gpg --batch --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key" ; \
  done
  
RUN mkdir -p /home/ubuntu/.rvm/gemsets/
RUN rm -rf /home/ubuntu/.rvm/gemsets/global.gems
RUN touch /home/ubuntu/.rvm/gemsets/global.gems
RUN chmod 777 /home/ubuntu/.rvm/gemsets/global.gems
RUN curl -sSL https://get.rvm.io | bash -s -- --autolibs=read-fail stable \
 && echo 'bundler' >> /home/docker/.rvm/gemsets/global.gems \
 && echo 'rvm_silence_path_mismatch_check_flag=1' >> ~/.rvmrc
RUN rvm group add rvm ubuntu    

SHELL ["/bin/bash", "-lc"]
CMD ["/bin/bash", "-l"]


RUN rvm get stable --auto-dotfiles
RUN fix-permissions system

# Install Rubies
#RUN rvm install "ruby-2.5.1" 
#RUN rvm install 2.6.9 
#RUN rvm alias create 2.6 ruby-2.6.9 
#RUN && rvm install 2.7.5 
#RUN && rvm alias create 2.7 ruby-2.7.5 
#RUN && rvm install 3.0.3 
#RUN && rvm alias create 3.0 ruby-3.0.3 
#RUN rvm install 3.1.1 
RUN rvm install ruby-3.1.1 
RUN rvm alias create 3.1 ruby-3.1.1 
RUN rvm use --default 3.1.1
#############################################################################################################################

RUN if grep -q secure_path /etc/sudoers; then sh -c "echo export rvmsudo_secure_path=1 >> /etc/profile.d/rvm_secure_path.sh" && echo Environment variable installed; fi
RUN rvm install ruby
RUN rvm --default use ruby
  
RUN rm -rf ~/demo_cms_rails/
RUN git clone https://github.com/luiz0067yahoo/demo_cms_rails.git /home/ubuntu/demo_cms_rails/
RUN cd ~/demo_cms_rails/    
RUN ruby -v   
RUN gem install bundler 
RUN gem install rails  
#RUN gem install mysql2
RUN rails -v
RUN echo "load repository"
#RUN bundle install
RUN bundle install --without production 
RUN echo "install dependencies"
RUN echo "RUN SERVER" 
RUN rails server -p 3000
# Configure the main process to run when running the image 
#CMD ["rails", "server", "-b", "0.0.0.0"] 
RUN echo "http://localhost:3000"  
#RUN bundle config --global frozen 0  
#USER root
#RUN chmod 777 /home/ubuntu/demo_cms_rails/  
#USER ubuntu    
#USER root  

EXPOSE 3000

RUN echo "====> Confirm successful installation."

#sudo docker build -t demo_cms_rails . 
#sudo  docker run -d -p 3000:3000 demo_cms_rails
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
