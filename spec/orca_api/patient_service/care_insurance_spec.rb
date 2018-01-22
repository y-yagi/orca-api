require "spec_helper"
require_relative "../shared_examples"

RSpec.describe OrcaApi::PatientService::CareInsurance, orca_api_mock: true do
  let(:service) { described_class.new(orca_api) }

  describe "#get" do
    context "正常系" do
      it "介護保険情報の登録内容を取得できること" do
        expect_data = [
          {
            path: "/orca12/patientmodv36",
            body: {
              "=patientmodv3req6" => {
                "Request_Number" => "01",
                "Karte_Uid" => orca_api.karte_uid,
                "Patient_Information" => {
                  "Patient_ID" => "1",
                }
              }
            },
            result: "orca12_patientmodv36_get_01.json",
          },
          {
            path: "/orca12/patientmodv36",
            body: {
              "=patientmodv3req6" => {
                "Request_Number" => "99",
                "Karte_Uid" => '`prev.karte_uid`',
                "Orca_Uid" => "`prev.orca_uid`",
              }
            },
            result: "orca12_patientmodv36_99.json",
          },
        ]

        expect_orca_api_call(expect_data, binding)

        result = service.get(1)

        expect(result.ok?).to be true
      end
    end
  end

  describe "#update" do
    context "正常系" do
      it "介護保険情報を更新できること" do
        args = {
          "Care_Insurance_Information": {
            "Insurance_Mode": "Modify",
            "Care_Insurance_Info": [
              {
                "InsuranceProvider_Number": "1",
                "HealthInsuredPerson_Number": "",
                "Certificate_StartDate": "2018-01-01",
                "Certificate_ExpiredDate": "2018-03-01"
              }
            ]
          }
        }

        expect_data = [
          {
            path: "/orca12/patientmodv36",
            body: {
              "=patientmodv3req6" => {
                "Request_Number" => "01",
                "Karte_Uid" => orca_api.karte_uid,
                "Patient_Information" => {
                  "Patient_ID" => "1",
                }
              }
            },
            result: "orca12_patientmodv36_update__modify_01.json",
          },
          {
            path: "/orca12/patientmodv36",
            body: {
              "=patientmodv3req6" => args.merge(
                "Request_Number" => '`prev.response_number`',
                "Karte_Uid" => '`prev.karte_uid`',
                "Orca_Uid" => "`prev.orca_uid`",
                "Patient_Information" => "`prev.patient_information`"
              ),
            },
            result: "orca12_patientmodv36_update__modify_02.json",
          },
        ]

        expect_orca_api_call(expect_data, binding)

        result = service.update(1, args)

        expect(result.ok?).to be true
      end

      it "介護保険情報を削除できること" do
        args = {
          "Care_Insurance_Information": {
            "Insurance_Mode": "Delete",
          }
        }

        expect_data = [
          {
            path: "/orca12/patientmodv36",
            body: {
              "=patientmodv3req6" => {
                "Request_Number" => "01",
                "Karte_Uid" => orca_api.karte_uid,
                "Patient_Information" => {
                  "Patient_ID" => "1",
                }
              }
            },
            result: "orca12_patientmodv36_update__delete_01.json",
          },
          {
            path: "/orca12/patientmodv36",
            body: {
              "=patientmodv3req6" => args.merge(
                "Request_Number" => '`prev.response_number`',
                "Karte_Uid" => '`prev.karte_uid`',
                "Orca_Uid" => "`prev.orca_uid`",
                "Patient_Information" => "`prev.patient_information`"
              ),
            },
            result: "orca12_patientmodv36_update__delete_02.json",
          },
        ]

        expect_orca_api_call(expect_data, binding)

        result = service.update(1, args)

        expect(result.ok?).to be true
      end
    end
  end
end
