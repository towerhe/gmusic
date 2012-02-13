# encoding: UTF-8
describe Gmusic::Search::Agent do
  let(:base_url) { %Q{http://www.google.cn/music/search?q} }
  let(:found_url) { base_url + 'bad%20romance%20lady%20gaga' }
  let(:not_found_url) { base_url + 'not%20found' }

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

  describe 'private class methods' do
    let(:agent) { Gmusic::Search::Agent.send(:agent) }

    describe '.extract_info_from' do
      describe 'when not found' do
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

      describe 'when found' do
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

    describe '.collect_links_from' do
      before(:each) do
        prepare_fake_web('search_results.html', found_url)
        @page = agent.get found_url
      end

      subject { Gmusic::Search::Agent.send(:collect_links_from, @page) }

      it { should be_an Array }
      its(:first) { should be_a Hash }
      its(:first) { should have_key :title }
      its(:first) { should have_key :link }
    end

    describe '.format' do
      it 'replaces blank space to %20' do
        Gmusic::Search::Agent.send(:format, ' word1  word2   ').should eq 'word1%20word2'
      end
    end

    describe '.format_url' do
      it 'formats the base url with the given hash' do
        hash = { title: 'bad romance', artist: 'Lady Gaga', album: 'The Fame Monster', lyric: 'GaGa oh la la'}
        url = "#{base_url}bad%20romance%20lady%20gaga%20the%20fame%20monster%20gaga%20oh%20la%20la"

        Gmusic::Search::Agent.send(:format_url, base_url, hash).should eq url
      end
    end
  end
end
