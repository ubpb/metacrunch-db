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

  context "when data exists" do
    before {
      dest = Metacrunch::DB::Destination.new(DB[:users])
      10.times { |i| dest.write({id: i, name: "name-#{i}"}) }
    }

    describe "#write" do
      context "when use_upsert = true" do
        subject { Metacrunch::DB::Destination.new(DB[:users], use_upsert: true) }

        it "updates existing data" do
          data = []

          10.times do |i|
            data << {id: i, name: "updated-name-#{i}"}
          end

          subject.write(data)

          expect(DB[:users].where(id: 2).first).to eq({:id=>2, :name=>"updated-name-2"})
        end
      end

      context "when use_upsert = false" do
        subject { Metacrunch::DB::Destination.new(DB[:users], use_upsert: false) }

        it "raises an error" do
          data = []

          10.times do |i|
            data << {id: i, name: "updated-name-#{i}"}
          end

          expect {
            subject.write(data)
          }.to raise_error(Sequel::UniqueConstraintViolation)
        end
      end
    end
  end

  context "when use_upsert = true and no data exists" do
    subject { Metacrunch::DB::Destination.new(DB[:users], use_upsert: true) }

    describe "#write" do
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
