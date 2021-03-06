# FindHaiku4Mstdn
mastodon上で、俳句を検出するbotのプログラムです。日々のトゥートの中で思いがけず生まれた５７５に光を当てるべく開発されました。

## 使い方
1. mecabをなんとかして入れる
2. 以下を参考に`.env`という設定ファイルを作成し、どうにかして`BASE_URL`と`ACCESS_TOKEN`を入手して記載する
```env
BASE_URL=https://example.com
ACCESS_TOKEN=tx8j4j3yb5ibxuns6i3w73ndpffmg4c7jxcr7jr5psgn5de4a38k5d5jjc4tsir8
```
3. `docker-compose up -d`
4.  ✌('ω'✌ )三✌('ω')✌三( ✌'ω')✌

## 現状
- 撥音とかがおかしい？
  - [r7kamura/ikku](https://github.com/r7kamura/ikku)に依存。
    - たぶんMeCabの辞書に依存
- トゥートの公開範囲
  - 未収載以上のものに返信。非公開以下は返信しない。
  - CWが付いたトゥートにはCWを付けて返信
- 反応しないトゥートの判断が雑
  - リプライをすべて除外している。
- 季語

## その他
問題を発見した方は[@theoria@wug.fun](https://wug.fun/@theoria)や[@theoria@knzk.me](https://knzk.me/@theoria)、[@theoria@theboss.tech](https://theboss.tech/@theoria)、[@theoria@mstdn.jp](https://mstdn.jp/@theoria)、あるいは[Twitter](https://twitter.com/_theoria)に連絡していただけるとありがたいです。ここに[Issue](https://github.com/theoria24/FindHaiku4Mstdn/issues/new)を立てていただいても構いません。

プルリク歓迎です。

## testing

```bash
docker-compose up -d
docker-compose exec app bundle exec ruby test.rb
```
