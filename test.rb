require "./reporter.rb"

reporter = Reporter.new

[
  {
    input: "古池や蛙飛びこむ鶏の目覚まし声と水の音 #frfr",
    expected: <<~EOF
      Nodes: 古池[フルイケ:4],や[ヤ:1],蛙[カエル:3],飛びこむ[トビコム:4],鶏[ニワトリ:4],の[ノ:1],目覚まし[メザマシ:4],声[ゴエ:2],と[ト:1],水[ミズ:2],の[ノ:1],音[オト:2],#[:0],frfr[:0]
      Songs:
      [["古池", "や"], ["蛙", "飛びこむ"], ["鶏", "の"]]
      [["鶏", "の"], ["目覚まし", "声", "と"], ["水", "の", "音"]]
    EOF
  },
  {
    input: "古池や蛙飛び込む水の音 #frfr",
    expected: <<~EOF
      Nodes: 古池[フルイケ:4],や[ヤ:1],蛙[カエル:3],飛び込む[トビコム:4],水[ミズ:2],の[ノ:1],音[オト:2],#[:0],frfr[:0]
      Songs:
      [["古池", "や"], ["蛙", "飛び込む"], ["水", "の", "音"]]
    EOF
  },
].each do |test|
  songs, reports = reporter.report(test[:input])
  puts(reports)
  if reports != test[:expected] then
    raise "unmatch"
    # raise "unmatch expected '#{test[:expected]}' actual '#{reports}'"
  end
end
