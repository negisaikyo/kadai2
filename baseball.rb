require('./player.rb')


class Player
  #選手能力の初期化
  def initialize(attack,defense)
    @attack = attack
    @defense = defense
    @hitmeter = 0 #ヒットメータ
    @base = 0 #何塁に居るか
  end

  #バッティング
  def batting(team_defense) #相手の総防御力を引数に取る
    @hitmeter += @attack
    if @hitmeter >= team_defense then
      @hitmeter -= team_defense
      case (@hitmeter % 4)
      when 0 then
        return "hit"
      when 1 then
        return "two_base"
      when 2 then
        return "three_base"
      when 3 then
        return "home_run"
      end
    else
      return "out"
    end
  end

  def defense
    return @defense
  end

  def hitmeter
    return @hitmeter
  end

end

#一回分の攻撃処理
def play_offense(offense_side,batting_order,defense_side) #(攻撃側,何番からか,守備側の総防御力)
  out_count = 0
  point = 0
  runner = {1=>0,2=>0,3=>0,4=>0,5=>0,6=>0,7=>0,8=>0,9=>0} #何番打者が何塁に入るか
  while out_count < 3 do
    tmp_batting = 0
    batting_result = offense_side[batting_order].batting(defense_side)
    puts "#{batting_order}番:#{batting_result}"
    case batting_result
    when "hit" then
      tmp_batting = 1
    when "two_base" then
      tmp_batting = 2
    when "three_base" then
      tmp_batting = 3
    when "home_run" then
      tmp_batting = 4
    when "out" then
      out_count += 1
    end

    #打った時の処理
    if tmp_batting >=1 then
      for i in 1..9 do
        if (runner[i] >= 1 || i == batting_order) then
          runner[i] += tmp_batting
          if runner[i] >= 4 then
            point += 1
            runner[i] = 0
          end
        end
      end
    end

    #打順の推移
    if batting_order < 9 then
      batting_order += 1
    else
      batting_order = 1
    end
  end
  return point,batting_order
end

#teamの生成
team_A=Array.new(9)
team_B=Array.new(9)
team_defense_A=0
team_defense_B=0
for i in  1..9 do
  team_A[i] = Player.new(PlayerInfoA[i][:attack],PlayerInfoA[i][:defense])
  team_B[i] = Player.new(PlayerInfoB[i][:attack],PlayerInfoB[i][:defense])
  team_defense_A += team_A[i].defense
  team_defense_B += team_B[i].defense
end

#試合全体の処理
batting_order_A = 1
batting_order_B = 1
point_A = 0
point_B = 0
innings = 5
for i in 1..innings do


  puts "#{i}"+"回表"
  sleep(1)
  point,batting_order_A = play_offense(team_A,batting_order_A,team_defense_B)
  point_A += point
  puts "team_A:#{point_A}-#{point_B}:team_B"

  #最終回の表終了時で裏側が勝ってたら終了
  if (i == innings && point_A < point_B) then
    break
  end

  puts "#{i}"+"回裏"
  sleep(1)
  point,batting_order_B = play_offense(team_B,batting_order_B,team_defense_A)
  point_B += point
  puts "team_A:#{point_A}-#{point_B}:team_B"
end

puts "GAMESET"
