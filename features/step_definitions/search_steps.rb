# encoding: UTF-8
当 /^我运行`([^`]*)`$/ do |cmd|
  run_interactive(unescape(cmd))
end

那么 /^输出应该包括: "([^"]*)"$/ do |expected|
  assert_partial_output(expected, all_output)
end

那么 /^输出应该匹配\/([^\/]*)\/$/ do |expected|
  assert_matching_output(expected, all_output)
end

那么 /^名为"([^"]*)"文件夹应该存在$/ do |directory|
  check_directory_presence([directory], true)
end

那么 /^名为"([^"]*)"的文件应该存在$/ do |file|
  check_file_presence([file], true)
end

当 /^我输入"([^"]*)"$/ do |input|
  type(input)
end
