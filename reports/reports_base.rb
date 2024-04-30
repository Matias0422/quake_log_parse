require 'json'

class ReportsBase
  def initialize(file_path:)
    @file_path = file_path
    
    File.write(@file_path, JSON.dump('['))
  end

  def increment_json_line(json_line)
    File.open(JSON_FILE_PATH, 'a+') do |file|
      file.puts(json_line)
    end
  end

  def finalize
    increment_json_line(JSON.dump(']'))
  end
end
