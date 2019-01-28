FROM library/ruby:2.5-alpine

RUN mkdir /app
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install
COPY . /app
EXPOSE 80

ADD https://github.com/krallin/tini/releases/download/v0.18.0/tini-static /tini
RUN chmod +x /tini

ENTRYPOINT ["/tini", "--"]
CMD ["./color.rb"]

