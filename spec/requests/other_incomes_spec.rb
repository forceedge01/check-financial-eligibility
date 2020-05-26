require 'rails_helper'

RSpec.describe OtherIncomesController, type: :request do
  describe 'POST other_income' do
    let(:assessment) { create :assessment, :with_gross_income_summary }
    let(:assessment_id) { assessment.id }
    let(:gross_income_summary) { assessment.gross_income_summary }
    let(:params) { other_income_params  }
    let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }

    subject { post assessment_other_incomes_path(assessment_id), params: params.to_json, headers: headers }

    UUID_REGEX = /^[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}$/.freeze

    context 'valid payload' do
      context 'with two sources' do
        it 'returns http success', :show_in_doc do
          subject
          expect(response).to have_http_status(:success)
        end

        it 'creates two other income source records' do
          expect { subject }.to change { gross_income_summary.other_income_sources.count }.by(2)
          sources = gross_income_summary.other_income_sources.order(:name)
          expect(sources.first.name).to eq 'friends_or_family'
          expect(sources.last.name).to eq 'student_loan'
        end

        it 'creates the required number of OtherIncomePayment record for each source' do
          expect { subject }.to change { OtherIncomePayment.count }.by(6)
          source = gross_income_summary.other_income_sources.order(:name).first
          expect(source.other_income_payments.count).to eq 3
          payments = source.other_income_payments.order(:payment_date)

          expect(payments[0].payment_date).to eq Date.new(2019, 9, 1)
          expect(payments[0].amount).to eq 250.00
          expect(payments[0].client_id).to match UUID_REGEX

          expect(payments[1].payment_date).to eq Date.new(2019, 10, 1)
          expect(payments[1].amount).to eq 266.02
          expect(payments[1].client_id).to match UUID_REGEX

          expect(payments[2].payment_date).to eq Date.new(2019, 11, 1)
          expect(payments[2].amount).to eq 250.00
          expect(payments[2].client_id).to match UUID_REGEX
        end

        it 'creates records with client id where specified' do
          subject
          source = gross_income_summary.other_income_sources.order(:name).last
          source.other_income_payments.each do |rec|
            expect(rec.client_id).to match UUID_REGEX
          end
        end

        it 'returns a JSON representation of the other income records' do
          subject
          expect(parsed_response[:objects].size).to eq 2
          expect(parsed_response[:errors]).to be_empty
          expect(parsed_response[:success]).to eq true

          source = gross_income_summary.other_income_sources.find_by(name: 'student_loan')
          expect(parsed_response[:objects].first[:id]).to eq source.id
          expect(parsed_response[:objects].first[:gross_income_summary_id]).to eq gross_income_summary.id
          expect(parsed_response[:objects].first[:name]).to eq 'student_loan'

          source = gross_income_summary.other_income_sources.find_by(name: 'friends_or_family')
          expect(parsed_response[:objects].last[:id]).to eq source.id
          expect(parsed_response[:objects].last[:gross_income_summary_id]).to eq gross_income_summary.id
          expect(parsed_response[:objects].last[:name]).to eq 'friends_or_family'
        end
      end
    end

    context 'invalid_payload' do
      context 'missing source in the second element' do
        let(:params) do
          new_hash = other_income_params
          new_hash[:other_incomes].last.delete(:source)
          new_hash
        end

        it 'returns unsuccessful' do
          subject
          expect(response.status).to eq 422
        end

        it 'contains success false in the response body' do
          subject
          expect(parsed_response).to eq(errors: ['Missing parameter source'], success: false)
        end

        it 'does not create any other income source records' do
          expect { subject }.not_to change { OtherIncomeSource.count }
        end

        it 'does not create any other income payment records' do
          expect { subject }.not_to change { OtherIncomePayment.count }
        end
      end

      context 'missing required parameter client_id' do
        let(:params) do
          new_hash = other_income_params
          new_hash[:other_incomes].last[:payments].first.delete(:client_id)
          new_hash
        end

        it 'returns unsuccessful' do
          subject
          expect(response.status).to eq 422
        end

        it 'contains success false in the response body' do
          subject
          expect(parsed_response).to eq(errors: ['Missing parameter client_id'], success: false)
        end

        it 'does not create any other income source records' do
          expect { subject }.not_to change { OtherIncomeSource.count }
        end

        it 'does not create any other income payment records' do
          expect { subject }.not_to change { OtherIncomePayment.count }
        end
      end

      context 'invalid source' do
        let(:params) do
          new_hash = other_income_params
          new_hash[:other_incomes].last[:source] = 'imagined_source'
          new_hash
        end

        it 'returns unsuccessful' do
          subject
          expect(response.status).to eq 422
        end

        it 'contains success false in the response body' do
          subject
          expect(parsed_response[:success]).to be false
        end

        it 'contains an error message' do
          subject
          expect(parsed_response[:errors].first).to match(/Invalid parameter 'source'/)
        end
      end
    end

    context 'invalid_assessment_id' do
      let(:assessment_id) { SecureRandom.uuid }

      it 'returns unsuccessful' do
        subject
        expect(response.status).to eq 422
      end

      it 'contains success false in the response body' do
        subject
        expect(parsed_response).to eq(errors: ['No such assessment id'], success: false)
      end
    end

    def other_income_params
      {
        other_incomes: [
          {
            source: 'student_loan',
            payments: [
              {
                date: '2019-11-01',
                amount: 1046.44,
                client_id: SecureRandom.uuid
              },
              {
                date: '2019-10-01',
                amount: 1034.33,
                client_id: SecureRandom.uuid
              },
              {
                date: '2019-09-01',
                amount: 1033.44,
                client_id: SecureRandom.uuid
              }
            ]
          },
          {
            source: 'friends_or_family',
            payments: [
              {
                date: '2019-11-01',
                amount: 250.00,
                client_id: SecureRandom.uuid
              },
              {
                date: '2019-10-01',
                amount: 266.02,
                client_id: SecureRandom.uuid
              },
              {
                date: '2019-09-01',
                amount: 250.00,
                client_id: SecureRandom.uuid
              }
            ]
          }
        ]
      }
    end
  end
end
