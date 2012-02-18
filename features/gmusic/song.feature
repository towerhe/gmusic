# language: zh-CN
功能: 搜索
  为了方便的搜索歌曲
  作为一个CLI
  我必须提供相应的搜索命令

  @announce-cmd
  场景: 歌曲搜索
    当我运行`gmusic song search --title Bad-Romance`
    那么输出应该匹配/.+歌名.+歌手.+链接/
