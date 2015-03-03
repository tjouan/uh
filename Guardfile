directories %w[lib test]

guard :minitest do
  watch(%r{\Atest/(.*)\/?test_(.*)\.rb$})
  watch(%r{\Alib/(.*/)?([^/]+)\.rb$})     { |m| "test/#{m[1]}test_#{m[2]}.rb" }
  watch(%r{\Atest/test_helper\.rb$})      { 'test' }
end
