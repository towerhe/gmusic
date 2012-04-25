# language: zh-CN
功能: 歌曲搜索和下载
  为了方便的搜索歌曲
  作为一个CLI
  我必须提供相应的搜索命令

  @announce-stdout
  场景: 歌曲搜索
    当我运行`gmusic search --title bad-romance`
    那么输出应该包括: "下载中"
    那么输出应该匹配/.+序号.+歌名.+歌手.+链接/
    那么输出应该包括: "Bad Romance"
    那么输出应该包括: "请输入序号"
    而且我输入"1"

  @wip
  场景: 专辑搜索
    当我运行`gmusic search --title 阿密特 --album`
    那么输出应该包括: "阿密特"
  @announce-cmd
  场景: 歌曲下载
    当我运行`gmusic download --title bad-romance`
    #那么名为"./download"文件夹应该存在
    那么名为"~/Downloads/bad-romance.mp3"的文件应该存在
