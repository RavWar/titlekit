require File.join(File.expand_path(__dir__), '../spec_helper')

describe Titlekit::Mission do

  describe 'Timecode correction' do

    context 'Based on differing framerates' do
      before(:all) do
        @in = File.join(__dir__, 'framerate', 'in.srt')
        @out = File.join(__dir__, 'framerate', 'out.srt')
        @expected = File.join(__dir__, 'framerate', 'expected.srt')

        File.delete(@out) if File.exist?(@out)
      end

      it 'fulfills the mission' do
        mission = Titlekit::Mission.new

        have = mission.have
        have.file(@in)
        have.fps(25)

        want = mission.want
        want.file(@out)
        want.fps(30)

        expect(mission.fulfill).to be_true
      end

      it 'delivers the expected output' do
        expect(FileUtils.compare_file(@out, @expected)).to be_true
      end      
    end

    context 'Based on a single reference' do
      before(:all) do
        @in = File.join(__dir__, 'single_reference', 'in.srt')
        @out = File.join(__dir__, 'single_reference', 'out.srt')
        @expected = File.join(__dir__, 'single_reference', 'expected.srt')

        File.delete(@out) if File.exist?(@out)
      end

      it 'fulfills the mission' do
        mission = Titlekit::Mission.new

        have = mission.have
        have.file(@in)
        have.reference('first subtitle', seconds: 2)

        want = mission.want
        want.file(@out)
        want.reference('first subtitle', seconds: 3.5)

        expect(mission.fulfill).to be_true
      end

      it 'delivers the expected output' do
        expect(FileUtils.compare_file(@out, @expected)).to be_true
      end       
    end

    context 'Based on differing framerates plus a reference' do
      before(:all) do
        @in = File.join(__dir__, 'framerate_plus_reference', 'in.srt')
        @out = File.join(__dir__, 'framerate_plus_reference', 'out.srt')
        @expected = File.join(__dir__, 'framerate_plus_reference', 'expected.srt')

        File.delete(@out) if File.exist?(@out)
      end

      it 'fulfills the mission' do
        mission = Titlekit::Mission.new

        have = mission.have
        have.file(@in)
        have.fps(25)
        have.reference('first subtitle', subtitle: 0)

        want = mission.want
        want.file(@out)
        have.fps(23.976)
        want.reference('first subtitle', seconds: 3.5)

        expect(mission.fulfill).to be_true
      end

      it 'delivers the expected output' do
        expect(FileUtils.compare_file(@out, @expected)).to be_true
      end       
    end

    context 'Based on two references' do
      before(:all) do
        @in = File.join(__dir__, 'double_reference', 'in.srt')
        @out = File.join(__dir__, 'double_reference', 'out.srt')
        @expected = File.join(__dir__, 'double_reference', 'expected.srt')

        File.delete(@out) if File.exist?(@out)
      end

      it 'fulfills the mission' do
        mission = Titlekit::Mission.new

        have = mission.have
        have.file(@in)
        have.reference('first subtitle', seconds: 2.364)
        have.reference('last subtitle', seconds: 24)

        want = mission.want
        want.file(@out)
        want.reference('first subtitle', seconds: 2.4)
        want.reference('last subtitle', seconds: 32)

        expect(mission.fulfill).to be_true
      end

      it 'delivers the expected output' do
        expect(FileUtils.compare_file(@out, @expected)).to be_true
      end
    end

  end
end