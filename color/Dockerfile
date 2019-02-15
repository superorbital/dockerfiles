FROM library/ruby:2.5-alpine

RUN mkdir /app
WORKDIR /app

ADD https://github.com/krallin/tini/releases/download/v0.18.0/tini-static /tini
RUN chmod +x /tini

# Upgrade bundler to support read-only FS
RUN gem install bundler

COPY Gemfile* ./
RUN bundle install

COPY . ./

EXPOSE 80
ENV PATH="/app:${PATH}"

ENTRYPOINT ["/tini", "--"]
CMD ["./color"]

