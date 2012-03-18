# encoding: UTF-8
describe Gmusic::Search::Agent do
  let(:base_url) { %Q{http://www.google.cn/music/search?q} }
  let(:found_url) { base_url + 'bad+romance+lady+gaga' }
  let(:not_found_url) { base_url + 'not+found' }

  describe '.search' do
    before(:each) do
      prepare_fake_web('search_results.html', found_url)
    end

    let(:query) { { title: 'Bad Romance', artist: 'Lady Gaga'} }
    subject { Gmusic::Search::Agent.search(query) }

    it 'returns a result object' do
      should be_a Gmusic::Search::Result
    end

    its(:info) { should eq({"歌曲"=>12, "专辑"=>7, "歌手"=>0}) }
  end

  #NOTE not finish
  describe '.download' do
    before(:each) do
      @song = Gmusic::Song.new(title: 'for_test', artist: 'nobody', link: 'http://fakelink/')
      prepare_fake_web('download.html', 'http://fakelink/')
      prepare_fake_web('for_test.mp3', "file:///home/jeweller/workspaces/gmusic/spec/web_pages/for_test.mp3")
    end
    after(:all) { clean_up_files_generated_by_fakeweb }

    context "without specifying a directory" do
      let(:default_path) { File.join(Dir.home, 'Downloads', 'gmusic') }

      before(:each) { Gmusic::Search::Agent.download(@song) }
      after(:each) { FileUtils.rm_rf default_path }

      it "downloads the song and stored it in ~/Downloads/gmusic" do
        Dir.exists?(default_path).should be
      end

      it { File.exists?(File.join(default_path, 'for_test.mp3')).should be }
    end

    context "specified a directory" do
      let(:store_path) { File.join(Dir.home, 'Desktop', 'gmusic') }

      before(:each) { Gmusic::Search::Agent.download(@song, store_path) }
      after(:all) { FileUtils.rm_rf store_path }

      it 'downloads ths song and stored it the given directory' do
        Dir.exists?(store_path).should be
      end

      it { File.exists?(File.join(store_path, 'for_test.mp3')).should be }
    end
  end

  describe 'private class methods' do
    let(:agent) { Gmusic::Search::Agent.send(:agent) }

    describe '.extract_info_from' do
      context 'when not found' do
        before(:each) do
          prepare_fake_web('not_found.html', not_found_url)
          @page = agent.get not_found_url
        end

        it 'raises NotFound' do
          expect do
            Gmusic::Search::Agent.send(:extract_info_from, @page)
          end.to raise_error('Gmusic::Search::NotFound')
        end
      end

      context 'when found' do
        before(:each) do
          prepare_fake_web('search_results.html', found_url)
          @page = agent.get found_url
        end

        subject { Gmusic::Search::Agent.send(:extract_info_from, @page) }

        it { should be_a Hash }
        its(:keys) { should include '歌曲' }
        its(:keys) { should include '专辑' }
        its(:keys) { should include '歌手' }
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

    describe '.collect_details_from' do
      before(:each) do
        prepare_fake_web('search_results.html', found_url)
        @page = agent.get found_url
      end

      subject { Gmusic::Search::Agent.send(:collect_details_from, @page) }

      it 'returns an array of links' do
        should be_an Array
      end
      its(:first) { should be_a Hash }
      its(:first) { should have_key :title }
      its(:first) { should have_key :artist }
      its(:first) { should have_key :link }
    end

    describe '.format' do
      it 'replaces blank space to +' do
        Gmusic::Search::Agent.send(:encode_www_form, [' word1  ','  word2']).should eq 'word1+word2'
      end
    end

    describe '.format_url' do
      it 'formats the base url with the given hash' do
        hash = {
          title: 'bad romance',
          artist: 'Lady Gaga',
          album: 'The Fame Monster',
          lyric: 'GaGa oh la la'
        }
        url = "#{base_url}bad+romance+lady+gaga+the+fame+monster+gaga+oh+la+la"

        Gmusic::Search::Agent.send(:format_url, base_url, hash).should eq url
      end
    end

    describe '.sanitize_dirname' do
      let(:shorten_dir) { '~/Desktop' }
      let(:invalid_dir) { ' (invalid)*/&dir@   ' }

      it "replace '~' to user's home directory" do
        Gmusic::Search::Agent.send(:sanitize_dirname, shorten_dir).should eq "#{Dir.home}/Desktop"
      end

      it "sanitizes directory name by replacing invalid charactor to '_'" do
        Gmusic::Search::Agent.send(:sanitize_dirname, invalid_dir).should eq '_invalid__/_dir_'
      end
    end

    describe '.mkdir' do
      context 'when the given arg is nil' do
        let(:path) { nil }
        subject { Gmusic::Search::Agent.send(:mkdir, path) }

        it 'makes ~/Downloads/gmusic' do
          subject
          dir_exist?("#{Dir.home}/Downloads/gmusic").should be
        end

        it "returns dirname" do
          subject.should eq "#{Dir.home}/Downloads/gmusic"
        end
      end

      context 'when dir exists' do
        let(:path) { path = Dir.pwd }
        subject { Gmusic::Search::Agent.send(:mkdir, path) }

        it 'returns dirname' do
          subject.should eq path
        end
      end

      context 'when given absolute path' do
        let(:path) { "#{Dir.pwd}/for_test" }
        subject { Gmusic::Search::Agent.send(:mkdir, path) }

        it 'makes dir' do
          dir_exist?(path).should be
        end

        it 'returns dirname' do
          subject.should eq path
        end
      end

      context 'when given relative path' do
        let(:path) { './for_test' }
        subject { Gmusic::Search::Agent.send(:mkdir, path) }

        it 'makes dir' do
          dir_exist?(path).should be
        end

        it 'returns dirname' do
          subject.should eq path
        end
      end
    end

  end
end
