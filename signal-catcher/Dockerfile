FROM library/ruby:2.6-slim

ADD https://github.com/krallin/tini/releases/download/v0.18.0/tini-static /tini
RUN chmod +x /tini

# Upgrade bundler to support read-only FS
RUN gem install bundler

WORKDIR /app

COPY Gemfile* ./
RUN bundle install

COPY . ./

EXPOSE 80

# ENTRYPOINT ["/tini", "--"]
CMD ["./signal-catcher"]

