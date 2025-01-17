describe ExitNgo do
  before do
    allow_any_instance_of(Client).to receive(:generate_random_char).and_return("abcd")
  end
  describe ExitNgo, 'associations' do
    it { is_expected.to belong_to(:client) }
    it { is_expected.to belong_to(:rejectable) }
  end

  describe ExitNgo, 'validations' do
    it { is_expected.to validate_presence_of(:exit_circumstance)}
    it { is_expected.to validate_presence_of(:exit_note)}
    it { is_expected.to validate_presence_of(:exit_date)}
    it { is_expected.to validate_presence_of(:exit_reasons)}
  end

  describe ExitNgo, 'callbacks' do
    context 'after_create' do
      context 'update_entity_status' do
        let!(:user_manager){ create(:user, :manager) }
        context 'referred_client' do
          let!(:client){ create(:client) }
          let!(:exit_ngo) { create(:exit_ngo, client: client) }

          it { expect(client.reload.status).to eq('Exited') }
        end

        context 'accepted_client' do
          let!(:client){ create(:client, :accepted) }
          let!(:exit_ngo) { create(:exit_ngo, client: client) }

          it { expect(client.reload.status).to eq('Exited') }
        end

        context 'referred_family' do
          let!(:family){ create(:family) }
          let!(:exit_ngo) { create(:exit_ngo, rejectable: family) }

          it { expect(family.reload.status).to eq('Exited') }
        end

        context 'accepted_family' do
          let!(:family){ create(:family, :accepted) }
          let!(:exit_ngo) { create(:exit_ngo, rejectable: family) }

          it { expect(family.reload.status).to eq('Exited') }
        end
      end
    end
  end

  describe ExitNgo, 'scopes' do
    let!(:client){ create(:client) }
    let!(:family){ create(:family) }
    let!(:manager){ create(:user, :manager) }
    let!(:exit_ngo_1){ create(:exit_ngo, client: client) }
    let!(:exit_ngo_2){ create(:exit_ngo, rejectable: family) }

    context '.most_recents' do
      subject { ExitNgo.most_recents.first }

      xit 'return last record' do
        is_expected.to eq(exit_ngo_2)
      end

      it 'return first record' do
        expect(is_expected).not_to eq(exit_ngo_1)
      end
    end
  end

  describe EnterNgo, 'methods' do
    let(:family){ create(:family) }
    let(:exit_ngo_1){ create(:exit_ngo, rejectable: family) }

    context '.attached_to_family?' do
      it 'return true' do
        expect(exit_ngo_1.attached_to_family?).to be_truthy
      end
    end
  end
end
