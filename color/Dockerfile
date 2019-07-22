FROM library/ruby:2.6-slim

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends curl
RUN curl -sSLo /tini https://github.com/krallin/tini/releases/download/v0.18.0/tini-static
RUN chmod +x /tini

# Upgrade bundler to support read-only FS
RUN gem install bundler

COPY Gemfile* ./
RUN bundle install

COPY . ./
RUN chmod ugo+r *
RUN chmod ugo+x color initialize

EXPOSE 80
ENV PATH="/app:${PATH}"

ENTRYPOINT ["/tini", "--"]
CMD ["./color"]

