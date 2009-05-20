require File.dirname(__FILE__) + '/test_helper'
require File.dirname(__FILE__) + '/../lib/diff_dirs'

class DiffDirsTest < Test::Unit::TestCase
  context "diff executable" do
    should "be found by which" do
      assert_not_equal "", `which diff`
    end
  end
  
  context "diff_dirs method" do
    should "correctly parse diff output and return proper array" do
      diff_output = "Only in dir1: .git\nOnly in dir1: Capfile\nOnly in dir2: Capfile2\nFiles dir1/Rakefile and dir2/Rakefile differ\nFiles dir1/lib/format.rb and dir2/lib/format.rb differ\n"
      DiffDirs.expects(:execute).with("diff -qr dir1 dir2").returns(diff_output)
      assert_equal [[:deleted, ".git"],
                    [:deleted, "Capfile"],
                    [:new, "Capfile2"],
                    [:modified, "Rakefile"],
                    [:modified, "lib/format.rb"]], DiffDirs::diff_dirs("dir1", "dir2")
    end
    
    should "fail if provided with non-string arguments" do
      assert_raise(ArgumentError) { diff_dirs(nil, "") }
      assert_raise(ArgumentError) { diff_dirs("", nil) }
    end
    
    should "expand paths if starts with ~" do
      
    end
  end
  
  context "diff_result_line_parse method" do
    setup do
      @d1 = "dir1"
      @d2 = "dir2"
      @diff_output = "Only in dir1: .git\nOnly in dir1: Capfile\nOnly in dir2: Capfile2\nFiles dir1/Rakefile and dir2/Rakefile differ\nFiles dir1/lib/format.rb and dir2/lib/format.rb differ\n".split("\n")
    end
    
    should "correctly identify new files" do
      assert_equal [:new, "Capfile2"], DiffDirs.send(:diff_result_line_parse, @d1, @d2, @diff_output[2])
    end
    
    should "correctly identify deleted files" do
      assert_equal [:deleted, ".git"],    DiffDirs.send(:diff_result_line_parse, @d1, @d2, @diff_output[0])
      assert_equal [:deleted, "Capfile"], DiffDirs.send(:diff_result_line_parse, @d1, @d2, @diff_output[1])
    end
    
    should "correctly identify modified files" do
      assert_equal [:modified, "Rakefile"],      DiffDirs.send(:diff_result_line_parse, @d1, @d2, @diff_output[3])
      assert_equal [:modified, "lib/format.rb"], DiffDirs.send(:diff_result_line_parse, @d1, @d2, @diff_output[4])
    end
  end
  
  context "remove_dir_from_path method" do
    should "correctly remove dir not having a trailing slash" do
      assert_equal "lib/format.rb", DiffDirs.send(:remove_dir_from_path, "dir1/lib/format.rb", "dir1")
    end
    
    should "correctly remove dir having a trailing slash" do
      assert_equal "lib/format.rb", DiffDirs.send(:remove_dir_from_path, "dir1/lib/format.rb", "dir1/")
    end
  end
  
  context "expand_path method" do
    should "expand path when starting with ~" do
      assert_equal "/tmp",   DiffDirs.send(:expand_path, "/tmp")
      assert_not_equal "~/", DiffDirs.send(:expand_path, "~/")
    end
  end
  
  context "complex real life directory structure" do
    setup do
      @path = "/tmp/diff-dirs-test-#{rand(10000)}"
      exec "mkdir -p #{@path}/1/dir1/dir2"
      exec "touch    #{@path}/1/dir1/file1"
      exec "touch    #{@path}/1/dir1/dir2/file2"
      exec "mkdir -p #{@path}/1/foo/bar"
      exec "touch    #{@path}/1/foo/file_in_foo"
      exec "touch    #{@path}/1/file_in_root"
      exec "touch    #{@path}/1/another_file_in_root"
      exec "echo hello > #{@path}/1/foo/file_with_content"
      
      exec "mkdir -p #{@path}/2/foo/bar"
      exec "touch    #{@path}/2/foo/file_in_foo"
      exec "touch    #{@path}/2/foo/bar/file_in_bar"
      exec "touch    #{@path}/2/file_in_root"
      exec "touch    #{@path}/2/yet_another_file_in_root"
      exec "echo world > #{@path}/2/foo/file_with_content"
    end
    
    teardown do
      `rm -fr #{@path}`
    end
    
    should "run the full stack properly and return the correct diff result" do

      assert_equal [[:deleted, "another_file_in_root"],
                    [:deleted, "dir1"],
                    [:new, "foo/bar/file_in_bar"],
                    [:modified, "foo/file_with_content"],
                    [:new, "yet_another_file_in_root"]], DiffDirs.diff_dirs("#{@path}/1", "#{@path}/2")
    end
  end
  
  def exec(cmd)
    # puts cmd
    `#{cmd}`
  end
end