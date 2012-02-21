# language: zh-CN
功能: 歌曲搜索和下载
  为了方便的搜索歌曲
  作为一个CLI
  我必须提供相应的搜索命令

  @announce-cmd
  场景: 歌曲搜索
    当我运行`gmusic song search --title bad-romance`
    那么输出应该匹配/.+歌名.+歌手.+链接/

  @wip @announce-cmd
  场景: 歌曲下载
    当我运行`gmusic song download --title bad-romance --directory ./download`
    那么名为"./download"文件夹应该存在
    那么名为"./download/bad-romance.mp3"的文件应该存在
