FROM ruby:3.1.2
ARG GIT_COMMIT
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
      nodejs \
      gosu \
      sendmail \
 && rm -rf /var/lib/apt/lists/* \
 && gem install bundler \
 && mkdir /app
WORKDIR /app
COPY .build/Gemfile .build/Gemfile.lock ./
RUN bundle config set deployment 'true' \
 && bundle config set without 'development test' \
 && bundle install
ADD .build/context.tar .
RUN REDIS_URL=redis://example.com NODE_ENV=production RAILS_ENV=production SECRET_KEY_BASE=placeholder-secret bundle exec rake assets:precompile
RUN echo "${GIT_COMMIT}" > /app/GIT_COMMIT
HEALTHCHECK --interval=30s \
            --timeout=30s \
            --start-period=5s \
            --retries=3 \
            CMD ["bundle","exec","rake","orchestration:healthcheck"]
ENTRYPOINT ["/app/orchestration/entrypoint.sh"]
CMD ["bundle","exec","puma","-C","config/puma.rb"]
