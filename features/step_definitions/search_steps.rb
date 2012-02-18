# encoding: UTF-8
当 /^我运行`([^`]*)`$/ do |cmd|
  run_interactive(unescape(cmd))
end

那么 /^输出应该包括:$/ do |expected|
  assert_partial_output(expected, all_output)
end

那么 /^输出应该匹配\/([^\/]*)\/$/ do |expected|
  assert_matching_output(expected, all_output)
end

