sum=0
outcome={"参加費"=>1000,"ストラップ"=>1000,"hoge"=>4000}
outcome.each do |pair|
  sum+= pair[1]
  p pair[0]
  p pair[1]
end
puts "合計:#{sum}"
