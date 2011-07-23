# encoding: UTF-8
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module GMusic
  describe SongListParser do
    it "should return an empty array if no record has been found" do
      songs = SongListParser.parse path_of('g-empty.html')
      songs.empty?.should be_true
    end

    it "should parse all the songs with id, title, artist and album" do
      songs = SongListParser.parse path_of('g-search-thankyou.html')

      songs.should be_instance_of(Array)
      songs.size.should == 20

      songs.each do |s|
        s.has_key?(:id).should be_true
        s.has_key?(:title).should be_true
        s.has_key?(:artist).should be_true
        s.has_key?(:album).should be_true
      end
    end
  end

  describe LyricsParser do
    it "should return nil if no record has been found" do
      result = LyricsParser.parse path_of('g-empty.html')
      result.should be_nil
    end

    it "should parse the lyrics" do
      lyrics = <<-LYRICS
歌手:
&#20975;&#33673; &#20811;&#33713;&#20811;&#26862;(Kelly Clarkson)
<br>
专辑:&nbsp;
All I Ever Wanted
<br>
公司：
RCA&#21809;&#29255;(&#32034;&#23612;BMG)
<br>
<br>
Remember all the things we wanted<br> Now all our memories, they&#39;re haunted<br> We were always meant to say goodbye<br> Even with our fists held high<br> It never would&#39;ve worked out right<br> We were never meant for do or die<br> I didn&#39;t want us to burn out<br> I didn&#39;t come here to hold you<br> Now I can&#39;t stop<br> I want you to know that it doesn&#39;t matter<br> Where we take this road<br> Someone&#39;s gotta go<br> And I want you to know<br> You couldn&#39;t have loved me better<br> But I want you to move on<br> So I&#39;m already gone<br> Looking at you makes it harder<br> But I know that you&#39;ll find another<br> That doesn&#39;t always make you want to cry<br> Started with a perfect kiss<br> Then we could feel the poison set in<br> Perfect couldn&#39;t keep this love alive<br> You know that I love you so<br> I love you enough to let you go<br> I want you to know that it doesn&#39;t matter<br> Where we take this road<br> Someone&#39;s gotta go<br> And I want you to know<br> You couldn&#39;t have loved me better<br> But I want you to move on<br> So I&#39;m already gone<br> I&#39;m already gone, already gone<br> You can&#39;t make it feel right<br> When you know that it&#39;s wrong<br> I&#39;m already gone, already gone<br> There&#39;s no moving on<br> So I&#39;m already gone<br> Remember all the things we wanted<br> Now all our memories, they&#39;re haunted<br> We were always meant to say goodbye<br> I want you to know that it doesn&#39;t matter<br> Where we take this road<br> Someone&#39;s gotta go<br> And I want you to know<br> You couldn&#39;t have loved me better<br> But I want you to move on<br> So I&#39;m already gone<br> I&#39;m already gone, already gone<br> You can&#39;t make it feel right<br> When you know that it&#39;s wrong<br> I&#39;m already gone, already gone<br> There&#39;s no moving on<br> So I&#39;m already gone<br>
LYRICS

      result = LyricsParser.parse path_of('g-lyrics.html')

      result[:lyrics].should == lyrics.strip.gsub(/<br>/, '<br />')
    end
  end

  describe DownloadInfoParser do
    it "should return nil if no record has been found" do
      result = DownloadInfoParser.parse path_of('g-empty.html')
      result.should be_nil
    end

    it "should parse the download link" do
      result = DownloadInfoParser.parse path_of('g-download.html')

      result[:size].should == '6.7&nbsp;MB'
      result[:format].should == 'MP3'
      # &amp; is decoded to &
      result[:url].should == '/music/top100/url?q=http%3A%2F%2Ffile3.top100.cn%2F201002182021%2F6606E229A301A32E3EFEDD028337EA8C%2FSpecial_120398%2FAlready%2520Gone.mp3&ct=rdl&cad=dl&ei=uTB9S5CgOZjssQK5t5X8AQ&sig=9BD4F31BB70F31BAB6AD4AECA3C5200D'
    end
  end
end
