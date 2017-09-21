describe Metacrunch::DB::Source do

  DB_URL = "sqlite://#{File.join(asset_dir, "dummy.sqlite")}"

  context "given an unordered Sequel dataset" do
    let(:database) { Sequel.connect(DB_URL) }
    let(:dataset) { database[:users] }

    describe "#initialize" do
      it "throws an error" do
        expect{
          Metacrunch::DB::Source.new(dataset)
        }.to raise_error(ArgumentError)
      end
    end
  end

  context "given an ordered Sequel dataset" do
    let(:database) { Sequel.connect(DB_URL) }
    let(:dataset) { database[:users].order(:id) }
    subject { Metacrunch::DB::Source.new(dataset) }

    describe "#each" do
      it "yields every row in the dataset" do
        users = []
        subject.each {|row| users << row}
        expect(users.count).to eq(100)
      end
    end
  end

end
