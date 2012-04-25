describe Gmusic::Song do

  let(:base_url) { %Q{http://www.google.cn/music/search?q=} }

  describe '.search_by_title' do

    context 'when nothing found' do
      before(:each) do
        not_found_url = base_url + 'not+found'
        prepare_fake_web('not_found.html', not_found_url)
      end

      it 'returns an empty array' do
        Gmusic::Song.search_by_title('not found').should have(0).songs
      end
    end

    context "when found" do
      before(:each) do
        found_url = base_url + 'bad+romance'
        prepare_fake_web('search_results.html', found_url)
      end

      subject { Gmusic::Song.search_by_title('bad romance') }

      it 'returns an array of songs' do
        should have_at_least(1).song
      end

      its(:first) { should be_a Gmusic::Song }

      it 'returns relative songs' do
        subject.each { |song| song.title.should match /bad|romance/i }
      end
    end
  end

  describe '.download' do
    #before(:each) do
      #found_url = base_url + 'bad+romance'
      #prepare_fake_web('search_results.html', found_url)
    #end

    let(:title) { 'bad romance' }
    subject { Gmusic::Song.download(title) }

    context 'when not found' do
      it 'returns false' do
        Gmusic::Song.should_receive(:search_by_title).with(title).and_return([])

        Gmusic::Song.download(title).should eq false
      end
    end

    context "when found" do
      before(:each) do
        songs = [Gmusic::Song.new(title: title, artist: 'lady gaga', url: 'http://ladygaga.com/bad-romance.mp3')]
        Gmusic::Song.should_receive(:search_by_title).with(title).and_return(songs)
        songs.first.should_receive(:save).and_return(true)
      end

      it { should be true }
    end
  end

  describe '.new' do
    let(:valid_attrs) { {title: 'valid title', artist: 'lady gaga', url: 'http://ladygaga.com'} }

    context 'with invalid attributes' do
      it 'raise InvalidAttributesError when attrs not contains title, artist and url' do
        expect do
          Gmusic::Song.new({})
        end.to raise_error(Gmusic::InvalidAttributesError, 'only title, artist and url is allowed')
      end
      it 'raise InvalidAttributesError when attrs contains more than title, artist and url' do
        expect do
          Gmusic::Song.new(valid_attrs.merge({invalid: ''}))
        end.to raise_error(Gmusic::InvalidAttributesError, 'only title, artist and url is allowed')
      end
    end
    context "with valid attributes" do
      it 'initialize a new song when attrs only contains title, atrist and url' do
        expect { Gmusic::Song.new(valid_attrs) }.not_to raise_error
      end
    end
  end
end
