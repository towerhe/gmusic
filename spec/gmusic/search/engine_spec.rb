# encoding: UTF-8
describe Gmusic::Search::Engine do
  let(:base_url) { %Q{http://www.google.cn/music/search?q} }
  let(:found_url) { base_url + 'bad+romance+lady+gaga' }
  let(:not_found_url) { base_url + 'not+found' }
  subject { Gmusic::Search::Engine.instance }

  describe '#search' do
    before(:each) do
      prepare_fake_web('search_results.html', found_url)
    end

    let(:query) { { title: 'Bad Romance', artist: 'Lady Gaga'} }

    it 'returns a result object' do
      subject.search(query).should be_a Gmusic::Search::Result
    end

    it 'search result should contain matches info' do
      subject.search(query).info.should eq({"歌曲"=>12, "专辑"=>7, "歌手"=>0})
    end
  end

  #NOTE not finish
  describe '#download' do
    before(:each) do
      @song = Gmusic::Song.new(title: 'for_test', artist: 'nobody', url: 'http://fakelink/')
      prepare_fake_web('download.html', 'http://fakelink/')
      prepare_fake_web('for_test.mp3', "file:///home/jeweller/workspaces/gmusic/spec/web_pages/for_test.mp3")
    end
    after(:all) { clean_up_files_generated_by_fakeweb }

    context "without specifying a directory" do
      let(:default_path) { File.join(Dir.home, 'Downloads', 'gmusic') }

      before(:each) { subject.download(@song) }
      after(:each) { FileUtils.rm_rf default_path }

      it "downloads the song and stored it in ~/Downloads/gmusic" do
        Dir.exists?(default_path).should be
      end

      it { File.exists?(File.join(default_path, 'for_test.mp3')).should be }
    end

    context "specified a directory" do
      let(:store_path) { File.join(Dir.home, 'Desktop', 'gmusic') }

      before(:each) { subject.download(@song, store_path) }
      after(:all) { FileUtils.rm_rf store_path }

      it 'downloads ths song and stored it the given directory' do
        Dir.exists?(store_path).should be
      end

      it { File.exists?(File.join(store_path, 'for_test.mp3')).should be }
    end
  end

  describe 'private instance methods' do
    let(:agent) { subject.send(:agent) }

    describe '#extract_info_from' do
      context 'when not found' do
        before(:each) do
          prepare_fake_web('not_found.html', not_found_url)
          @page = agent.get not_found_url
        end

        it 'raises NotFound' do
          expect do
            subject.send(:extract_info_from, @page)
          end.to raise_error('Gmusic::Search::NotFound')
        end
      end

      context 'when found' do
        before(:each) do
          prepare_fake_web('search_results.html', found_url)
          @page = agent.get found_url
          @info = subject.send(:extract_info_from, @page)
        end

        it 'result info should be a hash' do
          @info.should be_a Hash
        end

        %W{歌曲 专辑 歌手}.each do |key|
          it "result info should have key #{key}" do
            @info.should include key
          end
        end
      end
    end

    #describe '.collect_links_from' do
      #before(:each) do
        #prepare_fake_web('search_results.html', found_url)
        #@page = agent.get found_url
      #end

      #subject { Gmusic::Search::Agent.send(:collect_links_from, @page) }

      #it 'returns an array of links' do
        #should be_an Array
      #end
      #its(:first) { should be_a Gmusic::Link }
      #it { should have_at_least(1).item }
    #end

    describe '#collect_details_from' do
      before(:each) do
        prepare_fake_web('search_results.html', found_url)
        @page = agent.get found_url
        @details = subject.send(:collect_details_from, @page)
      end

      it 'returns an array of links' do
        @details.should be_an Array
      end
      [:title, :artist, :url].each do |key|
        it "details should have key #{key}" do
          @details.first.should have_key key
        end
      end
    end

    describe '#format' do
      it 'replaces blank space to +' do
        subject.send(:encode_www_form, [' word1  ','  word2']).should eq 'word1+word2'
      end
    end

    describe '#format_url' do
      it 'formats the base url with the given hash' do
        hash = {
          title: 'bad romance',
          artist: 'Lady Gaga',
          album: 'The Fame Monster',
          lyric: 'GaGa oh la la'
        }
        url = "#{base_url}bad+romance+lady+gaga+the+fame+monster+gaga+oh+la+la"

        subject.send(:format_url, base_url, hash).should eq url
      end
    end

    describe '#sanitize_dirname' do
      let(:shorten_dir) { '~/Desktop' }
      let(:invalid_dir) { ' (invalid)*/&dir@   ' }

      it "replace '~' to user's home directory" do
        subject.send(:sanitize_dirname, shorten_dir).should eq "#{Dir.home}/Desktop"
      end

      it "sanitizes directory name by replacing invalid charactor to '_'" do
        subject.send(:sanitize_dirname, invalid_dir).should eq '_invalid__/_dir_'
      end
    end

    describe '#mkdir' do
      context 'when the given arg is nil' do
        let(:path) { nil }

        it 'makes ~/Downloads/gmusic' do
          subject.send(:mkdir, path)
          dir_exist?("#{Dir.home}/Downloads/gmusic").should be
        end

        it "returns dirname" do
          subject.send(:mkdir, path).should eq "#{Dir.home}/Downloads/gmusic"
        end
      end

      context 'when dir exists' do
        let(:path) { path = Dir.pwd }

        it 'returns dirname' do
          subject.send(:mkdir, path).should eq path
        end
      end

      context 'when given absolute path' do
        let(:path) { "#{Dir.pwd}/for_test" }

        it 'makes dir' do
          subject.send(:mkdir, path)
          dir_exist?(path).should be
        end

        it 'returns dirname' do
          subject.send(:mkdir, path).should eq path
        end
      end

      context 'when given relative path' do
        let(:path) { './for_test' }

        it 'makes dir' do
          subject.send(:mkdir, path)
          dir_exist?(path).should be
        end

        it 'returns dirname' do
          subject.send(:mkdir, path).should eq path
        end
      end
    end
  end
end