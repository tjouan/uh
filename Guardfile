directories %w[ext lib test]

guard :rake, task: :compile, run_on_start: true do
  watch %r{\Aext.*}
end

guard :minitest, all_on_start: false do
  watch %r{\Atest/(.*)\/?test_(.*)\.rb$}
  watch(%r{\Alib/(.*/)?([^/]+)\.rb$})     { |m| "test/#{m[1]}test_#{m[2]}.rb" }
  watch(%r{\Aext/(.*/)?([^/]+)\.c$})     { |m| "test/#{m[1]}test_#{m[2]}.rb" }
  watch(%r{\Atest/test_helper\.rb$})      { 'test' }
end
