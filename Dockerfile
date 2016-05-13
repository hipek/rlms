FROM ruby:2.3.0
ENV HOME /opt/rlms
RUN mkdir $HOME
WORKDIR $HOME
ADD Gemfile* ./
RUN bundle install
ADD . ./
EXPOSE 8080
CMD bash -c 'bundle exec rake db:migrate && bundle exec rails start -p 8080 -o 0.0.0.0'
