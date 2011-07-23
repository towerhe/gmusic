require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Gmusic" do
  it "should raise ArgumentError if the argument 'conditions' is empty" do
    lambda { GMusic.search({}) }.should raise_error ArgumentError
  end

  it "should raise ArgumentError if there is no valid condition specified" do
    lambda { GMusic.search(:invalid => 'test') }.should raise_error ArgumentError
  end

  it "should return an empty array if nothing is matched" do
    GMusic::SongListParser.should_receive(:parse).and_return([])
    GMusic.search(:title => 'inexistence').empty?.should be_true
  end

  it "should only return the full matched item" do
    parsed = GMusic::SongListParser.parse path_of('g-search-alreadygone.html')
    dowload_info = GMusic::DownloadInfoParser.parse path_of('g-download.html')
    lyrics = GMusic::LyricsParser.parse path_of('g-lyrics.html')

    GMusic::SongListParser.should_receive(:parse).and_return(parsed)
    GMusic::DownloadInfoParser.should_receive(:parse).and_return(dowload_info)
    GMusic::LyricsParser.should_receive(:parse).and_return(lyrics)
    songs = GMusic.search(:title => 'already gone', :artist => 'kelly clarkson')
    
    songs.size.should == 1
  end

  it "should return 6 full matched items" do
    parsed = GMusic::SongListParser.parse path_of('g-search-thankyou.html')
    dowload_info = GMusic::DownloadInfoParser.parse path_of('g-download.html')
    lyrics = GMusic::LyricsParser.parse path_of('g-lyrics.html')
    
    GMusic::SongListParser.should_receive(:parse).and_return(parsed)
    GMusic::DownloadInfoParser.should_receive(:parse).exactly(6).times.and_return(dowload_info)
    GMusic::LyricsParser.should_receive(:parse).exactly(6).times.and_return(lyrics)

    songs = GMusic.search(:title => 'thank you', :artist => 'dido')
    
    songs.size.should == 6 
  end
end
