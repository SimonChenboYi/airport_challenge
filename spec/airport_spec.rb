require 'airport'

describe Airport do

  before(:each) do
    @weather = double :weather
    @subject = described_class.new(weather)
    @plane = double :plane
    @plane2 = double :plane
    @plane3 = double :plane
  end

  context "when is not stormy:" do
    attr_reader :weather, :subject, :plane, :plane2, :plane3

    describe '#land' do
      it 'land a plane' do
        allow(weather).to receive(:stormy?).and_return(false)
        [plane, plane2, plane3].map { |p| subject.land(p) }
        expect(subject.airport_apron.last).to eq plane3
      end
    end

    describe '#take_off' do

      it 'take off a plane' do
        allow(weather).to receive(:stormy?).and_return(false)
        allow(plane).to receive(:taken_off?).and_return(true)
        [plane, plane2, plane3].map { |p| subject.land(p) }
        taking_off_plane = subject.take_off
        expect(taking_off_plane.taken_off?).to eq true
      end

      it 'take off the frist plane' do
        allow(weather).to receive(:stormy?).and_return(false)
        allow(plane).to receive(:taken_off?).and_return(true)
        [plane, plane2, plane3].map { |p| subject.land(p) }
        expect(subject.take_off).to eq plane
      end

      it 'update the airport_apron stock' do
        allow(weather).to receive(:stormy?).and_return(false)
        allow(plane).to receive(:taken_off?).and_return(true)
        [plane, plane2, plane3].map { |p| subject.land(p) }
        subject.take_off
        expect(subject.airport_apron.size).to eq 2
      end
    end
  end

  context "when stormy:" do
    attr_reader :weather, :subject, :plane

    describe '#land' do
      it "prevent land" do
        allow(weather).to receive(:stormy?).and_return(true)
        expect { subject.land(plane) }.to raise_error "it is stormy"
      end
    end

    describe '#take_off' do
      it "prevent takeoff" do
        allow(weather).to receive(:stormy?).and_return(true)
        expect { subject.take_off }.to raise_error "it is stormy"
      end
    end
  end
end
