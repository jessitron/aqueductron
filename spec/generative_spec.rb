require 'generative'

describe String do
  let(:string) { "abc" }

  describe "reverse" do
    it "reverses" do
      expect(string.reverse).to eq("cba")
    end

    generative do
      data(:string) { rand(12345).to_s }

      it "maintains length" do
        expect(string.reverse.length).to eq(string.length)
      end

      it "is not destructive" do
        expect(string.reverse.reverse).to eq(string)
      end
    end
  end
end
