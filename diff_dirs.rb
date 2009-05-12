class DiffDirs
  def self.diff_dirs(dir1, dir2)
    raise(ArgumentError, "Directories must be strings.") unless dir1.is_a?(String) && dir2.is_a?(String)
    
    dir1 = expand_path(dir1)
    dir2 = expand_path(dir2)
    
    cmd = "diff -qr #{dir1} #{dir2}"
    diff_result = execute(cmd)
    out = []
    diff_result.each_line do |line|
      line.chomp!
      out << diff_result_line_parse(dir1, dir2, line)
    end
    out
  end
  
  protected
    def self.diff_result_line_parse(dir1, dir2, line)
      # New/Deleted files
      match = line.match(/^Only in ([^:]*): ([^$]*)$/)
      if match
        if match[1] == dir1
          return [:deleted, match[2]] # deleted from second dir
        elsif match[1] == dir2
          return [:new, match[2]] # new in second dir
        else
          raise "#{dir1} or #{dir2} didn't match #{match[1]}"
        end
        
      elsif line.match(/^Files\s/) && line.match(/\sdiffer$/) 
        # Example: Files api/Rakefile and testing/Rakefile differ
        # This should be done with a nice regexp but couldn't figure out how to match everything but the word "and"
        files = line.sub(/^Files\s/, "").sub(/\sdiffer$/,"").split(" and ")
        return [:modified] << remove_dir_from_path(files[0], dir1)
      end
      
      raise RuntimeError, "Cannot parse: #{line}"
    end
    
    def self.execute(cmd)
      `#{cmd}`
    end
    
    def self.remove_dir_from_path(path, dir)
      dir += "/" unless dir[-1..-1] == "/"
      path.sub(Regexp.new("^#{dir}"), "")
    end
    
    def self.expand_path(dir)
      if dir[0..0] == "~"
        File.expand_path(dir) 
      else
        dir
      end
    end
end

public 
def diff_dirs(dir1, dir2); DiffDirs::diff_dirs(dir1, dir2); end