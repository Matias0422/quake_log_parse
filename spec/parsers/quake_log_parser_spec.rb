require './spec/spec_helper.rb'

require 'awesome_print'
require './app/parsers/quake_log_parser.rb'

RSpec.describe QuakeLogParser do
  let(:parser) { QuakeLogParser.new }

  let(:log_case) {
    <<~LOG
      20:37 ------------------------------------------------------------
      20:37 InitGame: \\sv_floodProtect\\1\\sv_maxPing\\0\\sv_minPing\\0\\sv_maxRate\\10000\\sv_minRate\\0\\sv_hostname\\Code Miner Server\\g_gametype\\0\\sv_privateClients\\2\\sv_maxclients\\16\\sv_allowDownload\\0\\bot_minplayers\\0\\dmflags\\0\\fraglimit\\20\\timelimit\\15\\g_maxGameClients\\0\\capturelimit\\8\\version\\ioq3 1.36 linux-x86_64 Apr 12 2009\\protocol\\68\\mapname\\q3dm17\\gamename\\baseq3\\g_needpass\\0
      20:38 ClientConnect: 2
      20:38 ClientUserinfoChanged: 2 n\\Isgalamido\\t\\0\\model\\uriel/zael\\hmodel\\uriel/zael\\g_redteam\\\\g_blueteam\\\\c1\\5\\c2\\5\\hc\\100\\w\\0\\l\\0\\tt\\0\\tl\\0
      20:54 Kill: 1022 2 22: <world> killed Isgalamido by MOD_TRIGGER_HURT
      21:07 Kill: 1022 2 22: <world> killed Isgalamido by MOD_TRIGGER_HURT
      21:15 ClientConnect: 2
      21:15 ClientUserinfoChanged: 2 n\\Isgalamido\\t\\0\\model\\uriel/zael\\hmodel\\uriel/zael\\g_redteam\\\\g_blueteam\\\\c1\\5\\c2\\5\\hc\\100\\w\\0\\l\\0\\tt\\0\\tl\\0
      21:17 ClientUserinfoChanged: 2 n\\Isgalamido\\t\\0\\model\\uriel/zael\\hmodel\\uriel/zael\\g_redteam\\\\g_blueteam\\\\c1\\5\\c2\\5\\hc\\100\\w\\0\\l\\0\\tt\\0\\tl\\0
      21:18 ShutdownGame:
      21:18 ------------------------------------------------------------
    LOG
  }

  let(:expect_output_hash) {
    {
      game_1: {
        parse_state: "FINISHED",
        total_kills: 2,
        players: ["Isgalamido"],
        kills: {
          Isgalamido: 0
        },
        players_ranking: {
          Isgalamido: -2
        },
        kills_by_means: {
          :MOD_BFG => 0,
          :MOD_BFG_SPLASH => 0,
          :MOD_CHAINGUN => 0,
          :MOD_CRUSH => 0,
          :MOD_FALLING => 0,
          :MOD_GAUNTLET => 0,
          :MOD_GRAPPLE => 0,
          :MOD_GRENADE => 0,
          :MOD_GRENADE_SPLASH => 0,
          :MOD_JUICED => 0,
          :MOD_KAMIKAZE => 0,
          :MOD_LAVA => 0,
          :MOD_LIGHTNING => 0,
          :MOD_MACHINEGUN => 0,
          :MOD_NAIL => 0,
          :MOD_PLASMA => 0,
          :MOD_PLASMA_SPLASH => 0,
          :MOD_PROXIMITY_MINE => 0,
          :MOD_RAILGUN => 0,
          :MOD_ROCKET => 0,
          :MOD_ROCKET_SPLASH => 0,
          :MOD_SHOTGUN => 0,
          :MOD_SLIME => 0,
          :MOD_SUICIDE => 0,
          :MOD_TARGET_LASER => 0,
          :MOD_TELEFRAG => 0,
          :MOD_TRIGGER_HURT => 2,
          :MOD_UNKNOWN => 0,
          :MOD_WATER => 0
        }
      }
    }
  }

  before do
    ENV['LOG_FILE_PATH'] = 'log.txt'
    ENV['LINES_BATCH_NUMBER'] = '100'

    file_double = double('file')
    allow(File).to receive(:open).with('log.txt', 'r').and_yield(file_double)
    allow(file_double).to receive(:each_slice).with(100).and_yield(log_case.split("\n"))
  end

  describe '#call' do
    it 'parses the log file' do
      output = capture_stdout { parser.call }
      expect_output = capture_stdout { ap(expect_output_hash) }

      # expect(parser).to receive(:parse_line).with("line1\n").once
      # expect(parser).to receive(:parse_line).with("line2\n").once
      
      expect(output).to eq(expect_output)
    end
  end

  # You can write similar tests for other methods in the class
end
