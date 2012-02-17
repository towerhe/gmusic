describe Gmusic::Song do
  describe '.search_by_title' do
    let(:base_url) { %Q{http://www.google.cn/music/search?q=} }

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

  describe '.new' do
    let(:valid_attrs) { {title: 'valid title', artist: 'lady gaga', link: 'http://ladygaga.com'} }
    
    context 'with invalid attributes' do
      it 'raise InvalidAttributesError when attrs not contains title, artist and link' do
        expect { Gmusic::Song.new({}) }.to raise_error(Gmusic::InvalidAttributesError, 'only title, artist and link is allowed')
      end
      it 'raise InvalidAttributesError when attrs contains more than title, artist and link' do
        expect do
          Gmusic::Song.new(valid_attrs.merge({invalid: ''}))
        end.to raise_error(Gmusic::InvalidAttributesError, 'only title, artist and link is allowed')
      end
    end
    context "with valid attributes" do
      it 'initialize a new song when attrs only contains title, atrist and link' do
        expect { Gmusic::Song.new(valid_attrs) }.not_to raise_error
      end
    end
  end
end
