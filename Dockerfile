FROM decidim/decidim:0.29.7

WORKDIR /app

COPY Gemfile Gemfile.lock package*.json ./
RUN bundle config set without "development test" \
  && bundle install \
  && npm ci --omit=dev

COPY . .

ENV RAILS_ENV=production \
  RACK_ENV=production \
  RAILS_LOG_TO_STDOUT=true \
  RAILS_SERVE_STATIC_FILES=true \
  NODE_OPTIONS=--experimental-global-webcrypto \
  PORT=3000

RUN SECRET_KEY_BASE=dummy DATABASE_URL=postgresql://postgres:postgres@localhost/sjma_decidim_production bundle exec rails assets:precompile

EXPOSE 3000

CMD ["bin/azure-web-start"]
