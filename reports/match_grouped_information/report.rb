module MatchGroupedInformation
  class Report
    JSON_FILE_PATH = './match_grouped_information_report.json'

    def initialize
      File.write(JSON_FILE_PATH, JSON.dump('['))
    end

    def finalize
      File.write(JSON_FILE_PATH, JSON.dump(']'))
    end

    def self.increment_match(match)
      json_match = match.to_json

      
    end
  end
end
