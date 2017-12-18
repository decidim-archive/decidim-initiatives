rm -Rf spec/decidim_dummy_app/
bundle exec rails decidim:generate_external_test_app
bundle
exit
cd spec/decidim_dummy_app/
ls -l
cd ..
rm -Rf decidim_dummy_app/
cd ..
bundle exec rails decidim:generate_external_test_app
cd spec/decidim_dummy_app/
bundle exec rails db:seed
cd ..
cd ..
bundle exec rspec
rspec
exit
