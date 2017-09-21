describe Metacrunch::DB::Destination do

  DB = Sequel.sqlite # in memory

  before(:all) do
    DB.create_table(:users) do
      primary_key :id
      String :name
    end
  end

  before(:each) do
    DB[:users].delete
  end

  describe "#write" do
    subject { Metacrunch::DB::Destination.new(DB[:users]) }

    context "when data is a hash" do
      it "writes data into database" do
        10.times do |i|
          subject.write({id: i, name: "name-#{i}"})
        end

        expect(DB[:users].count).to eq(10)
      end
    end

    context "when data is an array of hashes" do
      it "writes data into database" do
        data = []

        10.times do |i|
          data << {id: i, name: "name-#{i}"}
        end

        subject.write(data)

        expect(DB[:users].count).to eq(10)
      end
    end
  end

  describe "#close" do
    subject { Metacrunch::DB::Destination.new(DB[:users]) }

    it "closes db connection" do
      subject.close
      expect(DB.pool.available_connections).to be_empty
    end
  end

end
