# frozen_string_literal: true

shared_examples 'create an initiative' do |with_author|
  let(:initiative_type) { create(:initiatives_type) }
  let(:author) { create(:user, organization: initiative_type.organization) } if with_author

  let(:form) do
    form_klass.from_params(
      form_params
    ).with_context(
      current_organization: initiative_type.organization,
      current_feature: nil
    )
  end

  describe 'call' do
    let(:form_params) do
      {
        title: 'A reasonable initiative title',
        description: 'A reasonable initiative description',
        type_id: initiative_type.id,
        signature_type: 'online',
        decidim_scope_id: nil,
        decidim_user_group_id: nil
      }
    end

    let(:command) do
      if with_author
        described_class.new(form, author)
      else
        described_class.new(form)
      end
    end

    describe 'when the form is not valid' do
      before do
        expect(form).to receive(:invalid?).and_return(true)
      end

      it 'broadcasts invalid' do
        expect { command.call }.to broadcast(:invalid)
      end

      it "doesn't create an initiative" do
        expect do
          command.call
        end.not_to change { Decidim::Initiative.count }
      end
    end

    describe 'when the form is valid' do
      it 'broadcasts ok' do
        expect { command.call }.to broadcast(:ok)
      end

      it 'creates a new initiative' do
        expect do
          command.call
        end.to change { Decidim::Initiative.count }.by(1)
      end

      if with_author
        it 'sets the author' do
          command.call
          proposal = Decidim::Initiative.last

          expect(proposal.author).to eq(author)
        end
      end

      it 'Default state is created' do
        command.call
        proposal = Decidim::Initiative.last

        expect(proposal.created?).to be_truthy
      end

      it 'Title and description are stored with its locale' do
        command.call
        proposal = Decidim::Initiative.last

        expect(proposal.title.keys).not_to be_empty
        expect(proposal.description.keys).not_to be_empty
      end

      it 'Voting interval is not set yet' do
        command.call
        proposal = Decidim::Initiative.last

        expect(proposal).not_to have_signature_interval_defined
      end
    end
  end
end
