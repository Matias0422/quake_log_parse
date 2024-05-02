require './spec/spec_helper.rb'

require 'awesome_print'
require './app/parsers/quake_log_parser.rb'

RSpec.describe QuakeLogParser do
  let(:parser) { QuakeLogParser.new }

  before do
    file_double = double('file')
    allow(File).to receive(:open).with(ENV['LOG_FILE_NAME'], 'r').and_yield(file_double)
    allow(file_double).to receive(:each_slice).with(ENV['LINES_BATCH_NUMBER'].to_i).and_yield(log_scenario.split("\n"))
  end

  describe '#call' do
    shared_examples 'parses log scenario' do
      it 'output must be equal expect_output' do
        output = capture_stdout { parser.call }
        expect_output = capture_stdout do
          expect_output_hash_list.each do |expect_output_hash|
            ap(expect_output_hash)
          end
        end
        
        expect(output).to eq(expect_output)
      end
    end

    context 'parses a log scenario with one match finished' do
      let(:log_scenario) {
        <<~LOG
          20:37 ------------------------------------------------------------
          20:37 InitGame: \\sv_floodProtect\\1\\sv_maxPing\\0\\sv_minPing\\0\\sv_maxRate\\10000\\sv_minRate\\0\\sv_hostname\\Code Miner Server\\g_gametype\\0\\sv_privateClients\\2\\sv_maxclients\\16\\sv_allowDownload\\0\\bot_minplayers\\0\\dmflags\\0\\fraglimit\\20\\timelimit\\15\\g_maxGameClients\\0\\capturelimit\\8\\version\\ioq3 1.36 linux-x86_64 Apr 12 2009\\protocol\\68\\mapname\\q3dm17\\gamename\\baseq3\\g_needpass\\0
          20:38 ClientConnect: 2
          20:38 ClientUserinfoChanged: 2 n\\Isgalamido\\t\\0\\model\\uriel/zael\\hmodel\\uriel/zael\\g_redteam\\\\g_blueteam\\\\c1\\5\\c2\\5\\hc\\100\\w\\0\\l\\0\\tt\\0\\tl\\0
          20:39 ClientBegin: 2
          20:54 Kill: 1022 2 22: <world> killed Isgalamido by MOD_TRIGGER_HURT
          21:07 Kill: 1022 2 22: <world> killed Isgalamido by MOD_TRIGGER_HURT
          21:08 ClientDisconnect: 2
          21:15 ClientConnect: 2
          21:15 ClientUserinfoChanged: 2 n\\Isgalamido\\t\\0\\model\\uriel/zael\\hmodel\\uriel/zael\\g_redteam\\\\g_blueteam\\\\c1\\5\\c2\\5\\hc\\100\\w\\0\\l\\0\\tt\\0\\tl\\0
          21:15 ClientBegin: 2
          21:51 ClientConnect: 3
          21:53 ClientUserinfoChanged: 3 n\\Mocinha\\t\\0\\model\\sarge\\hmodel\\sarge\\g_redteam\\\\g_blueteam\\\\c1\\4\\c2\\5\\hc\\95\\w\\0\\l\\0\\tt\\0\\tl\\0
          21:51 ClientUserinfoChanged: 3 n\\Dono da Bola\\t\\0\\model\\sarge/krusade\\hmodel\\sarge/krusade\\g_redteam\\\\g_blueteam\\\\c1\\5\\c2\\5\\hc\\95\\w\\0\\l\\0\\tt\\0\\tl\\0
          21:53 ClientBegin: 3
          22:06 Kill: 2 3 7: Isgalamido killed Dono da Bola by MOD_ROCKET_SPLASH
          24:18 ShutdownGame:
          24:18 ------------------------------------------------------------
        LOG
      }

      let(:expect_output_hash_list) {
        [
          {
            game_1: {
              parse_state: "FINISHED",
              total_kills: 3,
              players: ["Isgalamido", "Dono da Bola"],
              kills: {
                Isgalamido: 1,
                :"Dono da Bola" => 0
              },
              players_ranking: {
                :"Dono da Bola" => 0,
                Isgalamido: -1
              },
              kills_by_means: {
                MOD_BFG: 0,
                MOD_BFG_SPLASH: 0,
                MOD_CHAINGUN: 0,
                MOD_CRUSH: 0,
                MOD_FALLING: 0,
                MOD_GAUNTLET: 0,
                MOD_GRAPPLE: 0,
                MOD_GRENADE: 0,
                MOD_GRENADE_SPLASH: 0,
                MOD_JUICED: 0,
                MOD_KAMIKAZE: 0,
                MOD_LAVA: 0,
                MOD_LIGHTNING: 0,
                MOD_MACHINEGUN: 0,
                MOD_NAIL: 0,
                MOD_PLASMA: 0,
                MOD_PLASMA_SPLASH: 0,
                MOD_PROXIMITY_MINE: 0,
                MOD_RAILGUN: 0,
                MOD_ROCKET: 0,
                MOD_ROCKET_SPLASH: 1,
                MOD_SHOTGUN: 0,
                MOD_SLIME: 0,
                MOD_SUICIDE: 0,
                MOD_TARGET_LASER: 0,
                MOD_TELEFRAG: 0,
                MOD_TRIGGER_HURT: 2,
                MOD_UNKNOWN: 0,
                MOD_WATER: 0
              }
            }
          }
        ]
      }

      include_examples 'parses log scenario'
    end

    context 'parses a log scenario with more than one match finished' do
      let(:log_scenario) {
        <<~LOG
          20:37 ------------------------------------------------------------
          20:37 InitGame: \\sv_floodProtect\\1\\sv_maxPing\\0\\sv_minPing\\0\\sv_maxRate\\10000\\sv_minRate\\0\\sv_hostname\\Code Miner Server\\g_gametype\\0\\sv_privateClients\\2\\sv_maxclients\\16\\sv_allowDownload\\0\\bot_minplayers\\0\\dmflags\\0\\fraglimit\\20\\timelimit\\15\\g_maxGameClients\\0\\capturelimit\\8\\version\\ioq3 1.36 linux-x86_64 Apr 12 2009\\protocol\\68\\mapname\\q3dm17\\gamename\\baseq3\\g_needpass\\0
          20:38 ClientConnect: 2
          20:38 ClientUserinfoChanged: 2 n\\Isgalamido\\t\\0\\model\\uriel/zael\\hmodel\\uriel/zael\\g_redteam\\\\g_blueteam\\\\c1\\5\\c2\\5\\hc\\100\\w\\0\\l\\0\\tt\\0\\tl\\0
          20:39 ClientBegin: 2
          21:51 ClientConnect: 3
          21:53 ClientUserinfoChanged: 3 n\\Mocinha\\t\\0\\model\\sarge\\hmodel\\sarge\\g_redteam\\\\g_blueteam\\\\c1\\4\\c2\\5\\hc\\95\\w\\0\\l\\0\\tt\\0\\tl\\0
          21:51 ClientUserinfoChanged: 3 n\\Dono da Bola\\t\\0\\model\\sarge/krusade\\hmodel\\sarge/krusade\\g_redteam\\\\g_blueteam\\\\c1\\5\\c2\\5\\hc\\95\\w\\0\\l\\0\\tt\\0\\tl\\0
          21:53 ClientBegin: 3
          22:06 Kill: 2 3 7: Isgalamido killed Dono da Bola by MOD_PLASMA
          22:07 Kill: 3 2 7: Dono da Bola killed Isgalamido by MOD_ROCKET_SPLASH
          24:18 ShutdownGame:
          24:18 ------------------------------------------------------------
          25:37 ------------------------------------------------------------
          26:37 InitGame: \\sv_floodProtect\\1\\sv_maxPing\\0\\sv_minPing\\0\\sv_maxRate\\10000\\sv_minRate\\0\\sv_hostname\\Code Miner Server\\g_gametype\\0\\sv_privateClients\\2\\sv_maxclients\\16\\sv_allowDownload\\0\\bot_minplayers\\0\\dmflags\\0\\fraglimit\\20\\timelimit\\15\\g_maxGameClients\\0\\capturelimit\\8\\version\\ioq3 1.36 linux-x86_64 Apr 12 2009\\protocol\\68\\mapname\\q3dm17\\gamename\\baseq3\\g_needpass\\0
          26:38 ClientConnect: 2
          26:38 ClientUserinfoChanged: 2 n\\Isgalamido\\t\\0\\model\\uriel/zael\\hmodel\\uriel/zael\\g_redteam\\\\g_blueteam\\\\c1\\5\\c2\\5\\hc\\100\\w\\0\\l\\0\\tt\\0\\tl\\0
          26:39 ClientBegin: 2
          27:51 ClientConnect: 3
          27:53 ClientUserinfoChanged: 3 n\\Mocinha\\t\\0\\model\\sarge\\hmodel\\sarge\\g_redteam\\\\g_blueteam\\\\c1\\4\\c2\\5\\hc\\95\\w\\0\\l\\0\\tt\\0\\tl\\0
          27:51 ClientUserinfoChanged: 3 n\\Dono da Bola\\t\\0\\model\\sarge/krusade\\hmodel\\sarge/krusade\\g_redteam\\\\g_blueteam\\\\c1\\5\\c2\\5\\hc\\95\\w\\0\\l\\0\\tt\\0\\tl\\0
          27:53 ClientBegin: 3
          28:06 Kill: 2 3 1: Isgalamido killed Dono da Bola by MOD_PLASMA
          28:07 Kill: 3 2 2: Dono da Bola killed Isgalamido by MOD_ROCKET_SPLASH
          28:54 Kill: 1022 2 3: <world> killed Isgalamido by MOD_TRIGGER_HURT
          28:55 Kill: 1022 3 3: <world> killed Dono da Bola by MOD_TRIGGER_HURT
          29:18 ShutdownGame:
          30:18 ------------------------------------------------------------
        LOG
      }

      let(:expect_output_hash_list) {
        [
          {
            game_2: {
              parse_state: "FINISHED",
              total_kills: 2,
              players: ["Isgalamido", "Dono da Bola"],
              kills: {
                Isgalamido: 1,
                :"Dono da Bola" => 1
              },
              players_ranking: {
                Isgalamido: 1,
                :"Dono da Bola" => 1
              },
              kills_by_means: {
                MOD_BFG: 0,
                MOD_BFG_SPLASH: 0,
                MOD_CHAINGUN: 0,
                MOD_CRUSH: 0,
                MOD_FALLING: 0,
                MOD_GAUNTLET: 0,
                MOD_GRAPPLE: 0,
                MOD_GRENADE: 0,
                MOD_GRENADE_SPLASH: 0,
                MOD_JUICED: 0,
                MOD_KAMIKAZE: 0,
                MOD_LAVA: 0,
                MOD_LIGHTNING: 0,
                MOD_MACHINEGUN: 0,
                MOD_NAIL: 0,
                MOD_PLASMA: 1,
                MOD_PLASMA_SPLASH: 0,
                MOD_PROXIMITY_MINE: 0,
                MOD_RAILGUN: 0,
                MOD_ROCKET: 0,
                MOD_ROCKET_SPLASH: 1,
                MOD_SHOTGUN: 0,
                MOD_SLIME: 0,
                MOD_SUICIDE: 0,
                MOD_TARGET_LASER: 0,
                MOD_TELEFRAG: 0,
                MOD_TRIGGER_HURT: 0,
                MOD_UNKNOWN: 0,
                MOD_WATER: 0
              }
            }
          },
          {
            game_3:{
              parse_state: "FINISHED",
              total_kills: 4,
              players: ["Isgalamido", "Dono da Bola"],
              kills: {
                Isgalamido: 1,
                :"Dono da Bola" => 1
              },
              players_ranking: {
                Isgalamido: 0,
                :"Dono da Bola" => 0
              },
              kills_by_means: {
                MOD_BFG: 0,
                MOD_BFG_SPLASH: 0,
                MOD_CHAINGUN: 0,
                MOD_CRUSH: 0,
                MOD_FALLING: 0,
                MOD_GAUNTLET: 0,
                MOD_GRAPPLE: 0,
                MOD_GRENADE: 0,
                MOD_GRENADE_SPLASH: 0,
                MOD_JUICED: 0,
                MOD_KAMIKAZE: 0,
                MOD_LAVA: 0,
                MOD_LIGHTNING: 0,
                MOD_MACHINEGUN: 0,
                MOD_NAIL: 0,
                MOD_PLASMA: 1,
                MOD_PLASMA_SPLASH: 0,
                MOD_PROXIMITY_MINE: 0,
                MOD_RAILGUN: 0,
                MOD_ROCKET: 0,
                MOD_ROCKET_SPLASH: 1,
                MOD_SHOTGUN: 0,
                MOD_SLIME: 0,
                MOD_SUICIDE: 0,
                MOD_TARGET_LASER: 0,
                MOD_TELEFRAG: 0,
                MOD_TRIGGER_HURT: 2,
                MOD_UNKNOWN: 0,
                MOD_WATER: 0
              }
            }
          }
        ]
      }

      include_examples 'parses log scenario'
    end

    context 'parses a log scenario with more than one match and one of them is incomplete' do
      let(:log_scenario) {
        <<~LOG
          20:37 ------------------------------------------------------------
          20:37 InitGame: \\sv_floodProtect\\1\\sv_maxPing\\0\\sv_minPing\\0\\sv_maxRate\\10000\\sv_minRate\\0\\sv_hostname\\Code Miner Server\\g_gametype\\0\\sv_privateClients\\2\\sv_maxclients\\16\\sv_allowDownload\\0\\bot_minplayers\\0\\dmflags\\0\\fraglimit\\20\\timelimit\\15\\g_maxGameClients\\0\\capturelimit\\8\\version\\ioq3 1.36 linux-x86_64 Apr 12 2009\\protocol\\68\\mapname\\q3dm17\\gamename\\baseq3\\g_needpass\\0
          20:38 ClientConnect: 2
          20:38 ClientUserinfoChanged: 2 n\\Isgalamido\\t\\0\\model\\uriel/zael\\hmodel\\uriel/zael\\g_redteam\\\\g_blueteam\\\\c1\\5\\c2\\5\\hc\\100\\w\\0\\l\\0\\tt\\0\\tl\\0
          20:39 ClientBegin: 2
          20:54 Kill: 1022 2 22: <world> killed Isgalamido by MOD_TRIGGER_HURT
          21:08 ClientDisconnect: 2
          21:15 ClientConnect: 2
          21:15 ClientUserinfoChanged: 2 n\\Isgalamido\\t\\0\\model\\uriel/zael\\hmodel\\uriel/zael\\g_redteam\\\\g_blueteam\\\\c1\\5\\c2\\5\\hc\\100\\w\\0\\l\\0\\tt\\0\\tl\\0
          21:15 ClientBegin: 2
          21:51 ClientConnect: 3
          21:53 ClientUserinfoChanged: 3 n\\Mocinha\\t\\0\\model\\sarge\\hmodel\\sarge\\g_redteam\\\\g_blueteam\\\\c1\\4\\c2\\5\\hc\\95\\w\\0\\l\\0\\tt\\0\\tl\\0
          21:51 ClientUserinfoChanged: 3 n\\Dono da Bola\\t\\0\\model\\sarge/krusade\\hmodel\\sarge/krusade\\g_redteam\\\\g_blueteam\\\\c1\\5\\c2\\5\\hc\\95\\w\\0\\l\\0\\tt\\0\\tl\\0
          21:53 ClientBegin: 3
          22:06 Kill: 2 3 7: Isgalamido killed Dono da Bola by MOD_ROCKET_SPLASH
          22:06 Kill: 3 2 7: Dono da Bola killed Isgalamido by MOD_ROCKET_SPLASH
          25:37 ------------------------------------------------------------
          25:37 InitGame: \\sv_floodProtect\\1\\sv_maxPing\\0\\sv_minPing\\0\\sv_maxRate\\10000\\sv_minRate\\0\\sv_hostname\\Code Miner Server\\g_gametype\\0\\sv_privateClients\\2\\sv_maxclients\\16\\sv_allowDownload\\0\\bot_minplayers\\0\\dmflags\\0\\fraglimit\\20\\timelimit\\15\\g_maxGameClients\\0\\capturelimit\\8\\version\\ioq3 1.36 linux-x86_64 Apr 12 2009\\protocol\\68\\mapname\\q3dm17\\gamename\\baseq3\\g_needpass\\0
          25:38 ClientConnect: 2
          25:38 ClientUserinfoChanged: 2 n\\Isgalamido\\t\\0\\model\\uriel/zael\\hmodel\\uriel/zael\\g_redteam\\\\g_blueteam\\\\c1\\5\\c2\\5\\hc\\100\\w\\0\\l\\0\\tt\\0\\tl\\0
          25:39 ClientBegin: 2
          25:54 Kill: 1022 2 22: <world> killed Isgalamido by MOD_TRIGGER_HURT
          26:07 Kill: 1022 2 22: <world> killed Isgalamido by MOD_TRIGGER_HURT
          26:08 ClientDisconnect: 2
          26:15 ClientConnect: 2
          26:15 ClientUserinfoChanged: 2 n\\Isgalamido\\t\\0\\model\\uriel/zael\\hmodel\\uriel/zael\\g_redteam\\\\g_blueteam\\\\c1\\5\\c2\\5\\hc\\100\\w\\0\\l\\0\\tt\\0\\tl\\0
          26:15 ClientBegin: 2
          26:51 ClientConnect: 3
          26:53 ClientUserinfoChanged: 3 n\\Mocinha\\t\\0\\model\\sarge\\hmodel\\sarge\\g_redteam\\\\g_blueteam\\\\c1\\4\\c2\\5\\hc\\95\\w\\0\\l\\0\\tt\\0\\tl\\0
          26:51 ClientUserinfoChanged: 3 n\\Dono da Bola\\t\\0\\model\\sarge/krusade\\hmodel\\sarge/krusade\\g_redteam\\\\g_blueteam\\\\c1\\5\\c2\\5\\hc\\95\\w\\0\\l\\0\\tt\\0\\tl\\0
          26:53 ClientBegin: 3
          27:06 Kill: 2 3 7: Isgalamido killed Mocinha by MOD_ROCKET_SPLASH
          28:18 ShutdownGame:
          28:18 ------------------------------------------------------------
        LOG
      }

      let(:expect_output_hash_list) {
        [
          {
            game_4: {
              parse_state: "INCOMPLETE",
              total_kills: 3,
              players: ["Isgalamido", "Dono da Bola"],
              kills: {
                Isgalamido: 1,
                :"Dono da Bola" => 1
              },
              players_ranking: {
                :"Dono da Bola" => 1,
                Isgalamido: 0
              },
              kills_by_means: {
                MOD_BFG: 0,
                MOD_BFG_SPLASH: 0,
                MOD_CHAINGUN: 0,
                MOD_CRUSH: 0,
                MOD_FALLING: 0,
                MOD_GAUNTLET: 0,
                MOD_GRAPPLE: 0,
                MOD_GRENADE: 0,
                MOD_GRENADE_SPLASH: 0,
                MOD_JUICED: 0,
                MOD_KAMIKAZE: 0,
                MOD_LAVA: 0,
                MOD_LIGHTNING: 0,
                MOD_MACHINEGUN: 0,
                MOD_NAIL: 0,
                MOD_PLASMA: 0,
                MOD_PLASMA_SPLASH: 0,
                MOD_PROXIMITY_MINE: 0,
                MOD_RAILGUN: 0,
                MOD_ROCKET: 0,
                MOD_ROCKET_SPLASH: 2,
                MOD_SHOTGUN: 0,
                MOD_SLIME: 0,
                MOD_SUICIDE: 0,
                MOD_TARGET_LASER: 0,
                MOD_TELEFRAG: 0,
                MOD_TRIGGER_HURT: 1,
                MOD_UNKNOWN: 0,
                MOD_WATER: 0
              }
            }
          },
          {
            game_5: {
              parse_state: "FINISHED",
              total_kills: 3,
              players: ["Isgalamido", "Dono da Bola"],
              kills: {
                Isgalamido: 1,
                :"Dono da Bola" => 0
              },
              players_ranking: {
                :"Dono da Bola" => 0,
                Isgalamido: -1
              },
              kills_by_means: {
                MOD_BFG: 0,
                MOD_BFG_SPLASH: 0,
                MOD_CHAINGUN: 0,
                MOD_CRUSH: 0,
                MOD_FALLING: 0,
                MOD_GAUNTLET: 0,
                MOD_GRAPPLE: 0,
                MOD_GRENADE: 0,
                MOD_GRENADE_SPLASH: 0,
                MOD_JUICED: 0,
                MOD_KAMIKAZE: 0,
                MOD_LAVA: 0,
                MOD_LIGHTNING: 0,
                MOD_MACHINEGUN: 0,
                MOD_NAIL: 0,
                MOD_PLASMA: 0,
                MOD_PLASMA_SPLASH: 0,
                MOD_PROXIMITY_MINE: 0,
                MOD_RAILGUN: 0,
                MOD_ROCKET: 0,
                MOD_ROCKET_SPLASH: 1,
                MOD_SHOTGUN: 0,
                MOD_SLIME: 0,
                MOD_SUICIDE: 0,
                MOD_TARGET_LASER: 0,
                MOD_TELEFRAG: 0,
                MOD_TRIGGER_HURT: 2,
                MOD_UNKNOWN: 0,
                MOD_WATER: 0
              }
            }
          }
        ]
      }

      include_examples 'parses log scenario'
    end
  end
end
