guard :rspec, cmd: 'bundle exec rspec' do
  watch(%r{\Aspec/.+_spec\.rb\z})
  watch(%r{\Alib/(.+)\.rb\z})         { |m| "spec/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')        { 'spec' }
  watch(%r{\Aspec/support/.+\.rb\z})  { 'spec' }
end
